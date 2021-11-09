//
//  IncomingCallViewController.h
//  c@r
//
//  Created by Pepe Becker on 05/09/2018.
//  Copyright © 2018 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

@interface IncomingCallViewController : UIViewController<SINCallDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
