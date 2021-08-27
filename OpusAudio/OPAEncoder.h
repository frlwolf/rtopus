//
// Created by Felipe Lobo on 27/08/21.
//

#import <Foundation/Foundation.h>

@class AVAudioPCMBuffer;
@class AVAudioTime;

@protocol OPAEncoder <NSObject>

- (instancetype)init;

- (NSData *__nonnull)encodeFrameWithBuffer:(AVAudioPCMBuffer *__nonnull)buffer atTime:(AVAudioTime *__nonnull)when;

@end
