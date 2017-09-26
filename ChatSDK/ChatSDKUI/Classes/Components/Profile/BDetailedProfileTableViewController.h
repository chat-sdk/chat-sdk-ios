//
//  BRegisterTableViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StaticDataTableViewController/StaticDataTableViewController.h>

@class BNotificationObserverList;
@protocol PUser;

@interface BDetailedProfileTableViewController : StaticDataTableViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImage * _anonymousProfilePicture;
    UIImagePickerController * _picker;
    
    BOOL _didLogout;
    
    BOOL _nameIndexed;
    BOOL _phoneIndexed;
    BOOL _emailIndexed;
    
    BNotificationObserverList * _notificationList;
}

@property (nonatomic, readwrite) id<PUser> overrideUser;

@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *genderButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoButton;

@property (weak, nonatomic) IBOutlet UIImageView *addFriendImageView;
@property (weak, nonatomic) IBOutlet UILabel *addFriendTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *addFriendActivityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *blockImageView;
@property (weak, nonatomic) IBOutlet UILabel *blockTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *blockUserActivityIndicator;

// Cell Outlets
@property (weak, nonatomic) IBOutlet UITableViewCell *statusCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addFriendCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *blockUserCell;

@end
