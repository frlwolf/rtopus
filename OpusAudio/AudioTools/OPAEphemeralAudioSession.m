//
// Created by Felipe Lobo on 25/08/21.
//

#import "OPAEphemeralAudioSession.h"
#import "OPAEncoder.h"
#import <AVFoundation/AVFoundation.h>

@implementation OPAEphemeralAudioSession {
    __strong AVAudioEngine *_audioEngine;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            NSLog(@"Record permission granted: %@", (granted ? @YES : @NO));
        }];

        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return self;
}

- (BOOL)start:(NSError **)error
{
    if ([_audioEngine isRunning])
        [_audioEngine stop];

    [_audioEngine prepare];

    return [_audioEngine startAndReturnError:error];
}

- (void)stop
{
    [_audioEngine stop];
}

- (void)installFrameEncoder:(id<OPAEncoder>)encoder
        encodedFrameHandler:(void(^)(NSData *))handler
     convertedBufferHandler:(void (^)(AVAudioPCMBuffer *buffer, AVAudioTime *when))optionalBufferHandler
{
    AVAudioFormat *audioFormat = [_audioEngine.inputNode outputFormatForBus:0];
    AVAudioFormat *samplingFormat = [encoder inputFormat];

    AVAudioFrameCount bufferSize = [encoder bufferSizeWithFormat:audioFormat];

    [_audioEngine.inputNode installTapOnBus:0 bufferSize:bufferSize format:audioFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when) {
        AVAudioPCMBuffer *outputBuffer = buffer;

        if (![audioFormat isEqual:samplingFormat]) {
            AVAudioConverter *converter = [[AVAudioConverter alloc] initFromFormat:audioFormat toFormat:samplingFormat];
            AVAudioFrameCount convertedCapacity = (AVAudioFrameCount)(samplingFormat.sampleRate * buffer.frameLength / buffer.format.sampleRate);

            outputBuffer = [[AVAudioPCMBuffer alloc]
                    initWithPCMFormat:samplingFormat
                        frameCapacity:convertedCapacity];

            NSError *error;
            OSStatus status = [converter convertToBuffer:outputBuffer error:&error
                                      withInputFromBlock:^AVAudioBuffer *(AVAudioPacketCount inNumberOfPackets, AVAudioConverterInputStatus *outStatus) {
                                          *outStatus = AVAudioConverterInputStatus_HaveData;
                                          return buffer;
                                      }];

            if (status < 0) {
                NSLog(@"Error while downsampling audio: %@", error.localizedDescription);
            }
        }
        if (optionalBufferHandler != nil) {
            optionalBufferHandler(outputBuffer, when);
        }

        [encoder encodeWithPCMBuffer:outputBuffer atTime:when encodedFrame:handler];
    }];
}

@end
