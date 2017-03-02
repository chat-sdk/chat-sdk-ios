//
//  PEntity+Chatcat.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <RXPromise/RXPromise.h>
//#import "Firebase.h"
#import <Firebase/Firebase.h>

@interface BEntity : NSObject {
    
    NSString * _path;
    NSMutableDictionary * _pathIsOn;
    NSMutableDictionary * _state;
    
}

-(RXPromise *) pathOn: (NSString *) key callback: (void(^)(FIRDataSnapshot * snapshot)) callback ;
-(void) pathOff: (NSString *) key;

-(void) updateState: (NSString *) path id: (NSString *) id_ key: (NSString *) key completion: (void(^)(NSError * error)) completion;

@end
