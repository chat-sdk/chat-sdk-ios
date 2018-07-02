//
//  BFirebaseUploadModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//
//

#import "BFirebaseFileStorageModule.h"
#import <ChatSDK/FirebaseFileStorage.h>

@implementation BFirebaseFileStorageModule

-(void) activate {}
-(void) activateWithServer:(NSString *)server {
    if([server isEqualToString:bServerFirebase]) {
        [BNetworkManager sharedManager].a.upload = [[BFirebaseUploadHandler alloc] init];
    }
    else if([server isEqualToString:bServerXMPP]) {
        [FIRApp configure];
        [BNetworkManager sharedManager].a.upload = [[BFirebaseUploadHandler alloc] init];
    }
}

@end
