//
// Created by Felipe Lobo on 25/08/21.
//

#import <Foundation/Foundation.h>

@class AVAudioPCMBuffer;
@class AVAudioTime;
@protocol OPAEncoder;

@interface OPUMicServer : NSObject

- (void)installFrameEncoder:(id<OPAEncoder>__nonnull)encoder encodedFrameHandler:(void(^__nullable)(NSData *__nonnull))encodedFrame;

- (BOOL)start:(NSError*__nullable*__nonnull)error;

- (void)stop;

@end
