//
// Created by Felipe Lobo on 27/08/21.
//

#import "OPAOpusDecoder.h"
#import <libopus/libopus-umbrella.h>
#import <AVFAudio/AVFAudio.h>

@implementation OPAOpusDecoder {
    __strong AVAudioFormat *_defaultAudioFormat;
    OpusDecoder *_decoder;
    OPAOpusSampleRate _sampleRate;
    OPAOpusChannelLayout _channelLayout;
}

- (instancetype)init {
    return [self initWithSampleRate:[Opus defaultSampleRate] channels:[Opus defaultChannelLayout]];
}

- (instancetype)initWithSampleRate:(OPAOpusSampleRate)sampleRate channels:(OPAOpusChannelLayout)channels
{
    self = [super init];
    if (self) {
        _sampleRate = sampleRate;
        _channelLayout = channels;
        _decoder = opus_decoder_create(sampleRate, channels, NULL);
        _defaultAudioFormat = [[AVAudioFormat alloc]
                initWithCommonFormat:AVAudioPCMFormatFloat32
                          sampleRate:_sampleRate
                            channels:_channelLayout
                         interleaved:NO];
    }
    return self;
}

- (AVAudioPCMBuffer *)decodedBufferFromData:(NSData *)data
{
    const int frameSize = _sampleRate / 1000 * 60;
    const size_t max_bytes = frameSize * _channelLayout * sizeof(float);

    float *pcm = malloc(max_bytes);

    opus_int32 result = opus_decode_float(_decoder, data.bytes, (opus_int32)data.length, pcm, frameSize, 0);

    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc]
            initWithPCMFormat:_defaultAudioFormat
                frameCapacity:(uint32_t)result];
    buffer.frameLength = buffer.frameCapacity;

    memcpy(buffer.floatChannelData[0], pcm, result * sizeof(float));

    free(pcm);

    return buffer;
}

@end
