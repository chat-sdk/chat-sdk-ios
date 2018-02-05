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
@synthesize defaultUserName;
@synthesize defaultUserNamePrefix;
@synthesize showEmptyChats;
@synthesize allowUsersToCreatePublicChats;
@synthesize googleLoginEnabled;
@synthesize twitterLoginEnabled;
@synthesize facebookLoginEnabled;
@synthesize anonymousLoginEnabled;
@synthesize defaultServer;
@synthesize shouldOpenChatWhenPushNotificationClicked;

-(instancetype) init {
    if((self = [super init])) {
        messageColorMe = bDefaultMessageColorMe;
        messageColorReply = bDefaultMessageColorReply;
        rootPath = @"default";
        appBadgeEnabled = YES;
        defaultUserNamePrefix = @"ChatSDK";
        defaultUserName = [defaultUserNamePrefix stringByAppendingFormat:@"%i", arc4random() % 999];
        showEmptyChats = NO;
        allowUsersToCreatePublicChats = NO;
        
        facebookLoginEnabled = YES;
        twitterLoginEnabled = YES;
        googleLoginEnabled = YES;
        
        anonymousLoginEnabled = YES;
        defaultServer = bServerXMPP;
        
        shouldOpenChatWhenPushNotificationClicked = YES;
        
    }
    return self;
}

+(BConfiguration *) configuration {
    return [[self alloc] init];
}

@end
