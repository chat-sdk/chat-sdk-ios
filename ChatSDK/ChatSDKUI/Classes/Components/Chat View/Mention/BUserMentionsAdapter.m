//
//  BUserMentionsAdapter.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 05/09/2017.
//
//

#import "BUserMentionsAdapter.h"

@implementation BUserMentionsAdapter

@synthesize user = _user;

- (id)initWithUser: (id<PUser>)user {

    self = [super init];
    if (self) {
        _user = user;
    }
    return self;
}

- (NSString *)entityId {
    return _user.entityID;
}

- (NSString *)entityName {
    return _user.name;
}

- (NSDictionary *)entityMetadata {
    return _user.metaDictionary;
}

- (id<PUser>)getUser {
    return _user;
}

@end
