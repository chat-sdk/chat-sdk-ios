//
//  BXMPPSearchHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PSearchHandler.h>

@class BXMPPManager;

@interface BXMPPSearchHandler : NSObject<PSearchHandler> {
    BXMPPManager * _manager;
}

@end
