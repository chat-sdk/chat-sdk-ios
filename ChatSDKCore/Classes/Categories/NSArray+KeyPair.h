//
//  BSearchIndex.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 08/08/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSArray(KeyPair)

+(instancetype)  keyPair: (NSString *) name value: (NSString *) index;
+(instancetype)  keyPair:(NSString *)key value:(NSString *)value required: (BOOL) required;

-(NSString *) key;
-(NSString *) value;
-(BOOL) required;

@end
