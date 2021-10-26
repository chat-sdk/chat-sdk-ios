//
//  CallViewController.h
//  Beep
//
//  Created by Pepe Becker on 05/09/2018.
//  Copyright © 2018 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

@interface CallViewController: UIViewController<SINCallDelegate>

@property (assign, nonatomic) bool initiator;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *remoteView;
@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;

@end
