//
//  BAudioManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 07/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// TODO: Refactor this - on audio branch
#define bStopAudioNotification @"stopAudio"

@interface BAudioManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    
    AVAudioRecorder * _recorder;
    AVPlayer * _player;
    
    NSString * _currentAudioURL;
}

@property (nonatomic, readwrite) AVAudioRecorder * recorder;

+(BAudioManager *) sharedManager;

- (void)playAudioWithURL: (NSString *)audioURL;
- (void)pauseAudio;
- (void)stopAudio;

- (NSInteger)getAudioTime;

- (void) startRecording;
- (void) finishRecording;

-(double) recordingLength;

@end
