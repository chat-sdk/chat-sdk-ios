//
//  BRegisterTableViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PUser;
@protocol PUserConnection;

@interface BProfileTableViewController : UITableViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITapGestureRecognizer * _tapRecognizer;
    
    UIImagePickerController * _picker;
    
    BOOL _didLogout;
    
    BOOL _nameIndexed;
    BOOL _phoneIndexed;
    BOOL _emailIndexed;
    
    id _keyboardObserver;
    
//    id<PUserConnection> _userConnection;
    id<PUser> _user;
    
    // This BOOL checks if we want to reset the user, we do this if we leave the view with no intention of coming back
    // For example once we have finished viewing another user's profile we don't want to retain a link to it
    BOOL _resetUser;
}

//- (void)initialiseWithConnection: (id<PUserConnection>) connection;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;

//@property (nonatomic, readwrite) id<PUserConnection> userConnection;
@property (nonatomic, readwrite) id<PUser> user;

@end
