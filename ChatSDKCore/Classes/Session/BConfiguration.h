//
//  BConfiguration.h
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import <Foundation/Foundation.h>

@interface BConfiguration : NSObject {
    NSString * _defaultUserName;
}

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
@property (nonatomic, readonly) NSString * defaultUserName;
@property (nonatomic, readwrite) NSString * defaultUserNamePrefix;

// Should empty chats be shown in the threads view?
@property (nonatomic, readwrite) BOOL showEmptyChats;

// User profile image
@property (nonatomic, readwrite) NSString * defaultAvatarURL;

// Which image should be used if no avatar is set
@property (nonatomic, readwrite) UIImage * defaultBlankAvatar;

@property (nonatomic, readwrite) NSString * timeFormat;

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

// Login username / email placeholder text
@property (nonatomic, readwrite) NSString * loginUsernamePlaceholder;

// When a push notification is clicked, should the chat screen be opened
@property(nonatomic, readwrite) BOOL shouldOpenChatWhenPushNotificationClicked;

// Allow the owner of a public thread to delete it
@property (nonatomic, readwrite) BOOL allowPublicThreadDeletion;

// Message fonts
@property (nonatomic, readwrite) UIFont * messageTextFont;
@property (nonatomic, readwrite) NSString * messageTextColorMe;
@property (nonatomic, readwrite) NSString * messageTextColorReply;

@property (nonatomic, readwrite) UIFont * messageTimeFont;
@property (nonatomic, readwrite) UIFont * messageNameFont;

@property (nonatomic, readwrite) UIFont * threadTitleFont;
@property (nonatomic, readwrite) UIFont * threadTimeFont;
@property (nonatomic, readwrite) UIFont * threadSubtitleFont;

@property (nonatomic, readwrite) BOOL locationMessagesEnabled;
@property (nonatomic, readwrite) BOOL imageMessagesEnabled;

// How many messages should be loaded initially when a chat is opened
@property (nonatomic, readwrite) int chatMessagesToLoad;

// Push notification sound - name of sound file to play i.e. "mySound"
@property (nonatomic, readwrite) NSString * pushNotificationSound;

@property (nonatomic, readwrite) NSString * googleMapsApiKey;

// Reset the database when core data changes
@property (nonatomic, readwrite) BOOL clearDataWhenRootPathChanges;

// Firebase options

// Should the Chat SDK call [FIRApp configure];
@property (nonatomic, readwrite) BOOL firebaseShouldConfigureAutomatically;

// The name of the custom Firebase Google-Services plist file
@property (nonatomic, readwrite) NSString * firebaseGoogleServicesPlistName;

// Chat SDK can auto-detect and install modules. Some modules need to a different setup
// procedure depending on which server is being used - Firebase or XMPP. If only one
// network adapter is set, modules will be installed for that server but if there
// are multiple network adapters in the source code, the default server will be used
// Allowable values:
// bServerFirebase
// bServerXMPP
@property (nonatomic, readwrite) NSString * defaultServer;

// Message data properties
// This should be used for backwards compatibility with v3 of the project
@property (nonatomic, readwrite) BOOL includeMessagePayload;

// This should be enabled for compatibility with any version less than 4.3.x
@property (nonatomic, readwrite) BOOL includeMessageJSON;

// In the future we will be moving towards using native JSON for the message payload enable this for 4.4.x+
@property (nonatomic, readwrite) BOOL includeMessageJSONV2;

#define bChatSDK_API_1 @"3.x"
#define bChatSDK_API_2 @"4.0.0 - 4.3.18"
#define bChatSDK_API_3 @"4.4.0+"

// Configure Chat SDK to support the API levels of choice
// The default version supports all API levels
-(void) configureForCompatibilityWithVersions: (NSArray *) versions;

+(BConfiguration *) configuration;

@end
