//
//  BInviteSyncItem.m
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BInviteSyncItem.h"

@implementation BInviteSyncItem

-(NSDictionary *) serialize {
    return @{@"title": self.title,
             @"userEntityID": self.userEntityID,
             @"message": self.message};
}

-(void) deserialize: (NSDictionary *) dict {
    self.title = dict[@"title"];
    self.userEntityID = dict[@"userEntityID"];
    self.message = dict[@"message"];
}

-(NSString *) path {
    return bInvitePath;
}


@end
