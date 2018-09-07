//
//  NSMutableArray+User.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/08/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PUser;

@interface NSMutableArray<PUser>(User)

-(void) sortAlphabetical;
-(void) sortOnlineThenAlphabetical;

@end
