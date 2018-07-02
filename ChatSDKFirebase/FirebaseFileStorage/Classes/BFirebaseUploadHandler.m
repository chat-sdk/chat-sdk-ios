//
//  BFirebaseUploadHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 10/06/2016.
//
//

#import "BFirebaseUploadHandler.h"
#import <ChatSDK/FirebaseFileStorage.h>

#define bStorageBucket @"files"

@implementation BFirebaseUploadHandler

-(RXPromise *) uploadFile:(NSData *)file withName: (NSString *) name mimeType: (NSString *) mimeType {
    FIRStorage * storage = [FIRStorage storage];
    FIRStorageReference * ref = [storage reference];
    FIRStorageReference * filesRef = [ref child:bStorageBucket];
    
    NSString * fullName = [NSString stringWithFormat:@"%@_%@", [BCoreUtilities getUUID], name];
    
    FIRStorageReference * fileRef = [filesRef child:fullName];

    RXPromise * promise = [RXPromise new];

    [fileRef putData:file metadata:Nil completion:^(FIRStorageMetadata * meta, NSError * error) {
        if (!error) {
            [fileRef downloadURLWithCompletion:^(NSURL * url, NSError * error) {
                if (!error) {
                    [promise resolveWithResult:@{bFileName: fullName, bFilePath: url.absoluteString}];
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
    //FIRStorageReference * ref = []
    
    return promise;
}


@end
