//
//  BHook.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/05/2017.
//
//

#import <Foundation/Foundation.h>

@interface BHook : NSObject

-(id) initWithFunction: (void(^)(NSDictionary *)) function;
-(void) execute: (NSDictionary *) properties;

@end
