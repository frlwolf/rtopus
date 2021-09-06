//
// Created by Felipe Lobo on 25/08/21.
//

#import <Foundation/Foundation.h>
#import "../AudioTools/OPAEncoder.h"
#import "OPAOpus.h"

NS_SWIFT_NAME(Opus.Encoder)
@interface OPAOpusEncoder : NSObject <OPAEncoder>

- (instancetype __nonnull)initWithSampleRate:(OPAOpusSampleRate)sampleRate channels:(OPAOpusChannelLayout)channels;

@end
