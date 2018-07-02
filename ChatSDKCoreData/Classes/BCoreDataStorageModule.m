//
//  BCoreDataStorageModule.m
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import "BCoreDataStorageModule.h"
#import <ChatSDK/CoreData.h>

@implementation BCoreDataStorageModule

-(void) activate {
    [BStorageManager sharedManager].a = [[BCoreDataManager alloc] init];
}

@end
