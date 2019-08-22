//
//  BRegisterTableViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BProfileTableViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "BProfilePicturesViewController.h"

#define defaultCellHeight 

@interface BProfileTableViewController ()

@end

@implementation BProfileTableViewController

@synthesize nameField;
@synthesize phoneNumberField;
@synthesize emailField;
@synthesize profilePictureButton;

@synthesize user = _user;

// TODO: Move these images to settings
-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = [NSBundle t:bProfile];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_profile.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add a tap recognizer to dismiss the keyboard
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:_tapRecognizer];
    
    profilePictureButton.layer.cornerRadius = 50;
    
    // This stops the data from scrolling which we don't want
    self.tableView.alwaysBounceVertical = NO;
    
    id<PUser> currentUser = BChatSDK.currentUser;
    
    if (!_user) {
        _user = currentUser;
    }
    [self updateBlockButton];
        
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStylePlain target:Nil action:Nil];

}

-(void) loadUserImage {
    if(_user) {
        [profilePictureButton loadAvatarForUser:_user forControlState:UIControlStateNormal];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id<PUser> currentUser = BChatSDK.currentUser;
    
    if (!_user) {
        _user = currentUser;
    }
    
    [self loadUserImage];
    
    _keyboardObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:Nil usingBlock:^(NSNotification * n) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUserAndIndexes];
        });
    }];
    
    // This needs to be added here so it is reloaded each time
    if (_user.isMe) {
        // Add a logout button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bLogout] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        if(BChatSDK.ui.settingsViewController) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_25_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
        }
        else {
            self.navigationItem.leftBarButtonItem = Nil;
        }
        
        [self currentUserProfile:YES];
    }
    else {
        // Add a back
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bChat] style:UIBarButtonItemStylePlain target:self action:@selector(startChatWithUser)];
        
        [self currentUserProfile:NO];
    }
    
    // Setup phone and email fields
    // Set the placeholders for the name and email as we never want these to be set to null values
    nameField.text = _user.name;
    nameField.placeholder = [NSBundle t:bName];
    
    emailField.text = _user.email;
    emailField.placeholder = [NSBundle t:bEmail];
    
    phoneNumberField.text = _user.phoneNumber;
    phoneNumberField.placeholder = [NSBundle t:bPhoneNumber];
    
    _didLogout = NO;
    
    // Observe for keyboard appear and disappear notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:Nil];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self updateUserAndIndexes];
    
    _resetUser = YES;
}

-(void) openSettings {
    [self.navigationController pushViewController:BChatSDK.ui.settingsViewController animated:YES];
}

-(void) startChatWithUser {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSBundle t:bCreatingThread];
    
    [BChatSDK.core createThreadWithUsers:@[_user] threadCreated:^(NSError * error, id<PThread> thread) {
        if (!error) {
            [self pushChatViewControllerWithThread:thread];
        }
        else {
            [UIView alertWithTitle:[NSBundle t:bErrorTitle] withMessage:[NSBundle t:bThreadCreationError]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void) pushChatViewControllerWithThread: (id<PThread>) thread {
    if (thread) {
        UIViewController * chatViewController = [BChatSDK.ui chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

-(UIImage *) profilePicture {
    id<PUser> user = BChatSDK.currentUser;
    return user.image ? [UIImage imageWithData:user.image] : Nil;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // If we've just logged out then we don't want to do anything
    // because we won't have a Firebase permission
    if (_didLogout) {
        return;
    }
    [self updateUserAndIndexes];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_keyboardObserver];
}

-(void) viewTapped {
    // Resign first responder for all fields
    [nameField resignFirstResponder];
    [phoneNumberField resignFirstResponder];
    [emailField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    return NO;
}

// #6679 Start bug fix for v3.0.2
-(void) updateUserAndIndexes {
    
    // Add the user to the index
    id<PUser> user = BChatSDK.currentUser;
    
    if (user && user.entityID && [_user isEqualToEntity:user]) {
        
        // User cannot set their name as white space
        if ([nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
            user.name = nameField.text;
        }
        
        // User cannot set their name to blank or white space
        if ([emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length) {
            user.email = emailField.text;
        }
        
        user.phoneNumber = phoneNumberField.text;
                
        // Update the user
        [BChatSDK.core pushUser];
    }
}
// End bug fix for v3.0.2

- (IBAction)profilePictureButtonPressed:(UIButton *)sender {

    if (BChatSDK.config.profilePicturesEnabled) {
        BProfilePicturesViewController * ppvc = [[BProfilePicturesViewController alloc] init];
        ppvc.user = self.user;
        [self.navigationController pushViewController:ppvc animated:YES];
        return;
    }

    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        //_picker.allowsEditing = YES; // This allows the user to crop their image
    }

    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    _resetUser = NO;

    [self presentViewController:_picker animated:YES completion:Nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:^{
        
        //TOCropViewController * cropViewController = [[TOCropViewController alloc] initWithImage:image]; // Make the image view square
        TOCropViewController * cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];
        
        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropViewController.resetAspectRatioEnabled = NO; // Clicking reset will keep the square aspect ration
        cropViewController.aspectRatioPickerButtonHidden = YES; // Disable users picking their own aspect ration
        cropViewController.delegate = self;
        
        [self presentViewController:cropViewController animated:YES completion:nil];
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    
    // Make sure to update the profile picture once the image is set
    [profilePictureButton setImage:image forState:UIControlStateNormal];
    
    // Now reduce the image to 200x200 for the profile picture
    image = [image resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];

    // Set the user image
    [profilePictureButton setImage:image forState:UIControlStateNormal];
    
    // Update the user
    id<PUser> user = BChatSDK.currentUser;
    [user setImage:UIImagePNGRepresentation(image)];
    
    [BChatSDK.upload uploadImage:image].thenOnMain(^id(NSDictionary * urls) {
        
        // Set the meta data
        [user updateMeta:@{bUserImageURLKey: urls[bImagePath]}];
        
        // Update the user
        [BChatSDK.core pushUser];
        
        return urls;
    }, Nil);
    
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:Nil];
}

#pragma Nav buttons

- (void)currentUserProfile: (BOOL) isCurrent {
    
    UIColor * borderColor = !isCurrent ? [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0] : [UIColor whiteColor];
    
    nameField.backgroundColor = borderColor;
    nameField.userInteractionEnabled = isCurrent;
    
    emailField.backgroundColor = borderColor;
    emailField.userInteractionEnabled = isCurrent;
    
    phoneNumberField.backgroundColor = borderColor;
    phoneNumberField.userInteractionEnabled = isCurrent;

    if (!BChatSDK.config.profilePicturesEnabled) {
        profilePictureButton.userInteractionEnabled = isCurrent;
    }
}

-(void) logout {
    // This will prevent the app from trying to
    _didLogout = YES;
    [BChatSDK.auth logout].thenOnMain(^id(id success) {
        
        // Clear fields
        nameField.text = @"";
        phoneNumberField.text = @"";
        emailField.text = @"";
        
        [profilePictureButton setImage:_user.defaultImage forState:UIControlStateNormal];
        
        // Set the user object to nil so that we will load the new user when reloading it
        _user = nil;
        
        return Nil;
    },^id(NSError * error) {
        [UIView alertWithTitle:[NSBundle t:bLogoutErrorTitle] withError:error];
        return Nil;
    });
    
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Handle keyboard

// Move the toolbar up
-(void) keyboardWillShow: (NSNotification *) notification {
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void) keyboardDidHide: (NSNotification *) notification {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (IBAction)rightActionButtonPressed:(id)sender {
    if(BChatSDK.blocking) {
        if(![BChatSDK.blocking isBlocked:_user.entityID]) {
            [BChatSDK.blocking blockUser:_user.entityID].thenOnMain(^id(id success) {
                [self updateBlockButton];
                return Nil;
            }, Nil);
        }
        else {
            [BChatSDK.blocking unblockUser:_user.entityID].thenOnMain(^id(id success) {
                [self updateBlockButton];
                return Nil;
            }, Nil);
        }
    }
}

- (IBAction)leftActionButtonPressed:(id)sender {

}

-(void) updateBlockButton {
    [self.rightActionButton setTitle:[NSBundle t:bBlock] forState:UIControlStateNormal];
    [self.rightActionButton setTitle:[NSBundle t:bUnblock] forState:UIControlStateSelected];

    self.rightActionButton.hidden = !BChatSDK.blocking || _user.isMe;
    if(BChatSDK.blocking) {
        self.rightActionButton.selected = [BChatSDK.blocking isBlocked:_user.entityID];
    }
}



@end
