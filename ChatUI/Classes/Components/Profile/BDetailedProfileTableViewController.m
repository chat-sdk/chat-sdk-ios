//
//  BRegisterTableViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BDetailedProfileTableViewController.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bStatusSection 1
#define bAddFriendCellTag 1
#define bBlockCellTag 2

@interface BDetailedProfileTableViewController ()

@end

@implementation BDetailedProfileTableViewController

@synthesize profilePictureButton;
@synthesize flagImageView;
@synthesize genderButton;
@synthesize nameLabel;
@synthesize statusTextView;
@synthesize locationLabel;
@synthesize ageLabel;
@synthesize overrideUser;

@synthesize addFriendImageView;
@synthesize addFriendTextView;
@synthesize addFriendActivityIndicator;

@synthesize blockImageView;
@synthesize blockTextView;
@synthesize blockUserActivityIndicator;

@synthesize statusCell;
@synthesize locationCell;
@synthesize ageCell;
@synthesize addFriendCell;
@synthesize blockUserCell;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = [NSBundle t:bProfile];
        [self updateTabBarIcon];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _anonymousProfilePicture = [UIImage imageNamed:bDefaultProfileImage];
    profilePictureButton.layer.cornerRadius = 50;
    
    self.hideSectionsWithHiddenRows = YES;
    
    [self refreshInterfaceAnimated:NO];

    
}

-(id<PUser>) user {
    if (self.overrideUser) {
        return self.overrideUser;
    }
    else {
        return [BNetworkManager sharedManager].a.core.currentUserModel;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Update the user's details
    id<PUser> user = self.user;
    
    if (overrideUser) {
        self.title = user.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_22_chat.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(startChat)];
        
        self.editPhotoButton.hidden = YES;
        self.profilePictureButton.userInteractionEnabled = NO;
    }
    else {
        [self cell:addFriendCell setHidden:YES];
        [self cell:blockUserCell setHidden:YES];
    }
    
    [self refreshInterfaceAnimated:NO];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _userObserver = [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        [self refreshInterfaceAnimated:NO];
    }];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_userObserver];
}

-(void) refreshInterfaceAnimated: (BOOL) animated {

    [self updateTabBarIcon];

    id<PUser> user = self.user;
    
    // Stop the app from crashing when we log out
    if (!user) {
        return;
    }

    NSString * countryCodeImage = [NSString stringWithFormat:@"CountryPicker.bundle/%@.png",[user metaStringForKey:bCountry]];
    [flagImageView setImage:[UIImage imageNamed:countryCodeImage]];
    
    nameLabel.text = [user metaStringForKey:bName];
    
    NSString * status = [user metaStringForKey:bDescription];
    if (!status || status.length == 0) {
        status = @"";
    }
    statusTextView.text = status;
    
    [self cell:statusCell setHidden:!status || ![status stringByReplacingOccurrencesOfString:@" " withString:@""].length];
    
    NSString * location = [user metaStringForKey:bLocation];
    locationLabel.text = location;
    
    [self cell:locationCell setHidden:!location || !location.length];
    
    genderButton.selected = [[user metaStringForKey:bGender] isEqualToString:@"F"];
    
    // Set the profile picture
    // Does the user already have a profile picture?
    [user updateImageFromMetaData: YES].thenOnMain(^id(UIImage * image) {
        [profilePictureButton setImage:image forState:UIControlStateNormal];
        return image;
    }, Nil);
    
    [self reloadDataAnimated:animated];
}

-(void) setIsFriend: (BOOL) isFriend setRemote: (BOOL) setRemote {
    
    addFriendActivityIndicator.hidden = NO;
    [addFriendActivityIndicator startAnimating];
    
    // Handle the result:
    promise_completionHandler_t success = ^id(id success) {
        addFriendImageView.highlighted = isFriend;
        addFriendTextView.text = isFriend ? [NSBundle t: bRemoveFriend] : [NSBundle t:bAddFriend];
        addFriendActivityIndicator.hidden = YES;
        return success;
    };
    
    promise_errorHandler_t error = ^id(NSError * error) {
        addFriendActivityIndicator.hidden = YES;
        return error;
    };
}

-(BOOL) isFriend {
    return addFriendImageView.highlighted;
}

-(void) setIsBlocked: (BOOL) isBlocked setRemote: (BOOL) setRemote {
    
    blockUserActivityIndicator.hidden = NO;
    [blockUserActivityIndicator startAnimating];
    
    // Handle the result:
    promise_completionHandler_t success = ^id(id success) {
        blockImageView.highlighted = isBlocked;
        blockTextView.text = isBlocked ? [NSBundle t:bUnblock] : [NSBundle t:bBlock];
        blockUserActivityIndicator.hidden = YES;
        return success;
    };
    
    promise_errorHandler_t error = ^id(NSError * error) {
        blockUserActivityIndicator.hidden = YES;
        return error;
    };
}

-(BOOL) isBlocked {
    return blockImageView.highlighted;
}

-(void) updateTabBarIcon {
    BOOL female = [[[BNetworkManager sharedManager].a.core.currentUserModel metaStringForKey:bGender] isEqualToString:@"F"];
    self.tabBarItem.image = [UIImage imageNamed: female ? @"icn_30_profile_f.png" :  @"icn_30_profile.png"];
    self.tabBarItem.selectedImage = [UIImage imageNamed: female ? @"icn_30_profile_f.png" :  @"icn_30_profile.png"];
}

-(UIImage *) profilePicture {
    id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;
    return user.imageAsImage;
}

- (IBAction)editButtonPressed:(id)sender {
    [self profilePictureButtonPressed:Nil];
}

- (IBAction)profilePictureButtonPressed:(UIButton *)sender {
    
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
    }
    
    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:_picker animated:YES completion:Nil];
}

-(void) startChat {
    [[BNetworkManager sharedManager].a.core createThreadWithUsers:@[self.overrideUser] threadCreated:^(NSError * error, id<PThread> thread) {
        UIViewController * cvc = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Now reduce the image to 200x200 for the profile picture
    image = [image resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];
    
    // Set the user image
    
    // Update the user
    id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;
    [user setImage:UIImagePNGRepresentation(image)];
    
    [[BNetworkManager sharedManager].a.core pushUser];
    
    [picker dismissViewControllerAnimated:YES completion:Nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:Nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == bAddFriendCellTag) {
        [self setIsFriend:!self.isFriend setRemote:YES];
    }
    if (cell.tag == bBlockCellTag) {
        [self setIsBlocked:!self.isBlocked setRemote:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == bStatusSection) {
        return [statusTextView heightToFitText] + 18;
    }
    return [super tableView: tableView heightForRowAtIndexPath:indexPath];
}

@end
