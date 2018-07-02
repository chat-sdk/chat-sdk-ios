//
//  BInviteSyncItem.m
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BInviteSyncItem.h"

#import <ChatSDK/FirebaseAdapter.h>

@implementation BInviteSyncItem

-(NSDictionary *) serialize {
    return @{@"title": self.title ? self.title : @"",
             @"userEntityID": self.userEntityID,
             @"message": self.message,
             @"date": [FIRServerValue timestamp],
             @"avatarURL": self.avatarURL ? self.avatarURL : @""};
}

-(void) deserialize: (NSDictionary *) dict {
    self.title = dict[@"title"];
    self.userEntityID = dict[@"userEntityID"];
    self.message = dict[@"message"];
    self.date = [BFirebaseCoreHandler timestampToDate:dict[@"date"]];
    self.avatarURL = dict[@"avatarURL"];
}

-(NSString *) path {
    return [BInviteSyncItem path];
}

+(NSString *) path {
    return bInvitePath;
}


@end
