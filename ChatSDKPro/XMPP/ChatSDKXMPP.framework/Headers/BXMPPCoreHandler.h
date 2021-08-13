//
//  BXMPPCoreHandler.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 21/11/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <ChatSDK/Core.h>
#import <ChatSDK/BAbstractCoreHandler.h>

@class BXMPPManager;

@interface BXMPPCoreHandler : BAbstractCoreHandler {
    BXMPPManager * _manager;
}

@end
