//
//  BSearchIndex.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 08/08/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSArray(KeyPair)

+(id) keyPair: (NSString *) name value: (NSString *) index;

-(NSString *) key;
-(NSString *) value;

@end
