//
// Created by Felipe Lobo on 06/09/21.
//

#import <Foundation/Foundation.h>

@class AVAudioFormat;

// Must be one of 48000, 24000, 16000, 12000, 8000
typedef NS_ENUM(NSUInteger, OPAOpusSampleRate) {
    OPAOpusSampleRateS48kHz = 48000,
    OPAOpusSampleRateS24kHz = 24000,
    OPAOpusSampleRateS16kHz = 16000,
    OPAOpusSampleRateS12kHz = 12000,
    OPAOpusSampleRateS8kHz = 8000
} NS_SWIFT_NAME(Opus.SampleRate);

typedef NS_ENUM(int, OPAOpusChannelLayout) {
    OPAOpusChannelLayoutMono = 1,
    OPAOpusChannelLayoutStereo = 2
} NS_SWIFT_NAME(Opus.ChannelLayout);

// Must be one of 2.5, 5, 10, 20, 40 or 60
typedef NS_ENUM(int, OPAOpusFrameDuration) {
    OPAOpusFrameDurationT5ms = 5,
    OPAOpusFrameDurationT10ms = 10,
    OPAOpusFrameDurationT20ms = 20,
    OPAOpusFrameDurationT40ms = 40,
    OPAOpusFrameDurationT60ms = 60
} NS_SWIFT_NAME(Opus.FrameDuration);

#define OPAOpusFrameDurationT2_5ms (OPAOpusFrameDuration_5ms / 2)

@interface Opus: NSObject

+ (OPAOpusSampleRate)defaultSampleRate;

+ (OPAOpusChannelLayout)defaultChannelLayout;

+ (AVAudioFormat *)defaultFormat;

@end
