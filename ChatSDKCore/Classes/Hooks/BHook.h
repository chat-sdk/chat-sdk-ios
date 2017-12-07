//
//  BHook.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import <Foundation/Foundation.h>

@interface BHook : NSObject

+(instancetype) hook: (void(^)(NSDictionary *)) function;
-(instancetype) initWithFunction: (void(^)(NSDictionary *)) function;
-(void) execute: (NSDictionary *) properties;

@end
