//
//  BDelegateCallbackListener.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 18/02/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BDelegateCallbackListener : NSObject {
    RXPromise * _promise;
    SEL _success;
    SEL _error;
    id _identifier;
    NSTimer * _timer;
}

@property (nonatomic, readonly) SEL success;
@property (nonatomic, readonly) SEL error;
@property (nonatomic, readonly) id identifier;

@property (nonatomic, readonly) RXPromise * promise;
@property (nonatomic, readwrite, strong) void(^action)(void) ;

+(id) callbackWithSuccess: (SEL) success error: (SEL) error; 
+(id) callbackWithSuccess:(SEL)success error:(SEL)error action:(void (^)(void)) action;
+(id) callbackWithSuccess: (SEL) success error: (SEL) error identifier: (id) identifier;

-(void) resolveWithResult: (NSDictionary *) result;
-(void) rejectWithReason: (NSError *) error;

@end
