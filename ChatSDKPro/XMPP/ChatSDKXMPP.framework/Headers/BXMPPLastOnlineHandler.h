//
//  BXMPPLastOnlineHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 21/11/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PLastOnlineHandler.h>

@interface BXMPPLastOnlineHandler : NSObject<PLastOnlineHandler>{
    NSMutableDictionary * _userMap;
}

@property (nonatomic, readonly) NSMutableDictionary * userMap;

@end
