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
    BChatSDK.shared.storageAdapter = [[BCoreDataStorageAdapter alloc] init];
}

@end
