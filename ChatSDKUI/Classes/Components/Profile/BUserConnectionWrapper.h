//
//  BUserConnectionWrapper.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 19/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PUserConnection.h>
#import <ChatSDK/BSubscriptionType.h>

@interface BUserConnectionWrapper : NSObject {
    id<PUserConnection> _connection;
}

+(BUserConnectionWrapper *) wrapperWithConnection: (id<PUserConnection>) connection;
-(id) initWithConnection: (id<PUserConnection>) connection;

-(NSString *) ask;
-(void) setAsk: (NSString *) ask;

@end
