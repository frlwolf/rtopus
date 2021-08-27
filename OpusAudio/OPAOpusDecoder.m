//
// Created by Felipe Lobo on 27/08/21.
//

#import "OPAOpusDecoder.h"
#import <libopus/libopus-umbrella.h>
#import <AVFAudio/AVFAudio.h>


@implementation OPAOpusDecoder {
    OpusDecoder *_decoder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _decoder = opus_decoder_create(8000, 1, NULL);
    }
    return self;
}

- (NSData *__nonnull)decodedData:(NSData *)data format:(AVAudioFormat **)format {
    float *pcm = malloc(sizeof(float) * data.length);

    opus_decode_float(_decoder, data.bytes, (opus_int32) data.length, pcm, (opus_int32) data.length, 0);

    AVAudioFormat *audioFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatFloat32 sampleRate:8000 channels:1 interleaved:NO];
    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFormat frameCapacity:data.length];
    buffer.frameLength = buffer.frameCapacity;

    memset(buffer.floatChannelData[0], 0, buffer.frameLength * audioFormat.streamDescription->mBytesPerFrame);

    NSData *returnData = [[NSData alloc] initWithBytes: buffer.floatChannelData length:buffer.frameCapacity * audioFormat.streamDescription->mBytesPerFrame];

    *audioFormat = format;

    return returnData;
}

@end
