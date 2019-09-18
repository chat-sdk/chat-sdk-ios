//
//  NSDictionary+Meta.h
//  AFNetworking
//
//  Created by Ben on 9/6/18.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Meta)

-(NSString *) metaStringForKey: (NSString *) key;
-(id) metaValueForKey: (NSString *) key;
-(NSDictionary *) setMetaDictValue: (id) value forKey: (NSString *) key;
-(NSDictionary *) updateMetaDict: (NSDictionary *) dict;

@end
