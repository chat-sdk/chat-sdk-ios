//
//  BEjabberdFileStorageModule.m
//  AFNetworking
//
//  Created by ben3 on 04/05/2019.
//

#import "BEjabberdFileStorageModule.h"
#import "BEjabberdFileStorageHandler.h"
#import <ChatSDK/Core.h>

@implementation BEjabberdFileStorageModule

-(void) activate {
    BChatSDK.shared.networkAdapter.upload = [BEjabberdFileStorageHandler new];
}


@end
