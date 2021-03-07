//
//  BSyncData.h
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RXPromise;

@interface BSyncItem : NSObject {
    NSString * _entityID;
}

@property (nonatomic, readonly) NSString * entityID;

+(instancetype) item;
+(instancetype) itemWithEntityID: (NSString *) entityID;

-(instancetype) initWithEntityID: (NSString *) entityID;
-(NSString *) path;
-(NSDictionary *) serialize;
-(void) deserialize: (NSDictionary *) dict;
-(RXPromise *) on;
-(void) off;
-(RXPromise *) push;
-(RXPromise *) delete;

@end
