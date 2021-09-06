//
// Created by Felipe Lobo on 25/08/21.
//

#import "OPAOpusEncoder.h"
#import <libopus/libopus-umbrella.h>
#import <AVFoundation/AVFAudio.h>

#define BITS 32

@implementation OPAOpusEncoder {
    OpusEncoder *_encoder;
    AVAudioFrameCount _frameSize;
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
        _encoder = opus_encoder_create(sampleRate, channels, OPUS_APPLICATION_VOIP, NULL);
        _frameSize = (AVAudioFrameCount)(sampleRate / 1000 * OPAOpusFrameDurationT60ms); //2.5, 5, 10, 20, 40 or 60 ms
        _sampleRate = sampleRate;
        _channelLayout = channels;
    }
    return self;
}

- (AVAudioFormat *)inputFormat {
    return [Opus defaultFormat];
}

- (AVAudioFrameCount)bufferSizeWithFormat:(AVAudioFormat *)format
{
    // AVAudioNode can handle buffer sizes from [100, 400] milliseconds
    // since for Opus encoder the maximum size is 60ms
    // the buffer size we can have is twice that at 120ms
    double frameDuration = OPAOpusFrameDurationT60ms * 2;
    return (AVAudioFrameCount)(format.sampleRate / 1000 * frameDuration);
}

- (void)encodeWithPCMBuffer:(AVAudioPCMBuffer *)buffer atTime:(AVAudioTime *)when encodedFrame:(void (^)(NSData *))handler
{
    // This method assumes a buffer containing 120ms samples

    size_t bufferSize = buffer.frameLength * buffer.format.streamDescription->mBytesPerFrame;

    float *bufferCopy = malloc(bufferSize);
    memcpy(bufferCopy, buffer.floatChannelData[0], bufferSize);

    // Here we encode the first 60ms of samples in the buffer

    NSData *first60ms = [self encodeFrameWithBuffer:&bufferCopy];
    handler(first60ms);

    // Now we shift the buffer pointer in 60ms size

    size_t ms_60 = buffer.frameCapacity / 2;
    float *remainingBufferCopy = bufferCopy + ms_60;

    // And then we encode the remaining 60ms of samples

    NSData *remaining60ms = [self encodeFrameWithBuffer:&remainingBufferCopy];
    handler(remaining60ms);

    free(bufferCopy);
}

// region Private

- (NSData *)encodeFrameWithBuffer:(float * const *)pcmChannelData
{
    const int bitrate = _sampleRate * _channelLayout * BITS;

    opus_encoder_ctl(_encoder, OPUS_SET_BITRATE(bitrate));

    const size_t maxPacketBytes = sizeof(float) * _channelLayout * _frameSize;
    unsigned char *result = malloc(maxPacketBytes);

    opus_int32 encodedBytes = opus_encode_float(_encoder, *pcmChannelData, _frameSize, result, (opus_int32)maxPacketBytes);

    if (encodedBytes < OPUS_OK) {
        @throw [NSException exceptionWithName:@"Error when encoding package"
                                       reason:@"Check opus error code for more information"
                                     userInfo:@{ @"OpusErrorCode": @(encodedBytes) }];
    } else {
        NSLog(@"Encoded into (%d) bytes", encodedBytes);
    }

    NSData *data = [[NSData alloc] initWithBytes:result length:(NSUInteger)encodedBytes];

    free(result);

    return data;
}

// endregion

@end
