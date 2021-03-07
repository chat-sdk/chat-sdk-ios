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
+(instancetype) hookOnMain: (void(^)(NSDictionary *)) function;

+(instancetype) hook: (void(^)(NSDictionary *)) function weight: (int) weight;
+(instancetype) hookOnMain: (void(^)(NSDictionary *)) function weight: (int) weight;

-(void) execute: (NSDictionary *) properties;
-(int) weight;

@end
