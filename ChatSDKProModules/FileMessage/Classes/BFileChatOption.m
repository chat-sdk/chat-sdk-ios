//
//  BFileChatOption.m
//  ChatSDKModules
//
//  Created by Pepe Becker on 19.04.18.
//

#import "BFileChatOption.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "FileMessage.h"
#import <MessageModules/MessageModules-Swift.h>
//#import "Headers.h"

@implementation BFileChatOption

-(UIImage *) icon {
    return [FileMessageModule imageWithNamed:@"icn_60_file.png"];
}

-(NSString *) title {
    return [NSBundle t:bFile];
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID handler: (id<PChatOptionsHandler>) handler {
    BSelectFileAction * action =  [[BSelectFileAction alloc] initWithViewController:viewController];
    return [action execute].thenOnMain(^id(id success) {
        if(BChatSDK.fileMessage) {
            NSDictionary * file = @{bFileName: action.name,
                                    bFilePath: action.url,
                                    bFileMimeType: action.mimeType,
                                    bFileData: action.data};

            return [BChatSDK.fileMessage sendMessageWithFile:file andThreadEntityID:threadEntityID];
        }
        return Nil;
    }, Nil);
}

@end
