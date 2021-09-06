//
// Created by Felipe Lobo on 27/08/21.
//

#import <Foundation/Foundation.h>
#import <AVFAudio/AVAudioBuffer.h>
#import <AVFAudio/AVAudioTime.h>
#import <AVFAudio/AVAudioFormat.h>

@protocol OPAEncoder <NSObject>

- (AVAudioFormat *__nonnull)inputFormat;

- (AVAudioFrameCount)bufferSizeWithFormat:(AVAudioFormat *__nonnull)format;

- (void)encodeWithPCMBuffer:(AVAudioPCMBuffer *__nonnull)buffer
                     atTime:(AVAudioTime *__nonnull)when
               encodedFrame:(void (^__nonnull)(NSData *__nonnull))handler;

@end
