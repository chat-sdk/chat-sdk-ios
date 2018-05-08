//
//  BAudioManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 07/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import <RXPromise/RXPromise.h>

// TODO: Refactor this - on audio branch
#define bStopAudioNotification @"stopAudio"

@interface BAudioManager : NSObject <AVAudioRecorderDelegate> {
    
    AVAudioRecorder * _recorder;
    
    // This promise allows us to see when a URL is ready to play - we can return it in one of the avplayers delegate methods
    RXPromise * _loadingPromise;
    
    // The fractional start time i.e. between 0 and 1
    float _startAtTimeFraction;
}

// Making this a property allows us to retain it if the app closes
@property (nonatomic, strong) AVPlayer * player;

// This allows us to compare the current URL with one we are trying to set (play, pause etc)
@property (nonatomic, strong) NSURL * currentAudioURL;

@property (nonatomic, readwrite) AVAudioRecorder * recorder;

+(BAudioManager *) sharedManager;

- (void)playAudio;
- (void)pauseAudio;
- (void)stopAudio;

- (BOOL)isPlaying;

// This allows us to play audio from a certain point in the track
- (void)playAudioWithURL:(NSURL *)audioURL percent: (CGFloat)percent;

// Get the current time for the current audio file
- (Float64) getCurrentTimeInSeconds;
- (Float64) getTotalTimeInSeconds;

- (void)startRecording;
- (void)finishRecording;

-(double) recordingLength;

- (void)setCurrentPlayTime: (double)percent;

// This function gives us a call back when the audio is ready to be played
- (RXPromise *)loadAudioFromURL: (NSURL *)audioURL;
-(AVPlayerStatus) playerStatus;

@end
