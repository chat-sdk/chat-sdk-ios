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
@synthesize currentAudioURL = _currentAudioURL;
@synthesize player = _player;

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

-(instancetype) init {
    if ((self = [super init])) {
    }
    return self;
}

#pragma Playing audio

- (void)playAudioWithURL:(NSURL *)audioURL percent: (CGFloat)percent {
    
    // Make sure we have an audio track and it has been loaded
    if (_currentAudioURL == audioURL && CMTimeGetSeconds(_player.currentItem.duration)) {
        
        CGFloat currentPercent = CMTimeGetSeconds(_player.currentItem.currentTime)/CMTimeGetSeconds(_player.currentItem.duration);
        
        if (fabsf(percent - currentPercent) > 0.01) {
            [self setCurrentPlayTime:percent];
        }
    }
    else {
        
        _currentAudioURL = audioURL;
        _player = [AVPlayer playerWithURL: _currentAudioURL];
        [self setCurrentPlayTime:percent];
    }
    
    _player.rate = 1.0;
    [_player play];
}

// Load an audio track from a URL and then return the promise when it is ready to play
- (RXPromise *)loadAudioFromURL: (NSURL *)audioURL {
    
    _loadingPromise = [RXPromise new];
    
    // Ensure we remove the observer when the _player is deallocated
    @try {
        [_player removeObserver:self forKeyPath:@"status"];
    } @catch (NSException *exception) {
    }
    
    _currentAudioURL = audioURL;
    _player = [AVPlayer playerWithURL: _currentAudioURL];
    [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    return _loadingPromise;
}

// This observer looks at whether the audio is ready to play then returns the loading promise
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == _player && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerStatusReadyToPlay) {
            
            NSInteger second = CMTimeGetSeconds(_player.currentItem.asset.duration);
            
            [_loadingPromise resolveWithResult:nil];
        } else if (_player.status == AVPlayerStatusFailed) {
            [_loadingPromise rejectWithReason:_player.error];
        }
    }
}

// Split the previous function into two, this allows us to prepare an audio track without necessarily playing it
- (void)playAudioWithURL: (NSString *)audioURL {
    
    [self prepareToPlayWithURL:audioURL];
    [self playAudio];
}

// This prepares the app to play with a specific audio URL
- (void)prepareToPlayWithURL: (NSString *)audioURL {
    
    // We don't need to prepare it if we are already on it
    if (![_currentAudioURL.absoluteString isEqualToString:audioURL]) {
        
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
}

- (void)playAudio {
    [_player play];
}

- (void)pauseAudio {
    [_player pause];
}

- (BOOL)isPlaying {
    return _player.rate != 0 && _player.error == nil;
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

// This allows us to set the play time of the current audio track
- (void)setCurrentPlayTime: (double)percent {
    
    // If we don't have one we create one with our current audio URL
    if (_player.currentItem == nil) {
        
        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:_currentAudioURL];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        _player.rate = 1.0;
    }
    
    CGFloat totalTime = CMTimeGetSeconds(_player.currentItem.duration);
    
    // CMTime deals in time increments, this means we can get more accurate by splitting it into 10ths of a seconds
    // By using an increment of 100 instead of 1 we ensure that the miliseconds are preserved
    CMTime newTime = CMTimeMakeWithSeconds(totalTime * percent, 1000);
    
    [_player.currentItem seekToTime:newTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma Recording audio

- (void)prepareToRecord {
    
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

- (void)startRecording {
    
    // We can prepare the recording immediately before we record
    [self prepareToRecord];
    
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

// This is very slow - might be better to look at the current asset if we can?
-(double) recordingLength {
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:_recorder.url options:nil];
    CMTime time = asset.duration;
    return CMTimeGetSeconds(time);
}

- (NSInteger)getAudioTime {
    CMTime currentTime = _player.currentItem.currentTime;
    return CMTimeGetSeconds(currentTime);
}

#pragma Other functions

// Check if the user has their headphones plugged in
- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

@end
