//
// Created by Felipe Lobo on 25/08/21.
//

#import <Foundation/Foundation.h>
#import "OPAEncoder.h"

@interface OPAOpusEncoder : NSObject <OPAEncoder>

- (NSData *__nonnull)encodeFrameWithBuffer:(AVAudioPCMBuffer *__nonnull)buffer atTime:(AVAudioTime *__nonnull)when;

@end
