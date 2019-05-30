//
//  BAudioManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 07/08/2015.
//
//

#import "BAudioManager.h"

#import <ChatSDK/Core.h>

#define bStatusObserverKey @"status"

@implementation BAudioManager

static BAudioManager * manager;

@synthesize recorder = _recorder;
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
        _items = [NSMutableDictionary new];
    }
    return self;
}

#pragma Playing audio

-(void) addAudioURL: (NSURL *) url {
    if (![self itemForURL:url]) {
        BAudioItem * item = [BAudioItem new];
        item.url = url;
        item.seekPosition = 0;
        item.item = [AVPlayerItem playerItemWithURL:url];
        _items[url] = item;
    }
}

-(BAudioItem *) itemForURL: (NSURL *) url {
    return _items[url];
}

-(BAudioItem *) currentItem {
    if (_player) {
        return [self itemForPlayerItem:_player.currentItem];
    }
    return Nil;
}

-(BAudioItem *) itemForPlayerItem: (AVPlayerItem *) item {
    for (NSURL * key in _items.allKeys) {
        if ([[self itemForURL:key].item isEqual: item]) {
            return [self itemForURL:key];
        }
    }
    return Nil;
}

-(NSURL *) urlForPlayerItem: (AVPlayerItem *) item {
    return [self itemForPlayerItem:item].url;
}

// Load an audio track from a URL and then return the promise when it is ready to play
- (void)loadAudioFromURL: (NSURL *) url {
    if (![self itemForURL:url]) {
        [self addAudioURL:url];
    }
    [_player replaceCurrentItemWithPlayerItem:[self itemForURL:url].item];
}

-(RXPromise *) initializePlayer: (NSURL *) url {
    if (!_player) {
        _player = [AVPlayer playerWithURL:url];
        [_player addObserver:self forKeyPath:bStatusObserverKey options:0 context:nil];
        _player.rate = 1.0;
        _loadingPromise = [RXPromise new];
        return _loadingPromise;
    } else {
        return [RXPromise resolveWithResult:Nil];
    }
}

// This observer looks at whether the audio is ready to play then returns the loading promise
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:bStatusObserverKey] && object == _player && _player.status == AVPlayerStatusReadyToPlay) {
        [_loadingPromise resolveWithResult:nil];
    } else if (_player.status == AVPlayerStatusFailed) {
        [_loadingPromise rejectWithReason:_player.error];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopAudio];
}

- (void)playAudioWithURL:(NSURL *) url {
    [self initializePlayer: url].thenOnMain(^id(id success) {
        if ([[self itemForURL:url].item isEqual:_player.currentItem]) {
            [self seekAndPlayCurrentAudio];
        } else {
            [self pauseAudio];
            [self loadAudioFromURL:url];
            [self seekAndPlayCurrentAudio];
        }
        return Nil;
    }, Nil);
}

-(void) seekAndPlayCurrentAudio {
    // If the headphones are in use don't override the audio
    if (![self isHeadsetPluggedIn]) {
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
    }
    
    // Make sure the audio plays even if we're in silent mode
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    AVPlayerItem * item = _player.currentItem;
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishPlaying:) name:AVPlayerItemFailedToPlayToEndTimeErrorKey object:item];
    
    [self seekToPosition:[self itemForPlayerItem:item].seekPosition].thenOnMain(^id(id success) {
        [self playAudio];
        return Nil;
    }, Nil);
}

- (void)playAudio {
    BAudioItem * item = self.currentItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:bPlayAudioNotification object:Nil userInfo:@{bAudioNotificationURL: item.url}];
    [_player play];
}

- (BOOL)isPlaying {
    return _player.rate != 0 && _player.error == nil;
}

- (void)stopAudio {
    if (_player) {
        BAudioItem * item = self.currentItem;
        if (item) {
            item.seekPosition = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:bStopAudioNotification object:Nil userInfo:@{bAudioNotificationURL: item.url}];
        }
        [_player seekToTime:CMTimeMake(0, 1000)];
        [_player pause];
    }
}

- (void)pauseAudio {
    if (_player) {
        BAudioItem * item = self.currentItem;
        if (item) {
            [[NSNotificationCenter defaultCenter] postNotificationName:bPauseAudioNotification object:Nil userInfo:@{bAudioNotificationURL: item.url}];
        }
        [_player pause];
    }
}


// Will be called when AVPlayer finishes playing playerItem
-(void) didFinishPlaying:(NSNotification *) notification {
    [self stopAudio];
}

// This allows us to set the play time of the current audio track
- (void) setPlayTime: (double) fraction forURL: (NSURL *) url {
    if (_player.currentItem != nil) {
        [self itemForURL:url].seekPosition = fraction;
    }
}

-(RXPromise *) seekToPosition: (double) fraction {
    if(_player != Nil) {
        CGFloat totalTime = CMTimeGetSeconds(_player.currentItem.duration);
        
        // CMTime deals in time increments, this means we can get more accurate by splitting it into 10ths of a seconds
        // By using an increment of 100 instead of 1 we ensure that the miliseconds are preserved
        CMTime newTime = CMTimeMakeWithSeconds(totalTime * fraction, 1000);
        
        CMTime tolerance = CMTimeMakeWithSeconds(0.1, 1000);
        
        RXPromise * promise = [RXPromise new];
        [_player.currentItem seekToTime:newTime toleranceBefore:tolerance toleranceAfter:tolerance completionHandler:^(BOOL finished) {
            [promise resolveWithResult:Nil];
        }];
        return promise;
    } else {
        return [RXPromise resolveWithResult:Nil];
    }
}

#pragma Recording audio

- (void)prepareToRecord {
    
    // Set the audio file
    NSString * directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray * pathComponents = @[directory, @"MyAudioMemo.m4a"];
    
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

-(AVPlayerStatus) playerStatus {
    return _player.status;
}

// Return an array of the audio url and the audio duration
- (void) finishRecording {
    if (_recorder) {
        [_recorder stop];
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }
}

// This is very slow - might be better to look at the current asset if we can?
-(double) recordingLength {
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:_recorder.url options:nil];
    CMTime time = asset.duration;
    return CMTimeGetSeconds(time);
}

- (Float64) getCurrentTimeInSeconds {
    CMTime currentTime = _player.currentItem.currentTime;
    Float64 seconds = CMTimeGetSeconds(currentTime);
    BAudioItem * item = self.currentItem;
    double seekPosition = item.seekPosition;
    if (seconds == 0.0 && seekPosition > 0) {
        seconds = self.getTotalTimeInSeconds * seekPosition;
    } else {
        item.seekPosition = seconds / self.getTotalTimeInSeconds;
    }
    return seconds;
}

- (Float64) getTotalTimeInSeconds {
    CMTime totalTime = _player.currentItem.duration;
    return CMTimeGetSeconds(totalTime);
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
