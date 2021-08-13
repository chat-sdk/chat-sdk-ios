//
//  BXMPPThreadHandler.h
//  AFNetworking
//
//  Created by ben3 on 11/07/2020.
//

#import <ChatSDK/BAbstractThreadHandler.h>

NS_ASSUME_NONNULL_BEGIN

@class BXMPPManager;

@interface BXMPPThreadHandler : BAbstractThreadHandler {
    BXMPPManager * _manager;
}

@end

NS_ASSUME_NONNULL_END
