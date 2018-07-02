//
//  BRegisterTableViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BDetailedProfileTableViewController.h"

#import <ChatSDK/UI.h>

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
@synthesize overrideUser;

@synthesize addFriendImageView;
@synthesize addFriendTextView;
@synthesize addFriendActivityIndicator;

@synthesize blockImageView;
@synthesize blockTextView;
@synthesize blockUserActivityIndicator;

@synthesize statusCell;
@synthesize locationCell;
@synthesize addFriendCell;
@synthesize blockUserCell;

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = [NSBundle t:bProfile];
        [self updateTabBarIcon];
        _notificationList = [BNotificationObserverList new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _anonymousProfilePicture = [BChatSDK config].defaultBlankAvatar;
    profilePictureButton.layer.cornerRadius = 50;
    
    self.hideSectionsWithHiddenRows = YES;
    
    [self refreshInterfaceAnimated:NO];

    
}

-(id<PUser>) user {
    if (self.overrideUser) {
        return self.overrideUser;
    }
    else {
        return NM.currentUser;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Update the user's details
    id<PUser> user = self.user;
    
    if (overrideUser) {
        self.title = user.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_22_chat.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(startChat)];
        
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
    [_notificationList add:[[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshInterfaceAnimated:NO];
        });
    }]];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_notificationList dispose];
}

-(void) refreshInterfaceAnimated: (BOOL) animated {

    [self updateTabBarIcon];

    id<PUser> user = self.user;
    
    // Stop the app from crashing when we log out
    if (!user) {
        return;
    }

    UIImage * countryCodeImage = [NSBundle imageNamed:[user metaStringForKey:bCountry] framework:@"CountryPicker" bundle:@"CountryPicker"];
    [flagImageView setImage:countryCodeImage];
    
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
    [user loadProfileImage: YES].thenOnMain(^id(UIImage * image) {
        [profilePictureButton setImage:image forState:UIControlStateNormal];
        return image;
    }, Nil);
    
    [self reloadDataAnimated:animated];
}

-(void) setIsFriend: (BOOL) isFriend setRemote: (BOOL) setRemote {
    
    addFriendActivityIndicator.hidden = NO;
    [addFriendActivityIndicator startAnimating];
    
    // Handle the result:
//    promise_completionHandler_t success = ^id(id success) {
//        addFriendImageView.highlighted = isFriend;
//        addFriendTextView.text = isFriend ? [NSBundle t: bRemoveFriend] : [NSBundle t:bAddFriend];
//        addFriendActivityIndicator.hidden = YES;
//        return success;
//    };
//    
//    promise_errorHandler_t error = ^id(NSError * error) {
//        addFriendActivityIndicator.hidden = YES;
//        return error;
//    };
}

-(BOOL) isFriend {
    return addFriendImageView.highlighted;
}

-(void) setIsBlocked: (BOOL) isBlocked setRemote: (BOOL) setRemote {
    
    blockUserActivityIndicator.hidden = NO;
    [blockUserActivityIndicator startAnimating];
    
    // Handle the result:
//    promise_completionHandler_t success = ^id(id success) {
//        blockImageView.highlighted = isBlocked;
//        blockTextView.text = isBlocked ? [NSBundle t:bUnblock] : [NSBundle t:bBlock];
//        blockUserActivityIndicator.hidden = YES;
//        return success;
//    };
//
//    promise_errorHandler_t error = ^id(NSError * error) {
//        blockUserActivityIndicator.hidden = YES;
//        return error;
//    };
}

-(BOOL) isBlocked {
    return blockImageView.highlighted;
}

-(void) updateTabBarIcon {
    BOOL female = [[NM.currentUser metaStringForKey:bGender] isEqualToString:@"F"];
    self.tabBarItem.image = [NSBundle uiImageNamed: female ? @"icn_30_profile_f.png" :  @"icn_30_profile.png"];
    self.tabBarItem.selectedImage = [NSBundle uiImageNamed: female ? @"icn_30_profile_f.png" :  @"icn_30_profile.png"];
}

-(UIImage *) profilePicture {
    id<PUser> user = NM.currentUser;
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
    
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_picker animated:YES completion:Nil];
}

-(void) startChat {
    [NM.core createThreadWithUsers:@[self.overrideUser] threadCreated:^(NSError * error, id<PThread> thread) {
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
    id<PUser> user = NM.currentUser;
    [user setImage:UIImagePNGRepresentation(image)];
    
    [NM.core pushUser];
    
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
