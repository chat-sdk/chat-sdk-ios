//
//  CallViewController.m
//  Beep
//
//  Created by Pepe Becker on 05/09/2018.
//  Copyright © 2018 deluge. All rights reserved.
//

#import "CallViewController.h"

#import <ChatSDK/Core.h>
#import "IncomingCallViewController.h"
#import <ChatSDKSinch/ChatSDKSinch-Swift.h>

#define imageVideocamOffWhite36 @"videocam_off_white_36pt"
#define imageVideocamWhite36 @"videocam_white_36pt"
#define imageVolumeUpWhite36 @"volume_up_white_36pt"
#define imageVolumeOffWhite36 @"volume_off_white_36pt"


@implementation CallViewController {
    NSDate *_startTime;
    BOOL _videoEnabled;
    BOOL _speakerEnabled;
    id<PUser> _remoteUser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _initiator = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *uid = [SinchModule.shared.client getRemoteUserId];
    _remoteUser = [BChatSDK.db fetchEntityWithID:uid withType:bUserEntity];
    if (_remoteUser != nil) {
        _avatarImageView.image = [UIImage imageWithData:_remoteUser.image];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2.0;
        _nameLabel.text = _remoteUser.name;
        _statusLabel.text = @"Connecting";
    }

    [self removeLocalVideo];
    [self disableSpeaker];

    _videoButton.hidden = YES;
    _speakerButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SinchModule.shared.client setDelegate:self];

    // If the call is already established at this point it won't
    // trigger the delegate method, so we have to call it manually
    if (SinchModule.shared.client.callStatus >= SinchCallStatusCallDidEstablish) {
        [self callDidEstablish:SinchModule.shared.client.call];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SinchModule.shared.client hangup];
}

- (IBAction)didTapHangupButton:(UIButton *)sender {
    [SinchModule.shared.client hangup];
}

- (IBAction)didTapVideoButton:(UIButton *)sender {
    if (_videoEnabled) {
        [self removeLocalVideo];
    } else {
        [self addLocalVideo];
    }
}

- (IBAction)didTapSpeakerButton:(UIButton *)sender {
    _speakerEnabled = !_speakerEnabled;
    if (_speakerEnabled) {
        [self enableSpeaker];
    } else {
        [self disableSpeaker];
    }
}

- (void)enableSpeaker {
    [SinchModule.shared.client enableSpeakerAndReturnError:nil];
    [_speakerButton setImage:[UIImage imageNamed:imageVolumeUpWhite36] forState:UIControlStateNormal];
}

- (void)disableSpeaker {
    [SinchModule.shared.client disableSpeakerAndReturnError:nil];
    [_speakerButton setImage:[UIImage imageNamed:imageVolumeOffWhite36] forState:UIControlStateNormal];
}

- (unsigned long)getDuration {
    return lroundf(fabsl([_startTime timeIntervalSinceNow]));
}

- (void)updateDuration:(NSTimer *)timer {
    long seconds = [self getDuration];
    int mins = floor(seconds / 60);
    int secs = round(seconds - mins * 60);
    NSString *secsString = [NSString stringWithFormat:(secs < 10 ? @"0%d" : @"%d"), secs];
    NSString *minsString = [NSString stringWithFormat:(mins < 10 ? @"0%d" : @"%d"), mins];
    _statusLabel.text = [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

- (void)addLocalVideo {
    [SinchModule.shared.client resumeVideo];
    if (![SinchModule.shared.client getLocalView].superview) {
        [_localView addSubview:[SinchModule.shared.client getLocalView]];
        [SinchModule.shared.client getLocalView].bounds = _localView.bounds;
    }
    _localView.hidden = NO;
    _videoEnabled = YES;
    [_videoButton setImage:[UIImage imageNamed:imageVideocamWhite36] forState:UIControlStateNormal];
}

- (void)removeLocalVideo {
    [SinchModule.shared.client pauseVideo];
    if ([SinchModule.shared.client getLocalView].superview) {
        [[SinchModule.shared.client getLocalView] removeFromSuperview];
    }
    _localView.hidden = YES;
    _videoEnabled = NO;
    [_videoButton setImage:[UIImage imageNamed:imageVideocamOffWhite36] forState:UIControlStateNormal];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [[SinchModule.shared.client getLocalView] setBounds:_localView.bounds];
}

#pragma mark - SinchManagerDelegate

- (void) callDidEnd:(id<SINCall>)call {
    if (_remoteUser == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)  callDidProgress:(id<SINCall>)call {
    _statusLabel.text = @"Connecting";
}

- (void)  callDidEstablish:(id<SINCall>)call {
    _startTime = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDuration:) userInfo:nil repeats:YES];
    _videoButton.hidden = NO;
    _speakerButton.hidden = NO;
}

- (void)  callDidResumeVideoTrack:(id<SINCall>)call {
    if (!SinchModule.shared.client.getRemoteView.superview) {
        [_remoteView addSubview:[SinchModule.shared.client getRemoteView]];
    }
    _remoteView.hidden = NO;
}

- (void)  callDidPauseVideoTrack:(id<SINCall>)call {
    if ([SinchModule.shared.client getRemoteView].superview) {
        [[SinchModule.shared.client getRemoteView] removeFromSuperview];
    }
    _remoteView.hidden = YES;
}

@end
