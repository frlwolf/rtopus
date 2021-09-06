//
// Created by Felipe Lobo on 27/08/21.
//

#import <Foundation/Foundation.h>
#import "OPAOpus.h"

@class AVAudioPCMBuffer;
@class AVAudioFormat;

NS_SWIFT_NAME(Opus.Decoder)
@interface OPAOpusDecoder : NSObject

- (instancetype __nonnull)initWithSampleRate:(OPAOpusSampleRate)sampleRate channels:(OPAOpusChannelLayout)channels;

- (AVAudioPCMBuffer *__nonnull)decodedBufferFromData:(NSData *__nonnull)data;

@end
