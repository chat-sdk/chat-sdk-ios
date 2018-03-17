//
//  BConfiguration.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BConfiguration.h"
#import <ChatSDK/ChatCore.h>

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
        
        timeFormat = @"HH:mm";
        
        anonymousLoginEnabled = YES;
        defaultServer = bServerXMPP;
        
        shouldOpenChatWhenPushNotificationClicked = YES;
        
        includeMessagePayload = YES;
        includeMessageJSON = YES;
        includeMessageJSONV2 = YES;
        
        loginUsernamePlaceholder = Nil;
        
        pushNotificationSound = @"default";
        
        chatMessagesToLoad = 50;
        
        firebaseShouldConfigureAutomatically = YES;
        
        locationMessagesEnabled = YES;
        imageMessagesEnabled = YES;
        
        
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
