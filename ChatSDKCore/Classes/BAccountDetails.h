//
//  BAccountDetails.h
//  AFNetworking
//
//  Created by Ben on 9/28/17.
//

#import <Foundation/Foundation.h>
#import "BAccountTypes.h"

@interface BAccountDetails : NSObject

@property (nonatomic, readwrite) bAccountType type;
@property (nonatomic, readwrite) NSString * username;
@property (nonatomic, readwrite) NSString * password;
@property (nonatomic, readwrite) NSString * token;
@property (nonatomic, readwrite) NSString * name;
@property (nonatomic, readwrite) NSMutableDictionary * meta;

+(instancetype) username: (NSString *) username password: (NSString *) password;
+(instancetype) signUp: (NSString *) username password: (NSString *) password;
+(instancetype) facebook;
+(instancetype) twitter;
+(instancetype) google;
+(instancetype) anonymous;
+(instancetype) token: (NSString *) token;

@end
