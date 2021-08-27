//
// Created by Felipe Lobo on 27/08/21.
//

#import <Foundation/Foundation.h>

@class AVAudioPCMBuffer;
@class AVAudioFormat;

@interface OPAOpusDecoder : NSObject

- (NSData *__nonnull)decodedData:(NSData *__nonnull)data format:(AVAudioFormat **)format;

@end
