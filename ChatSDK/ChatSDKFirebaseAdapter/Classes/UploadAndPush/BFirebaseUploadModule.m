//
//  BFirebaseUploadModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//
//

#import "BFirebaseUploadModule.h"
#import <ChatSDKCore/ChatCore.h>
#import "BFirebaseUploadHandler.h"

@implementation BFirebaseUploadModule

-(void) activate {
    [BNetworkManager sharedManager].a.upload = [[BFirebaseUploadHandler alloc] init];
}

@end
