//
//  BAudioManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 07/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class RXPromise;

#define bStopAudioNotification @"stopAudio"
#define bPauseAudioNotification @"pauseAudio"
#define bPlayAudioNotification @"playAudio"
#define bAudioNotificationURL @"url"

@interface BAudioManager : NSObject <AVAudioRecorderDelegate> {
    
    AVAudioRecorder * _recorder;
    
    // This promise allows us to see when a URL is ready to play - we can return it in one of the avplayers delegate methods
    RXPromise * _loadingPromise;
    
    NSMutableDictionary * _items;
}

// Making this a property allows us to retain it if the app closes
@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, readwrite) AVAudioRecorder * recorder;

+(BAudioManager *) sharedManager;

- (void)playAudio;
- (void)pauseAudio;
- (void)stopAudio;

- (BOOL)isPlaying;

// This allows us to play audio from a certain point in the track
- (void) playAudioWithURL:(NSURL *)audioURL;
- (void) setPlayTime: (double) fraction forURL: (NSURL *) url;

// Get the current time for the current audio file
- (Float64) getCurrentTimeInSeconds;
- (Float64) getTotalTimeInSeconds;

- (void)startRecording;
- (void)finishRecording;

-(double) recordingLength;


// This function gives us a call back when the audio is ready to be played
//- (RXPromise *)loadAudioFromURL: (NSURL *)audioURL;
-(AVPlayerStatus) playerStatus;

@end
