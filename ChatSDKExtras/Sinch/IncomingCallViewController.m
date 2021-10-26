//
//  IncomingCallViewController.m
//  Beep
//
//  Created by Pepe Becker on 05/09/2018.
//  Copyright © 2018 deluge. All rights reserved.
//

#import "IncomingCallViewController.h"

#import <ChatSDK/Core.h>
#import "CallViewController.h"
#import <ChatSDKSinch/ChatSDKSinch-Swift.h>

@interface IncomingCallViewController () {
    BOOL _callAnswered;
}
@end

@implementation IncomingCallViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _callAnswered = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *uid = [SinchModule.shared.client getRemoteUserId];
    id<PUser> remoteUser = [BChatSDK.db fetchEntityWithID:uid withType:bUserEntity];
    if (remoteUser != nil) {
        [_avatarImageView setImage:remoteUser.imageAsImage];
        [_nameLabel setText:remoteUser.name];
        [_emailLabel setText:remoteUser.email];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (SinchModule.shared.client.call == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SinchModule.shared.client setDelegate: self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (!_callAnswered) {
        [SinchModule.shared.client hangup];
    }
}

- (IBAction)didTapHangupButton:(UIButton *)sender {
    [SinchModule.shared.client hangup];
}

- (IBAction)didTapAnswerButton:(UIButton *)sender {
    [SinchModule.shared.client answer];
    _callAnswered = YES;
    CallViewController *callVC = [[CallViewController alloc] init];
    [callVC setInitiator:NO];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController presentViewController:callVC animated:YES completion:nil];
}

#pragma mark - SinchManagerDelegate

- (void) callDidEnd:(id<SINCall>)call {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
