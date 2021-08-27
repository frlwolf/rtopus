//
// Created by Felipe Lobo on 25/08/21.
//

#import "OPUMicServer.h"
#import "OPAEncoder.h"
#import <AVFoundation/AVFoundation.h>

@implementation OPUMicServer {
    __strong AVAudioEngine *_audioEngine;
    __strong AVAudioNode *_mixer;
    __strong AVAudioFormat *_defaultOutputFormat;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        [[AVAudioSession sharedInstance] setPreferredSampleRate:48000 error:nil];

        _audioEngine = [[AVAudioEngine alloc] init];

        AVAudioNodeBus bus = 0;
        AVAudioInputNode *inputNode = _audioEngine.inputNode;
        AVAudioFormat *engineInputFormat = [inputNode outputFormatForBus:bus];

        AVAudioMixerNode *mixer = [[AVAudioMixerNode alloc] init];

        [_audioEngine attachNode:mixer];

        AVAudioFormat *mixerOutputFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:8000 channels:1];

        [_audioEngine connect:inputNode to:mixer format:engineInputFormat];
        [_audioEngine connect:mixer to:_audioEngine.outputNode format:mixerOutputFormat];

        _mixer = mixer;
        _defaultOutputFormat = mixerOutputFormat;
    }
    return self;
}

- (BOOL)start:(NSError *__nullable*)error
{
    if ([_audioEngine isRunning]) {
        [_audioEngine stop];
    }

    [_audioEngine prepare];

    return [_audioEngine startAndReturnError:error];
}

- (void)stop
{
    [_audioEngine stop];
}

- (void)installFrameEncoder:(id<OPAEncoder>)encoder encodedFrameHandler:(void(^)(NSData *))handler {
    [_mixer installTapOnBus:0 bufferSize:320 format:_defaultOutputFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        NSData *encodedFrame = [encoder encodeFrameWithBuffer:buffer atTime:when];
        handler(encodedFrame);
    }];
}

@end
