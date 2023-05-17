//
//  BAudioMessageCell.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/08/2015.
//
//

#import "BAudioMessageCell.h"

#import <ChatSDK/UI.h>

@implementation BAudioMessageCell

@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 10;
        imageView.clipsToBounds = YES;
        imageView.userInteractionEnabled = NO;
        
        // TODO: Is this necessary?
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.bubbleImageView addSubview:imageView];
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message isSelected: (BOOL) selected {
    [super setMessage:message isSelected:selected];
    [self refreshCell];
}

- (void)refreshCell {
    
    // If _playButton hasn't been added
    if (!_playButton) {
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.backgroundColor = [UIColor lightGrayColor];
        _playButton.layer.cornerRadius = 10;
        
        [_playButton setImage:[NSBundle uiImageNamed:@"icn_play"] forState:UIControlStateNormal];
        [_playButton setImage:[NSBundle uiImageNamed:@"icn_pause"] forState:UIControlStateSelected];

        [_playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];

        [self.bubbleImageView addSubview:_playButton];

        _playButton.keepHeight.equal = 50;
        _playButton.keepWidth.equal = 50;
        _playButton.keepBottomInset.equal = 3;

        _streamingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        if (@available(iOS 13.0, *)) {
            _streamingActivityIndicator.color = UIColor.systemGrayColor;
        } else {
            _streamingActivityIndicator.color = UIColor.grayColor;
        }

        [self.bubbleImageView addSubview:_streamingActivityIndicator];

        _streamingActivityIndicator.keepTopInset.equal = 9;
        _streamingActivityIndicator.keepBottomInset.equal = 9;

        UITapGestureRecognizer * stopStreaming = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopStreaming)];
        [_streamingActivityIndicator addGestureRecognizer:stopStreaming];
        
        _streamingActivityIndicator.hidesWhenStopped = YES;
    }
    
    _playButton.keepLeftInset.equal = _message.senderIsMe ? 3 : 8;
    _streamingActivityIndicator.keepLeftInset.equal = _message.senderIsMe ? 10 : 15;
    
    // Make sure user interaction is always enabled
    _playButton.userInteractionEnabled = YES;
    
    // We have access to the audio url here
    NSString * totalSeconds = self.message.meta[bMessageAudioLength];
    
    _totalTime = totalSeconds.floatValue;
    
    // Get the time in the format m:ss
    CGFloat totalMinutes = totalSeconds.floatValue / 60;
    CGFloat remainingSeconds = totalSeconds.integerValue % 60;
    
    if (!_audioLengthLabel) {
        
        _audioLengthLabel = [[UILabel alloc] init];
        
        if (@available(iOS 13.0, *)) {
            _audioLengthLabel.textColor = UIColor.labelColor;
        } else {
            _audioLengthLabel.textColor = UIColor.blackColor;
        }
        
        _audioLengthLabel.textAlignment = NSTextAlignmentRight;
        [_audioLengthLabel setFont:[UIFont systemFontOfSize:12]];
        
        [self.bubbleImageView addSubview:_audioLengthLabel];
        
        _audioLengthLabel.keepHeight.equal = 15;
        _audioLengthLabel.keepWidth.equal = 50;
        _audioLengthLabel.keepBottomInset.equal = 3;
        _audioLengthLabel.keepRightInset.equal = _message.senderIsMe ? 15 : 7;
    }
    
    _audioLengthLabel.text = [NSString stringWithFormat:@"%.0f:%02.0f", totalMinutes, remainingSeconds];
    
    if (!_currentTimeLabel) {
        
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.text = @"0:00";
        
        if (@available(iOS 13.0, *)) {
            _currentTimeLabel.textColor = [UIColor labelColor];
        } else {
            _currentTimeLabel.textColor = [UIColor blackColor];
        }
        
        _currentTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_currentTimeLabel setFont:[UIFont systemFontOfSize:12]];
        
        [self.bubbleImageView addSubview:_currentTimeLabel];
        
        _currentTimeLabel.keepHeight.equal = 15;
        _currentTimeLabel.keepWidth.equal = 50;
        _currentTimeLabel.keepBottomInset.equal = 3;
        _currentTimeLabel.keepLeftInset.equal = _message.senderIsMe ? 56 : 61;
    }
    
    if (!_slider) {
        
        _slider = [[UISlider alloc] init];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.bubbleImageView addSubview:_slider];
        
        _slider.keepTopInset.equal = 5;
        _slider.keepBottomOffsetTo(_currentTimeLabel).equal = 0;
        _slider.keepLeftOffsetTo(_playButton).equal = 5;
        _slider.keepRightInset.equal = 10;
        
    }
    
    _audioLengthLabel.hidden = ![self messageReady];
    _currentTimeLabel.hidden = ![self messageReady];
    
    self.bubbleImageView.alpha = [self messageReady] ? 1 : 0.75;
    
    __weak __typeof__(self) weakSelf = self;
    
    // When a message is recieved we increase the messages tab number
    [[NSNotificationCenter defaultCenter] addObserverForName:bStopAudioNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        __typeof__(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = notification.userInfo[bAudioNotificationURL];
            if (url && [url isEqual: self.audioURL]) {
                strongSelf->_playButton.selected = NO;
                [strongSelf resetTimer];
            }
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bPauseAudioNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        __typeof__(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = notification.userInfo[bAudioNotificationURL];
            if (url && [url isEqual: self.audioURL]) {
                strongSelf->_playButton.selected = NO;
                [strongSelf stopTimer];
            }
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:bPlayAudioNotification object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        __typeof__(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL * url = notification.userInfo[bAudioNotificationURL];
            if (url && [url isEqual: self.audioURL]) {
                strongSelf->_playButton.hidden = NO;
                [strongSelf->_streamingActivityIndicator stopAnimating];
            }
        });
    }];
}

-(void) sliderValueChanged: (UISlider *) sender {
    [self pause];
    NSString * audioURL = self.message.meta[bMessageAudioURL];
    NSURL * url = [NSURL URLWithString:audioURL];
    [[BAudioManager shared] setPlayTime:sender.value forURL:url];
    [self updateTimeFromSlider];
}

// When we press play first we check if the audio is playing - if it is we pause it
// If it isn't playing it either means the audio has stopped or it is paused
// If it is stopped it means we want to stop the audio as obviously another cell has been pressed
// If it is paused we only pause the audio as we might want to continue
- (void)playButtonPressed {
    // Only enable the play button if the audio message has been delivered
    if ([self messageReady]) {
        
        // If the audio is currently playing
        if (_playButton.isSelected) {
            [self pause];
        }
        else {
            [self play];
        }
    }
}

-(void) stopStreaming {
    if (_streamingActivityIndicator.isAnimating) {
        [self pause];
    }
}

-(void) play {
    [_streamingActivityIndicator startAnimating];
    _playButton.hidden = YES;
    [_playButton setSelected:YES];
    
    [[BAudioManager shared] playAudioWithURL:self.audioURL];
    
    float totalTime = [[BAudioManager shared] getTotalTimeInSeconds];
    if (totalTime > 0) {
        _totalTime = totalTime;
    }
    
    [self startUIUpdateTimer];
}

-(NSURL *) audioURL {
    NSString * audioURL = self.message.meta[bMessageAudioURL];
    return [NSURL URLWithString:audioURL];
}

-(void) pause {
    [[BAudioManager shared] pauseAudio];
    [_playButton setSelected:NO];
    _playButton.hidden = NO;
    [_streamingActivityIndicator stopAnimating];
    [self stopTimer];
}

-(UIView *) cellContentView {
    return imageView;
}

- (void)startUIUpdateTimer {
    __weak __typeof(self) weakSelf = self;
    _uiUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * timer) {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf update];
    }];
}

- (void)stopTimer {
    [_uiUpdateTimer invalidate];
}

-(void) update {
    [self updateSlider];
    [self updateTimeFromSlider];
}

-(void) updateSlider {
    Float64 time = [[BAudioManager shared] getCurrentTimeInSeconds];
    // Percent
    if (!isnan(time)) {
        CGFloat position = time / [[BAudioManager shared] getTotalTimeInSeconds];
        [_slider setValue:position animated:YES];
    }
}

-(BOOL) messageReady {
    return self.message.delivered.boolValue || !self.message.senderIsMe;
}

-(void) updateTimeFromSlider {
    
    NSInteger time = _slider.value * _totalTime;
    
    CGFloat totalMinutes = time / 60;
    CGFloat remainingSeconds = time % 60;
    
    _currentTimeLabel.text = [NSString stringWithFormat:@"%.0f:%02.0f", totalMinutes, remainingSeconds];
}

- (void)resetTimer {
    [_slider setValue:0 animated:NO];
    _currentTimeLabel.text = @"0:00";
    [self stopTimer];
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(50);
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)];
}

@end
