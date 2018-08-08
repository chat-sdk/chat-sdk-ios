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
@synthesize firebaseCloudMessagingServerKey;
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

@synthesize inviteByEmailTitle;
@synthesize inviteByEmailBody;
@synthesize inviteBySMSBody;
@synthesize audioMessageMaxLengthSeconds;

-(instancetype) init {
    if((self = [super init])) {
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
        clientPushEnabled = YES;
        
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
        
        prefersLargeTitles = YES;
        
        forgotPasswordEnabled = YES;
        
        databaseVersion = @"1";
        clearDatabaseWhenDataVersionChanges = NO;
        showUserAvatarsOn1to1Threads = YES;
        
        showLocalNotifications = YES;
        
        defaultBlankAvatar = [NSBundle imageNamed:bDefaultProfileImage bundle:bCoreBundleName];
        defaultGroupChatAvatar = [NSBundle imageNamed:bDefaultPublicGroupImage bundle:bCoreBundleName];
        
        firebaseCloudMessagingServerKey = [BSettingsManager firebaseCloudMessagingServerKey];
        rootPath = [BSettingsManager firebaseRootPath];
        
        twitterApiKey = [BSettingsManager twitterApiKey];
        twitterSecret = [BSettingsManager twitterSecret];
        
        facebookAppId = [BSettingsManager facebookAppId];
        
        googleClientKey = [BSettingsManager googleClientKey];
        
        anonymousLoginEnabled = [BSettingsManager anonymousLoginEnabled];
        
        userChatInfoEnabled = [BSettingsManager userChatInfoEnabled];
        
        inviteByEmailTitle = [BSettingsManager property: bEmailTitle forModule: @"contact_book"];
        inviteByEmailBody = [BSettingsManager property: bEmailBody forModule: @"contact_book"];
        inviteBySMSBody = [BSettingsManager property: bSMSBody forModule: @"contact_book"];;
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

+(BConfiguration *) configuration {
    return [[self alloc] init];
}

@end
