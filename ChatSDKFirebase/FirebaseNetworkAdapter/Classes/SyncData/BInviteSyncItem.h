//
//  BInviteSyncItem.h
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BSyncItem.h"

#define bInvitePath @"invites"

@interface BInviteSyncItem : BSyncItem

@property (nonatomic, readwrite) NSString * title;
@property (nonatomic, readwrite) NSString * userEntityID;
@property (nonatomic, readwrite) NSString * message;
@property (nonatomic, readwrite) NSDate * date;
@property (nonatomic, readwrite) NSString * avatarURL;

+(NSString *) path;

@end
