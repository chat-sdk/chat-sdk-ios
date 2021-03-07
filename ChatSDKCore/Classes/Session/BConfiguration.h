//
//  BConfiguration.h
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PMessage.h>

#define bEmailTitle @"email_title"
#define bEmailBody @"email_body"
#define bSMSBody @"sms_body"

#define bXMPPKey @"xmpp"
#define bXMPPHostAddressKey @"host_address"
#define bXMPPDomainKey @"domain"
#define bXMPPPortKey @"port"
#define bXMPPResourceKey @"resource"

typedef enum {
    bNameLabelPositionTop,
    bNameLabelPositionBottom
} bNameLabelPosition;

@interface BConfiguration : NSObject {
    NSString * _defaultUserName;
    NSMutableDictionary * _messageBubblePadding;
    NSMutableDictionary * _messageBubbleMargin;
}

// Should we ask the user to allow notifications when the app initially loads up? 
@property (nonatomic, readwrite) BOOL shouldAskForNotificationsPermission;
    
// The Firebase root path. Data will be added to Firebase root/rootPath...
// this allows you to run multiple chat instances on one Firebase database
@property (nonatomic, readwrite) NSString * rootPath;

// Enable the unread messages count on the main app badge
@property (nonatomic, readwrite) BOOL appBadgeEnabled;

// What will the user be called when they first sign up and before they
// set their name
@property (nonatomic, readonly) NSString * defaultUserName;
@property (nonatomic, readwrite) NSString * defaultUserNamePrefix;

// These will be input into the login screen if they are set
@property (nonatomic, readwrite) NSString * debugUsername;
@property (nonatomic, readwrite) NSString * debugPassword;

// When debug mode is enabled, there will be more logging
@property (nonatomic, readwrite) BOOL debugModeEnabled;

// Should empty chats be shown in the threads view?
@property (nonatomic, readwrite) BOOL showEmptyChats;

// User profile image
@property (nonatomic, readwrite) NSString * defaultAvatarURL;

// Provide a URL to generate an avatar
// This URL should provide a link to a PNG to be used
// it should be the form http://someurl.com/%s.png
// %s will be replaced by the user's entity ID
@property (nonatomic, readwrite) NSString * identiconBaseURL;

// User profile image
@property (nonatomic, readwrite) UIImage * xmppDefaultAvatar;

@property (nonatomic, readwrite) NSString * timeFormat;

// The maximum dimension for an image message
@property (nonatomic, readwrite) int maxImageDimension;

// Can users make new public chats. It's recommended to set this to no otherwise
// users will create a large number of chats
@property (nonatomic, readwrite) BOOL allowUsersToCreatePublicChats;

// How many historic messages should be downloaded for an empty thread
@property (nonatomic, readwrite) int messageHistoryDownloadLimit;

@property (nonatomic, readwrite) BOOL messageSelectionEnabled;

// How many message deletion listeners should we add? A value of 10 would mean
// that if any of the last 10 messages are deleted, the app would be updated
@property (nonatomic, readwrite) int messageDeletionListenerLimit;

// The maximum age of a read receipt. Any older than this and we
// won't add the read receipt listener
@property (nonatomic, readwrite) float readReceiptMaxAgeInSeconds;

// Are group chats encrypted? Only relevant if encryption module is enabled
@property (nonatomic, readwrite) BOOL encryptGroupThreads;

// Enable or disable social login options
@property (nonatomic, readwrite) BOOL anonymousLoginEnabled;
@property (nonatomic, readwrite) BOOL forgotPasswordEnabled;
@property (nonatomic, readwrite) BOOL termsAndConditionsEnabled;

@property (nonatomic, readwrite) NSString * xmppDomain;
@property (nonatomic, readwrite) NSString * xmppHostAddress;
@property (nonatomic, readwrite) int xmppPort;
@property (nonatomic, readwrite) NSString * xmppResource;
@property (nonatomic, readwrite) int xmppMucMessageHistory;
@property (nonatomic, readwrite) NSString * termsOfServiceURL;
@property (nonatomic, readwrite) BOOL xmppCustomCertEvaluation;
@property (nonatomic, readwrite) NSString * xmppPubsubNode;
@property (nonatomic, readwrite) BOOL xmppInvisibleModeEnabled;

@property (nonatomic, readwrite) NSString * xmppUpdateLastOnlineOnResignActive;
@property (nonatomic, readwrite) BOOL xmppReciprocalPresenceRequests;

@property (nonatomic, readwrite) BOOL threadDestructionEnabled;
@property (nonatomic, readwrite) BOOL callsEnabled;

@property (nonatomic, readwrite) NSTimeInterval xmppPingInterval;
@property (nonatomic, readwrite) NSTimeInterval xmppPingTimeout;

@property (nonatomic, readwrite) BOOL xmppAdvancedConfigurationEnabled;

@property (nonatomic, readwrite) BOOL messageDeletionEnabled;

// The message view text input box, max lines and characters
@property (nonatomic, readwrite) int textInputViewMaxLines;
@property (nonatomic, readwrite) int textInputViewMaxCharacters;

@property(nonatomic, readwrite) BOOL publicChatAutoSubscriptionEnabled;

// The the image to be displayed on the login screen. Image should be
// 120x120px
@property (nonatomic, readwrite) UIImage * logoImage;

// The app name text displayed on the login screen
@property (nonatomic, readwrite) NSString * loginScreenAppName;

// Login username / email placeholder text
@property (nonatomic, readwrite) NSString * loginUsernamePlaceholder;

// When a push notification is clicked, should the chat screen be opened
@property(nonatomic, readwrite) BOOL shouldOpenChatWhenPushNotificationClicked;

// This allows us to make it so the chat will only be opened if the tab bar is visible. This can be
// useful in some advanced situations where the tab bar may not be the root view
@property(nonatomic, readwrite) BOOL shouldOpenChatWhenPushNotificationClickedOnlyIfTabBarVisible;

// Should the client send push notifications?
@property(nonatomic, readwrite) BOOL clientPushEnabled;

// Where should we show the user avatar?
@property(nonatomic, readwrite) bMessagePos showMessageAvatarAtPosition;

@property(nonatomic, readwrite) NSString * messageBubbleMaskFirst;
@property(nonatomic, readwrite) NSString * messageBubbleMaskMiddle;
@property(nonatomic, readwrite) NSString * messageBubbleMaskLast;
@property(nonatomic, readwrite) NSString * messageBubbleMaskSingle;

@property(nonatomic, readwrite) BOOL disableSendButtonWhenDisconnected;
@property(nonatomic, readwrite) BOOL disableSendButtonWhenNotReachable;

@property (nonatomic, readwrite) BOOL xmppOutgoingMessageQueueEnabled;
@property (nonatomic, readwrite) BOOL xmppSendPushOnAck;

@property(nonatomic, readwrite) bNameLabelPosition nameLabelPosition;
@property(nonatomic, readwrite) BOOL combineTimeWithNameLabel;

// Allow the owner of a public thread to delete it
@property (nonatomic, readwrite) BOOL allowPublicThreadDeletion;

// Show the unread message badge for public threads
@property (nonatomic, readwrite) BOOL showPublicThreadsUnreadMessageBadge;

// Can the user click the title bar to open the chat info
@property (nonatomic, readwrite) BOOL userChatInfoEnabled;

// Phone book module invite by email title and body
@property (nonatomic, readwrite) NSString * inviteByEmailTitle;
@property (nonatomic, readwrite) NSString * inviteByEmailBody;
@property (nonatomic, readwrite) NSString * inviteBySMSBody;

// Message fonts
@property (nonatomic, readwrite) UIFont * messageTextFont;

@property (nonatomic, readwrite) UIFont * messageTimeFont;
@property (nonatomic, readwrite) UIFont * messageNameFont;

@property (nonatomic, readwrite) UIFont * threadTitleFont;
@property (nonatomic, readwrite) UIFont * threadTimeFont;
@property (nonatomic, readwrite) UIFont * threadSubtitleFont;

@property (nonatomic, readwrite) BOOL locationMessagesEnabled;
@property (nonatomic, readwrite) BOOL imageMessagesEnabled;

@property (nonatomic, readwrite) BOOL autoSaveOnTerminate;

@property (nonatomic, readwrite) int audioMessageMaxLengthSeconds;

@property (nonatomic, readwrite) BOOL prefersLargeTitles;

@property (nonatomic, readwrite) NSMutableDictionary * remote;
@property (nonatomic, readwrite) BOOL remoteConfigEnabled;

// The default search indexes - i.e. which user/meta values are we searching for? If you add
// custom values remember to add the relevant indexOn values to the Firebase security rules
@property (nonatomic, readwrite) NSArray * searchIndexes;

// How many messages should be loaded initially when a chat is opened
// Deprecated: use messagesToLoadPerBatch
@property (nonatomic, readwrite) int chatMessagesToLoad;
@property (nonatomic, readwrite) int messagesToLoadPerBatch;

// Push notification sound - name of sound file to play i.e. "mySound"
@property (nonatomic, readwrite) NSString * pushNotificationSound;

// The action associated with the push notification
@property (nonatomic, readwrite) NSString * pushNotificationAction;

// If this is true, then we will only send a push notification if the recipient is offline
@property (nonatomic, readwrite) BOOL onlySendPushToOfflineUsers;


@property (nonatomic, readwrite) NSString * googleMapsApiKey;

// Reset the database when core data changes
@property (nonatomic, readwrite) BOOL clearDataWhenRootPathChanges;

// Database version
@property (nonatomic, readwrite) NSString * databaseVersion;

// If this databbase version changes, the database will be cleared and re-populated from Firebase
@property (nonatomic, readwrite) BOOL clearDatabaseWhenDataVersionChanges;

// Optimization

// If this is set to true, no presence information will be sent or listened to
@property (nonatomic, readwrite) BOOL disablePresence;

// If this is set to true, then the local user profile will be neither pulled or pushed to Firbase on authentication
@property (nonatomic, readwrite) BOOL disableProfileUpdateOnAuthentication;

// In development mode the app will be more tolerant to remote database corruption. But it will use more bandwidth
@property (nonatomic, readwrite) BOOL developmentModeEnabled;

@property (nonatomic, readwrite) BOOL disablePublicThreads;

// If this is true, extra data will be added to support Chat SDK web
@property (nonatomic, readwrite) BOOL enableWebCompatibility;



// Firebase options

// The name of the custom Firebase Google-Services plist file
//@property (nonatomic, readwrite) NSString * firebaseGoogleServicesPlistName;

@property (nonatomic, readwrite) NSString * firebaseDatabaseURL;
//@property (nonatomic, readwrite) NSString * firebaseApp;
@property (nonatomic, readwrite) NSString * firebaseFunctionsRegion;
@property (nonatomic, readwrite) NSString * firebaseStorageURL;

// Chat SDK can auto-detect and install modules. Some modules need to a different setup
// procedure depending on which server is being used - Firebase or XMPP. If only one
// network adapter is set, modules will be installed for that server but if there
// are multiple network adapters in the source code, the default server will be used
// Allowable values:
// bServerFirebase
// bServerXMPP
@property (nonatomic, readwrite) NSString * defaultServer;

@property (nonatomic, readwrite) BOOL showUserAvatarsOn1to1Threads;

@property (nonatomic, readwrite) BOOL enableMessageModerationTab;

// Show local notifications when a message is received
@property (nonatomic, readwrite) BOOL showLocalNotifications;
@property (nonatomic, readwrite) BOOL showLocalNotificationsForPublicChats;
@property (nonatomic, readwrite) BOOL showLocalNotificationInChat;
@property (nonatomic, readwrite) BOOL showLocalNotificationForEncryptedChats;

// Profile Pictures
@property (nonatomic, readwrite) BOOL profilePicturesEnabled;
// Show Profil view when tap on profil Icon
@property (nonatomic, readwrite) BOOL showProfileViewOnTap;
// Nearby Users Module Settings

// Distance bands in meters
@property (nonatomic, readwrite) NSArray<NSNumber *> * nearbyUserDistanceBands;

// How much distance must be moved to update the server with our new location
@property (nonatomic, readwrite) int nearbyUsersMinimumLocationChangeToUpdateServer;

// XMPP Auth type used which can be:
// default, scramsha1, digestmd5, plain
@property (nonatomic, readwrite) NSString * xmppAuthType;
@property (nonatomic, readwrite) BOOL xmppUseHTTP;

// How long should a public chat room live until expires and is removed from the list
@property (nonatomic, readwrite) int publicChatRoomLifetimeMinutes;

@property (nonatomic, readwrite) BOOL vibrateOnNewMessage;

+(BConfiguration *) configuration;

-(void) xmppWithHostAddress: (NSString *) hostAddress;
-(void) xmppWithDomain: (NSString *) domain hostAddress: (NSString *) hostAddress;
-(void) xmppWithDomain: (NSString *) domain hostAddress: (NSString *) hostAddress port: (int) port;
-(void) xmppWithDomain: (NSString *) domain hostAddress: (NSString *) hostAddress port: (int) port resource: (NSString *) resource;

-(void) setMessageBubbleMargin: (UIEdgeInsets) margin forMessageType: (bMessageType) type;
-(void) setMessageBubblePadding: (UIEdgeInsets) padding forMessageType: (bMessageType) type;

-(NSValue *) messageBubbleMarginForType: (bMessageType) type;
-(NSValue *) messageBubblePaddingForType: (bMessageType) type;

-(id) remoteConfigValueForKey: (NSString *) key;
-(void) setRemoteConfig: (NSDictionary *) dict;
-(void) setRemoteConfigValue: (id) value forKey: (NSString *) key;

@end
