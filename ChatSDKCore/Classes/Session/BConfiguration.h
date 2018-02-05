//
//  BConfiguration.h
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import <Foundation/Foundation.h>

@interface BConfiguration : NSObject

// Background color of messages: hex value like "FFFFFF"
@property (nonatomic, readwrite) NSString * messageColorMe;
@property (nonatomic, readwrite) NSString * messageColorReply;

// The Firebase root path. Data will be added to Firebase root/rootPath...
// this allows you to run multiple chat instances on one Firebase database
@property (nonatomic, readwrite) NSString * rootPath;

// Enable the unread messages count on the main app badge
@property (nonatomic, readwrite) BOOL appBadgeEnabled;

// What will the user be called when they first sign up and before they
// set their name
@property (nonatomic, readwrite) NSString * defaultUserName;
@property (nonatomic, readwrite) NSString * defaultUserNamePrefix;

// Should empty chats be shown in the threads view?
@property (nonatomic, readwrite) BOOL showEmptyChats;

// Can users make new public chats. It's recommended to set this to no otherwise
// users will create a large number of chats
@property (nonatomic, readwrite) BOOL allowUsersToCreatePublicChats;

// Enable or disable social login options
@property (nonatomic, readwrite) BOOL googleLoginEnabled;
@property (nonatomic, readwrite) BOOL facebookLoginEnabled;
@property (nonatomic, readwrite) BOOL twitterLoginEnabled;
@property (nonatomic, readwrite) BOOL anonymousLoginEnabled;

// The the image to be displayed on the login screen. Image should be
// 120x120px
@property (nonatomic, readwrite) UIImage * loginScreenLogoImage;

// The app name text displayed on the login screen
@property (nonatomic, readwrite) NSString * loginScreenAppName;

// When a push notification is clicked, should the chat screen be opened
@property(nonatomic, readwrite) BOOL shouldOpenChatWhenPushNotificationClicked;

// Chat SDK can auto-detect and install modules. Some modules need to a different setup
// procedure depending on which server is being used - Firebase or XMPP. If only one
// network adapter is set, modules will be installed for that server but if there
// are multiple network adapters in the source code, the default server will be used
// Allowable values:
// bServerFirebase
// bServerXMPP
@property (nonatomic, readwrite) NSString * defaultServer;

+(BConfiguration *) configuration;

@end
