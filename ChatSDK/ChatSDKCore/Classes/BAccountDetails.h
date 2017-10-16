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

+(id) username: (NSString *) username password: (NSString *) password;
+(id) signUp: (NSString *) username password: (NSString *) password;
+(id) facebook;
+(id) twitter;
+(id) google;
+(id) anonymous;
+(id) token: (NSString *) token;

@end
