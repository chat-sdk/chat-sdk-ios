//
//  BRegisterTableViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StaticDataTableViewController/StaticDataTableViewController.h>

@protocol PUser;

@interface BDetailedProfileTableViewController : StaticDataTableViewController {
    
    UIImage * _anonymousProfilePicture;
    
    BOOL _didLogout;
    
    BOOL _nameIndexed;
    BOOL _phoneIndexed;
    BOOL _emailIndexed;
    
    id _userObserver;
}

@property (nonatomic, readwrite) id<PUser> user;

@property (weak, nonatomic) IBOutlet UIImageView *localityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *availabilityImageView;

@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *localityLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *blockImageView;
@property (weak, nonatomic) IBOutlet UILabel *blockTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *blockUserActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *availabilityLabel;

@property (weak, nonatomic) IBOutlet UIButton *followsButton;
@property (weak, nonatomic) IBOutlet UIButton *followedButton;

// Cell Outlets
@property (weak, nonatomic) IBOutlet UITableViewCell *statusCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *localityCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *blockUserCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *availabilityCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *followsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *followedCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addContactCell;
@property (weak, nonatomic) IBOutlet UIImageView *addContactImageView;
@property (weak, nonatomic) IBOutlet UILabel *addContactLabel;

-(void) refreshInterfaceAnimated: (BOOL) animated;

@end
