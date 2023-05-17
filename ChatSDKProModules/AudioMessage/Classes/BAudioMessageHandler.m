//
//  BFirebaseVideoMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/11/2016.
//
//

#import "BAudioMessageHandler.h"

#import <ChatSDK/Core.h>
#import "BAudioMessageCell.h"

@implementation BAudioMessageHandler

-(RXPromise *) sendMessageWithAudio:(NSData *) data duration:(double) seconds withThreadEntityID:(NSString *)threadID {
    // Set the URLs for the images and save it in CoreData
//    [BChatSDK.db beginUndoGroup];
    
    id<PMessage> message = [[[[BMessageBuilder message] type: bMessageTypeAudio] thread:threadID] build];
    
    [BHookNotification notificationMessageWillUpload: message];
    
    return [self uploadAudioWithData:data message:message].thenOnMain(^id(NSDictionary * urls) {

        NSURL * audioURL = urls[bAudioPath];

        [message setMeta:@{bMessageAudioURL: audioURL.absoluteString,
                           bMessageAudioLength: @(seconds),
                           bMessageText: [NSBundle t:bAudioMessage],
                           bMessageSize: @(data.length),
        }];

        [BHookNotification notificationMessageDidUpload: message withData: data];

        return [BChatSDK.thread sendMessage:message];
    }, Nil);
}

- (RXPromise *)uploadAudioWithData: (NSData *) data message: (id<PMessage>) message {
    
    // Upload the images:
    return [BChatSDK.upload uploadFile:data withName:@"audio.mp4" mimeType:@"audio/mp4" message:message].thenOnMain(^id(NSDictionary * result) {
        
        NSMutableDictionary * urls = [NSMutableDictionary new];
        urls[bAudioPath] = result[bFilePath];
        
        return urls;
    }, Nil);
}

-(Class) cellClass {
    return [BAudioMessageCell class];
}

@end
