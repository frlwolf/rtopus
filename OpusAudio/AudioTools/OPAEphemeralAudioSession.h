//
// Created by Felipe Lobo on 25/08/21.
//

#import <Foundation/Foundation.h>

@class AVAudioPCMBuffer;
@class AVAudioTime;
@class AVAudioFormat;
@protocol OPAEncoder;

NS_SWIFT_NAME(EphemeralAudioSession)
@interface OPAEphemeralAudioSession : NSObject

- (void)installFrameEncoder:(id<OPAEncoder> __nonnull)encoder
        encodedFrameHandler:(void (^__nullable)(NSData *__nonnull))handler
     convertedBufferHandler:(void (^__nullable)(AVAudioPCMBuffer *__nonnull buffer, AVAudioTime *__nonnull when))optionalBufferHandler;

- (void)installFrameEncoder:(id<OPAEncoder> __nonnull)encoder
             downsamplingTo:(AVAudioFormat *__nullable)downsamplingFormat
        encodedFrameHandler:(void (^__nullable)(NSData *__nonnull))handler
     convertedBufferHandler:(void (^__nullable)(AVAudioPCMBuffer *__nonnull buffer, AVAudioTime *__nonnull when))optionalBufferHandler;

- (BOOL)start:(NSError*__nullable*__nonnull)error;

- (void)stop;

@end
