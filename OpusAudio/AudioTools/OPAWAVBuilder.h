//
// Created by Felipe Lobo on 01/09/21.
//

#import <Foundation/Foundation.h>

@class AVAudioPCMBuffer;
@class AVAudioFormat;

NS_SWIFT_NAME(WAVBuilder)
@interface OPAWAVBuilder: NSObject

- (instancetype __nonnull)init NS_UNAVAILABLE;

- (instancetype __nonnull)initWithFormat:(AVAudioFormat *__nonnull)format NS_DESIGNATED_INITIALIZER;

- (void)appendChunkWithBuffer:(AVAudioPCMBuffer *__nonnull)buffer;

- (BOOL)save:(NSError *__nullable*__nullable)error;

- (void)resetToFormat:(AVAudioFormat *__nonnull)format;

@end
