//
//  BFirebaseUploadModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//
//

#import "BFirebaseFileStorageModule.h"
#import <ChatSDK/ChatCore.h>
#import "BFirebaseUploadHandler.h"

@implementation BFirebaseFileStorageModule

-(void) activate {
    [BNetworkManager sharedManager].a.upload = [[BFirebaseUploadHandler alloc] init];
}

@end
