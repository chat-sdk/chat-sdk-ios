//
//  BXMPPSearchHandler.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 29/07/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPModule.h"

@class XMPPIQ;
@class RXPromise;
@class XMPPStream;

@interface BXMPPSearchHelper : XMPPModule {
}

-(RXPromise *) searchForUsersWithDictionary: (NSDictionary *) dict;
-(RXPromise *) getAvailableSearchFields;

@end
