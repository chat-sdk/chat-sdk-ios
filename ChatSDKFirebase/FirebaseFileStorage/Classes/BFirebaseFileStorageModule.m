//
//  BFirebaseUploadModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//
//

#import "BFirebaseFileStorageModule.h"
#import <ChatSDKFirebase/FirebaseFileStorage.h>

@implementation BFirebaseFileStorageModule

-(void) activate {}
-(void) activateWithServer:(NSString *)server {
    if([server isEqualToString:bServerFirebase]) {
        BChatSDK.shared.networkAdapter.upload = [[BFirebaseUploadHandler alloc] init];
    }
    else if([server isEqualToString:bServerXMPP]) {
        if(BChatSDK.config.firebaseShouldConfigureAutomatically) {
            [FIRApp configure];
        }
        BChatSDK.shared.networkAdapter.upload = [[BFirebaseUploadHandler alloc] init];
    }
}

@end
