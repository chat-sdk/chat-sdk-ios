//
//  BSearchHandlerDelegate.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 02/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

@class XMPPIQ;
@class XMPPStream;

@protocol BSearchHandlerDelegate <NSObject>

-(void) didReceiveIQ: (XMPPIQ *) iq;
-(XMPPStream *) stream;

@end
