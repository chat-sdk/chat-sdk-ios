//
//  BDelegateCallbackManager.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 18/02/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDelegateCallbackListener.h"

@class NSXMLElement;

@interface BDelegateCallbackManager: NSObject {
    NSMutableArray * _listeners;
    BOOL _debug;
}

+(BDelegateCallbackManager *) shared;

//-(RXPromise *) addListener: (BDelegateCallbackListener *) listener;
//-(RXPromise *) addAndStartListener: (BDelegateCallbackListener *) listener;
-(BDelegateCallbackListener *) addListenerWithSuccess: (SEL) success error: (SEL) error;
-(BDelegateCallbackListener *) addListenerWithSuccess: (SEL) success error: (SEL) error identifier: (id) identifier;

-(void) removeListener: (BDelegateCallbackListener *) listener;

-(void) resolveWithSelector: (SEL) selector result: (id) result;
-(void) resolveWithSelector: (SEL) selector result: (id) result identifier: (id) identifier;

-(void) rejectWithSelector: (SEL) selector error: (NSError *) error;
-(void) rejectWithSelector: (SEL) selector error: (NSError *) error identifier: (id) identifier;

-(void) rejectWithSelector: (SEL) selector xmppError: (NSXMLElement *) error;
-(void) rejectWithSelector: (SEL) selector xmppError: (NSXMLElement *) error identifier: (id) identifier;


@end
