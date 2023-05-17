//
//  BMessageBurstOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 16/06/2017.
//
//

#import "BMessageBurstChatOption.h"
#import <ChatSDK/UI.h>
#import <ChatSDK/Core.h>

@implementation BMessageBurstChatOption

-(UIImage *) icon {
    return [NSBundle imageNamed:@"icn_60_diagnostic.png" framework:@"ChatSDKModules" bundle:@"ChatDiagnostic"];
}

-(NSString *) title {
    return [NSBundle t:bMessageBurst];
}

-(RXPromise *) execute:(NSString *)threadEntityID {
    
    RXPromise * promise = [RXPromise new];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i = 0; i < 20; i++) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [BChatSDK.core sendMessageWithText:[NSString stringWithFormat:@"%i", i] withThreadEntityID:threadEntityID];
            });
            [NSThread sleepForTimeInterval:0.5f];
        }
        [promise resolveWithResult:Nil];
    });
    
    return promise;
}

@end
