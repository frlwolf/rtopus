//
// Created by Felipe Lobo on 25/08/21.
//

#import "OPAOpusEncoder.h"
#import <libopus/libopus-umbrella.h>
#import <AVFoundation/AVFAudio.h>

@implementation OPAOpusEncoder {
    OpusEncoder *_encoder;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _encoder = opus_encoder_create(8000, 1, OPUS_APPLICATION_VOIP, NULL);
    }
    return self;
}

- (NSData *)encodeFrameWithBuffer:(AVAudioPCMBuffer *)buffer atTime:(AVAudioTime *)when
{
    const size_t bytes = buffer.frameLength;
    unsigned char *result = malloc(bytes);

    opus_encoder_ctl(_encoder, OPUS_SET_BITRATE(128000));
    opus_encode_float(_encoder, *[buffer floatChannelData], 320, result, (opus_int32)bytes);

    NSData *data = [[NSData alloc] initWithBytes:result length:bytes];

    free(result);

    return data;
}

@end
