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
#import <Firebase/Firebase.h>

@implementation BFirebaseFileStorageModule

-(void) activateForFirebase {
    [BNetworkManager sharedManager].a.upload = [[BFirebaseUploadHandler alloc] init];
}

-(void) activateForXMPP {
    [FIRApp configure];
    [BNetworkManager sharedManager].a.upload = [[BFirebaseUploadHandler alloc] init];
}

@end
