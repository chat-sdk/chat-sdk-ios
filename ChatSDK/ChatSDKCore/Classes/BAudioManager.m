//
//  BAudioManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 07/08/2015.
//
//

#import "BAudioManager.h"

@implementation BAudioManager

static BAudioManager * manager;

@synthesize recorder = _recorder;

+(BAudioManager *) sharedManager {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(manager == nil) {
            // Allocate and initialize an instance of this class
            manager = [[self alloc] init];
        }
    }
    return manager;
}

-(id) init {
    if ((self = [super init])) {
        
        // Set the audio file
        NSArray * pathComponents = [NSArray arrayWithObjects:
                                    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                    @"MyAudioMemo.m4a",
                                    nil];
        
        NSURL * outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Setup audio session
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        // Define the recorder setting
        NSMutableDictionary * recordSetting = [[NSMutableDictionary alloc] init];
        
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        // Initiate and prepare the recorder
        _recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        
    }
    return self;
}

- (void)playAudioWithURL: (NSString *)audioURL {
    
    // This means it has been paused and then played
    if (![_currentAudioURL isEqualToString:audioURL]) {
        
        _currentAudioURL = audioURL;
        
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:audioURL]];
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        
        // If the headphones are in use don't override the audio
        if (![self isHeadsetPluggedIn]) {
            UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride),&audioRouteOverride);
        }
        
        // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    }
    
    [_player play];
}

// Check if the user has their headphones plugged in
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (void)pauseAudio {
    [_player pause];
}

- (void)stopAudio {
    
    // We want to stop so unallocate the audio player
    [[NSNotificationCenter defaultCenter] postNotificationName:bStopAudioNotification object:Nil userInfo:nil];
    [_player pause];
    _currentAudioURL = nil;
    _player = nil;
}

// Will be called when AVPlayer finishes playing playerItem
-(void)itemDidFinishPlaying:(NSNotification *) notification {
    
    [self stopAudio];
}

- (void)startRecording {
    
    // Make sure the recorder isn't currently recording
    if (!_recorder.recording) {
        
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:YES error:nil];
        
        // Start recording
        [_recorder record];
    }
}

// Return an array of the audio url and the audio duration
- (void) finishRecording {
    
    [_recorder stop];
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

-(double) recordingLength {
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:_recorder.url options:nil];
    CMTime time = asset.duration;
    return CMTimeGetSeconds(time);
}

- (NSInteger)getAudioTime {
    AVPlayerItem * currentItem = _player.currentItem;
    CMTime currentTime = currentItem.currentTime;
    return CMTimeGetSeconds(currentTime);
}

@end
