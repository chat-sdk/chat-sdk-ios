//
//  BRegisterTableViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 22/05/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BDetailedProfileTableViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bStatusSection 1
#define bBlockCellTag 2
#define bAddContactCellTag 3

@interface BDetailedProfileTableViewController ()

@end

@implementation BDetailedProfileTableViewController

@synthesize profilePictureButton;
@synthesize flagImageView;
@synthesize nameLabel;
@synthesize statusTextView;
@synthesize localityLabel;
@synthesize phoneNumberLabel;
@synthesize emailLabel;

@synthesize user;

@synthesize blockImageView;
@synthesize blockTextView;
@synthesize blockUserActivityIndicator;
@synthesize availabilityLabel;

@synthesize statusCell;
@synthesize localityCell;
@synthesize blockUserCell;
@synthesize phoneNumberCell;
@synthesize emailCell;
@synthesize availabilityCell;
@synthesize addContactCell;

@synthesize addContactLabel;
@synthesize addContactImageView;

-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.title = [NSBundle t:bProfile];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_profile.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _anonymousProfilePicture = [NSBundle uiImageNamed:bDefaultProfileImage];
    profilePictureButton.layer.cornerRadius = 50;
    
    self.hideSectionsWithHiddenRows = YES;
    
    [self refreshInterfaceAnimated:NO];

    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationUserUpdated
                                                      object:Nil
                                                       queue:Nil
                                                  usingBlock:^(NSNotification * notification) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self reloadDataAnimated:NO];
                                                      });

    }];
    
    [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
        user = Nil;
    }] withName:bHookDidLogout];
    
//    NSString * backButtonTitle = self.title;
//    if (backButtonTitle.length > 9) {
//        backButtonTitle = [[backButtonTitle substringToIndex:9] stringByAppendingString:@"..."];
//    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStylePlain target:Nil action:Nil];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(!user) {
        user = BChatSDK.currentUser;
    }
    
    [self refreshInterfaceAnimated:NO];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_userObserver];
}

-(void) refreshInterfaceAnimated: (BOOL) animated {

    BDetailedUserWrapper * userWrapper = [BDetailedUserWrapper wrapperWithUser:user];
    
    // Stop the app from crashing when we log out
    if (!user) {
        return;
    }
    
    self.profilePictureButton.userInteractionEnabled = NO;
    if (!self.user.isMe) {
        self.title = user.name;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[NSBundle uiImageNamed:@"icn_22_chat.png"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(startChat)];
    }

    //
    // Flag
    //
    
    UIImage * flag = [NSBundle imageNamed:userWrapper.country framework:@"CountryPicker" bundle:@"CountryPicker"];
    [flagImageView setImage:flag];
    
    //
    // Name
    //
    
    nameLabel.text = user.name;

    //
    // Status
    //
    
    NSString * status = user.statusText;
    if (!status || status.length == 0) {
        status = @"";
    }
    statusTextView.text = status;
    
    [self cell:statusCell setHidden:!status || ![status stringByReplacingOccurrencesOfString:@" " withString:@""].length];

    //
    // City
    //
    
    NSString * locality = userWrapper.locality;
    localityLabel.text = locality;
    
    [self cell:localityCell setHidden:!locality || !locality.length];
        
    //
    // Phone number
    //
    
    phoneNumberLabel.text = user.phoneNumber;
    [self cell:phoneNumberCell setHidden:!user.phoneNumber || !user.phoneNumber.length];

    //
    // Email
    //

    emailLabel.text = user.email;
    [self cell:emailCell setHidden:!user.email || !user.email.length];
    
    //
    // Profile picture
    //

    [profilePictureButton loadAvatarForUser:user forControlState:UIControlStateNormal];
    
    //
    // State
    //
    
    NSString * availability = [BAvailabilityState titleForKey:user.availability];
    
    // There are two more states... If the user has no state but they are online
    // then their state is online. If they are offline, their state is offline
    if (!availability || !availability.length) {
        if (user.online.boolValue) {
            availability = [NSBundle t:bAvailable];
        }
        else {
            availability = [NSBundle t:bOffline];
        }
    }
    availabilityLabel.text = availability;
    
    [self cell:availabilityCell setHidden:!availabilityLabel.text || !availabilityLabel.text.length];

    //
    // Contact
    //
    
    [self cell:addContactCell setHidden:user.isMe];

    //
    // Blocking
    //
    
    [self cell:blockUserCell setHidden:user.isMe || !BChatSDK.blocking || !BChatSDK.blocking.serviceAvailable];
    
    BOOL isBlocked = [BChatSDK.blocking isBlocked:user.entityID];
    [self setIsBlocked:isBlocked setRemote:NO];
    
    if (self.isContact) {
        addContactLabel.text = [NSBundle t: bDelete];
        addContactLabel.textColor = [UIColor redColor];
        addContactImageView.highlighted = YES;
    } else {
        addContactLabel.text = [NSBundle t: bAddContact];
        addContactImageView.highlighted = NO;
        addContactLabel.textColor = [UIColor darkGrayColor];
    }
    
    id<PUserConnection> userConnection = self.userConnection;
    BUserConnectionWrapper * wrapper = [BUserConnectionWrapper wrapperWithConnection:userConnection];
    
    // Presence
    BOOL hideFollow = !userConnection || !userConnection.subscriptionType || !wrapper.ask;
    [self cell:_followsCell setHidden:hideFollow];
    [self cell:_followedCell setHidden:hideFollow];
    
    UIImage * tick = [NSBundle uiImageNamed:@"icn_36_tick.png"];
    UIImage * cross = [NSBundle uiImageNamed:@"icn_36_cross.png"];
    UIImage * clock = [NSBundle uiImageNamed:@"icn_36_clock.png"];
    
    // Choose the icons based on the presence status
    bSubscriptionType subscription = userConnection.subscriptionType;
    BOOL ask = wrapper.ask != Nil;
   
    // Follows
    if (ask) {
        [_followsButton setImage:clock forState:UIControlStateNormal];
    }
    else {
        [_followsButton setImage:subscription & bSubscriptionTypeFrom ? tick : cross forState:UIControlStateNormal];
    }
    [_followedButton setImage:subscription & bSubscriptionTypeTo ? tick : cross forState:UIControlStateNormal];
    
    [self reloadDataAnimated:animated];
}

-(id<PUserConnection>) userConnection {
    // Get the user connection
    id<PUser> currentUser = BChatSDK.currentUser;
    for (id<PUserConnection> connection in [currentUser connectionsWithType:bUserConnectionTypeContact]) {
        if ([connection.user isEqualToEntity:user]) {
            return connection;
        }
    }
    return Nil;
}

-(void) setIsBlocked: (BOOL) isBlocked setRemote: (BOOL) setRemote {
    
    blockUserActivityIndicator.hidden = NO;
    [blockUserActivityIndicator startAnimating];
    
    promise_completionHandler_t success = ^id(id success) {
        self.blockImageView.highlighted = isBlocked;
        self.blockTextView.text = isBlocked ? [NSBundle t:bUnblock] : [NSBundle t:bBlock];
        self.blockUserActivityIndicator.hidden = YES;
        return Nil;
    };
    
    promise_errorHandler_t error = ^id(NSError * error) {
        self.blockUserActivityIndicator.hidden = YES;
        return Nil;
    };
    
    if (setRemote) {
        if (isBlocked) {
            [BChatSDK.blocking blockUser:user.entityID].thenOnMain(success, error);
        }
        else {
            [BChatSDK.blocking unblockUser:user.entityID].thenOnMain(success, error);
        }
    }
    else {
        success(Nil);
    }
}

-(void) deleteUser {
    [BChatSDK.contact deleteContact:self.user withType:bUserConnectionTypeContact].thenOnMain(^id(id success) {
        [self refreshInterfaceAnimated:NO];
        return Nil;
    }, ^id(NSError * error) {
        [UIView alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
        return Nil;
    });
}

-(void) addContact {
    [BChatSDK.contact addContact:self.user withType:bUserConnectionTypeContact].thenOnMain(^id(id success) {
        [self refreshInterfaceAnimated:NO];
        return Nil;
    }, ^id(NSError * error) {
        [UIView alertWithTitle:[NSBundle t:bErrorTitle] withError:error];
        return Nil;
    });
}

-(BOOL) isBlocked {
    return blockImageView.highlighted;
}

//-(UIImage *) profilePicture {
//    id<PUser> user = BChatSDK.currentUser;
//    return user.imageAsImage;
//}

-(void) startChat {
    [BChatSDK.core createThreadWithUsers:@[self.user] threadCreated:^(NSError * error, id<PThread> thread) {
        BChatViewController * cvc = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:cvc animated:YES];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == bBlockCellTag) {
        [self setIsBlocked:!self.isBlocked setRemote:YES];
    }
    if (cell.tag == bAddContactCellTag) {
        if (self.isContact) {
            [[[UIAlertView alloc] initWithTitle:[NSBundle t:bDeleteContact]
                                        message:[NSBundle t:bDeleteContactMessage]
                                       delegate:self
                              cancelButtonTitle:[NSBundle t:bCancel]
                              otherButtonTitles:[NSBundle t:bOk], nil] show];
        } else {
            [self addContact];
        }
    }
}

-(BOOL) isContact {
    id<PUserConnection> userConnection = self.userConnection;
    // If the user is a contact
    return userConnection && userConnection.type.intValue == bUserConnectionTypeContact;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self deleteUser];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == bStatusSection) {
        return [statusTextView heightToFitText] + 18;
    }
    return [super tableView: tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)editButtonPressed:(id)sender {
    
    //[[BNetworkManager sharedManager].authenticationAdapter logout];

    
    BDetailedEditProfileTableViewController * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditProfile"];
    vc.profileViewController = self;
    UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:Nil];
}

-(BOOL) userIsCurrent {
    return [user isMe];
}


@end
