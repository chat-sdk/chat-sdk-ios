//
//  XMPPRoom+Additions.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 12/09/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPRoom.h"

@class RXPromise;

#define bXMPPRoomNameKey @"name"
#define bXMPPRoomDescriptionKey @"description"

@interface XMPPRoom(Additions)

-(RXPromise *) getRoomUserList;
-(RXPromise *) getRoomInfo;

@end
