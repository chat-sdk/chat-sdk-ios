//
//  BFirebaseUploadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 10/06/2016.
//
//

#import "BFirebaseUploadHandler.h"
#import <ChatSDKFirebase/FirebaseUpload.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>

#define bStorageBucket @"files"

@implementation BFirebaseUploadHandler

-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType: (NSString *) mimeType {
    return [self uploadFile:file withName:name mimeType:mimeType message: nil];
}

-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType: (NSString *) mimeType message: (id<PMessage>) message {

    FIRStorage * storage = FirebaseUploadModule.shared.storage;
    FIRStorageReference * ref = [storage reference];
    FIRStorageReference * filesRef = [ref child:bStorageBucket];
    
    NSString * fullName = [NSString stringWithFormat:@"%@_%@", [BCoreUtilities getUUID], name];
    
    FIRStorageReference * fileRef = [filesRef child:fullName];

    RXPromise * promise = [RXPromise new];

    FIRStorageUploadTask * task = [fileRef putData:file metadata:Nil completion:^(FIRStorageMetadata * meta, NSError * error) {
        if (!error) {
            [fileRef downloadURLWithCompletion:^(NSURL * url, NSError * error) {
                if (!error) {
                    [promise resolveWithResult:@{bFileName: fullName, bFilePath: url}];
                }
                else {
                    [promise  rejectWithReason:error];
                }
            }];
        }
        else {
            [promise rejectWithReason:error];
        }
    }];
    
    [task observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot * snapshot){
        if (snapshot && snapshot.progress && message) {
            [BChatSDK.hook executeHookWithName:bHookMessageUploadProgress data:@{bHook_PMessage: message, bHook_ObjectValue: snapshot.progress}];
        }
    }];
    
    return promise;
}

@end
