//
// Created by Felipe Lobo on 06/09/21.
//

#import "OPAOpus.h"
#import <AVFAudio/AVAudioFormat.h>

@implementation Opus

+ (OPAOpusSampleRate)defaultSampleRate {
    return OPAOpusSampleRateS8kHz;
}

+ (OPAOpusChannelLayout)defaultChannelLayout {
    return OPAOpusChannelLayoutMono;
}

+ (AVAudioFormat *)defaultFormat
{
    return [[AVAudioFormat alloc]
            initWithCommonFormat:AVAudioPCMFormatFloat32
                      sampleRate:8000
                        channels:1
                     interleaved:NO];
}

@end
