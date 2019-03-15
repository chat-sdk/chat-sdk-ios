//
//  BConfiguration.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BConfiguration.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/BSettingsManager.h>

@implementation BConfiguration

@synthesize messageColorMe;
@synthesize messageColorReply;
@synthesize rootPath;
@synthesize appBadgeEnabled;
@synthesize defaultUserNamePrefix;
@synthesize defaultUserName = _defaultUserName;
@synthesize showEmptyChats;
@synthesize allowUsersToCreatePublicChats;
@synthesize googleLoginEnabled;
@synthesize twitterLoginEnabled;
@synthesize facebookLoginEnabled;
@synthesize anonymousLoginEnabled;
@synthesize defaultServer;
@synthesize shouldOpenChatWhenPushNotificationClicked;
@synthesize includeMessagePayload;
@synthesize includeMessageJSON;
@synthesize includeMessageJSONV2;
@synthesize loginUsernamePlaceholder;
@synthesize defaultAvatarURL;
@synthesize defaultBlankAvatar;
@synthesize timeFormat;
@synthesize chatMessagesToLoad;
@synthesize pushNotificationSound;
@synthesize firebaseGoogleServicesPlistName;
@synthesize firebaseShouldConfigureAutomatically;
@synthesize locationMessagesEnabled;
@synthesize imageMessagesEnabled;
@synthesize googleMapsApiKey;
@synthesize clearDataWhenRootPathChanges;
@synthesize databaseVersion;
@synthesize clearDatabaseWhenDataVersionChanges;
@synthesize showUserAvatarsOn1to1Threads;
@synthesize enableMessageModerationTab;
@synthesize showLocalNotifications;
@synthesize onlySendPushToOfflineUsers;
@synthesize twitterApiKey;
@synthesize twitterSecret;
@synthesize googleClientKey;
@synthesize facebookAppId;
@synthesize userChatInfoEnabled;
@synthesize forgotPasswordEnabled;
@synthesize termsAndConditionsEnabled;
@synthesize clientPushEnabled;
@synthesize defaultGroupChatAvatar;
@synthesize prefersLargeTitles;
@synthesize shouldOpenChatWhenPushNotificationClickedOnlyIfTabBarVisible;
@synthesize showPublicThreadsUnreadMessageBadge;
@synthesize messageHistoryDownloadLimit;
@synthesize messageDeletionListenerLimit;
@synthesize readReceiptMaxAgeInSeconds;

@synthesize inviteByEmailTitle;
@synthesize inviteByEmailBody;
@synthesize inviteBySMSBody;
@synthesize audioMessageMaxLengthSeconds;

@synthesize xmppPort;
@synthesize xmppDomain;
@synthesize xmppResource;
@synthesize xmppHostAddress;
@synthesize xmppMucMessageHistory;

@synthesize textInputViewMaxLines;
@synthesize textInputViewMaxCharacters;

-(instancetype) init {
    if((self = [super init])) {
        
        _messageBubbleMargin = [NSMutableDictionary new];
        _messageBubblePadding = [NSMutableDictionary new];
        
        messageColorMe = bDefaultMessageColorMe;
        messageColorReply = bDefaultMessageColorReply;
        rootPath = @"default";
        appBadgeEnabled = YES;
        defaultUserNamePrefix = @"ChatSDK";
        showEmptyChats = YES;
        allowUsersToCreatePublicChats = NO;
        
        defaultAvatarURL = [@"http://flathash.com/%@.png" stringByAppendingFormat: @"%@", self.defaultUserName];
        
        facebookLoginEnabled = YES;
        twitterLoginEnabled = YES;
        googleLoginEnabled = YES;
        clientPushEnabled = NO;
        
        timeFormat = @"HH:mm";
        
        anonymousLoginEnabled = YES;
        defaultServer = bServerXMPP;
        
        shouldOpenChatWhenPushNotificationClicked = YES;
        onlySendPushToOfflineUsers = NO;
        
        includeMessagePayload = YES;
        includeMessageJSON = YES;
        includeMessageJSONV2 = YES;
        
        loginUsernamePlaceholder = Nil;
        
        pushNotificationSound = @"default";
        
        chatMessagesToLoad = 50;
        audioMessageMaxLengthSeconds = 300;
        
        firebaseShouldConfigureAutomatically = YES;
        
        locationMessagesEnabled = YES;
        imageMessagesEnabled = YES;
        termsAndConditionsEnabled = YES;
        
        showPublicThreadsUnreadMessageBadge = YES;
        
        prefersLargeTitles = YES;
        
        forgotPasswordEnabled = YES;
        
        databaseVersion = @"1";
        clearDatabaseWhenDataVersionChanges = NO;
        showUserAvatarsOn1to1Threads = YES;
        
        showLocalNotifications = YES;
        
        defaultBlankAvatar = [NSBundle imageNamed:bDefaultProfileImage bundle:bCoreBundleName];
        defaultGroupChatAvatar = [NSBundle imageNamed:bDefaultPublicGroupImage bundle:bCoreBundleName];
        
        rootPath = [BSettingsManager firebaseRootPath];
        
        twitterApiKey = [BSettingsManager twitterApiKey];
        twitterSecret = [BSettingsManager twitterSecret];
        
        facebookAppId = [BSettingsManager facebookAppId];
        
        googleClientKey = [BSettingsManager googleClientKey];
        
        anonymousLoginEnabled = [BSettingsManager anonymousLoginEnabled];
        
        userChatInfoEnabled = YES;
        
        inviteByEmailTitle = [BSettingsManager property: bEmailTitle forModule: @"contact_book"];
        inviteByEmailBody = [BSettingsManager property: bEmailBody forModule: @"contact_book"];
        inviteBySMSBody = [BSettingsManager property: bSMSBody forModule: @"contact_book"];
        
        shouldOpenChatWhenPushNotificationClickedOnlyIfTabBarVisible = NO;
        
        // Try to pre-configure XMPP from plist for backwards compatibility
        [self configureXMPPFromPlist];
        
        xmppMucMessageHistory = 20;
        
        messageDeletionListenerLimit = 30;
        messageHistoryDownloadLimit = 30;
        readReceiptMaxAgeInSeconds = 7 * bDays;
        
        textInputViewMaxCharacters = 0;
        textInputViewMaxLines = 5;
        
    }
    return self;
}

-(void) setDefaultUserNamePrefix:(NSString *)defaultUserNamePrefix {
     _defaultUserName = [defaultUserNamePrefix stringByAppendingFormat:@"%i", arc4random() % 999];
}

-(void) configureForCompatibilityWithVersions: (NSArray *) versions {
    BOOL api1 = [versions containsObject:bChatSDK_API_1];
    BOOL api2 = [versions containsObject:bChatSDK_API_2];
    BOOL api3 = [versions containsObject:bChatSDK_API_3];

    includeMessagePayload = api1;
    includeMessageJSON = api2;
    includeMessageJSONV2 = api3;
}

-(void) xmppWithHostAddress: (NSString *) hostAddress {
    [self xmppWithDomain:Nil hostAddress:hostAddress];
}

-(void) xmppWithDomain: (NSString *) domain hostAddress: (NSString *) hostAddress {
    [self xmppWithDomain:domain hostAddress:hostAddress port:0];
}

-(void) xmppWithDomain: (NSString *) domain hostAddress: (NSString *) hostAddress port: (int) port {
    [self xmppWithDomain:domain hostAddress:hostAddress port:port resource:Nil];
}

-(void) xmppWithDomain: (NSString *) domain hostAddress: (NSString *) hostAddress port: (int) port resource: (NSString *) resource {
    xmppDomain = domain;
    xmppHostAddress = hostAddress;
    xmppPort = port;
    xmppResource = resource;
}

-(void) configureXMPPFromPlist {
    xmppHostAddress = [BSettingsManager string_s:@[bXMPPKey, bXMPPHostAddressKey]];
    NSNumber * port = [BSettingsManager number_s:@[bXMPPKey, bXMPPPortKey]];
    xmppPort = port.intValue;
    xmppDomain = [BSettingsManager string_s:@[bXMPPKey, bXMPPDomainKey]];
    xmppResource = [BSettingsManager string_s:@[bXMPPKey, bXMPPResourceKey]];
}

+(BConfiguration *) configuration {
    return [[self alloc] init];
}

-(void) setMessageBubbleMargin: (UIEdgeInsets) margin forMessageType: (bMessageType) type {
    [_messageBubbleMargin setObject:[NSValue valueWithUIEdgeInsets:margin] forKey:@(type)];
}

-(void) setMessageBubblePadding: (UIEdgeInsets) padding forMessageType: (bMessageType) type {
    [_messageBubblePadding setObject:[NSValue valueWithUIEdgeInsets: padding] forKey:@(type)];
}

-(NSValue *) messageBubbleMarginForType: (bMessageType) type {
    return _messageBubbleMargin[@(type)];
}

-(NSValue *) messageBubblePaddingForType: (bMessageType) type {
    return _messageBubblePadding[@(type)];
}


@end
