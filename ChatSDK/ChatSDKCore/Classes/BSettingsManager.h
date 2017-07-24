//
//  BSettingsManager.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/03/2016.
//
//

#import <Foundation/Foundation.h>

@interface BSettingsManager : NSObject

+(NSString *) twitterApiKey;
+(NSString *) facebookAppId;
+(NSString *) googleApiKey;
+(NSString *) googleClientKey;

+(NSString *) twitterSecret;

+(NSString *) firebasePath;
+(NSString *) firebaseRootPath;
+(NSString *) firebaseStoragePath;

+(NSString *) parseAppId;
+(NSString *) parseClientKey;
+(BOOL) anonymousLoginEnabled;

+(BOOL) appBadgeEnabled;
+(BOOL) userChatInfoEnabled;

+(NSString *) backendlessAppId;
+(NSString *) backendlessSecretKey;
+(NSString *) backendlessVersionKey;
+(NSString *) timeFormat;

+(id) s: (NSArray *) parameters;
+(NSNumber *) number_s: (NSArray *) parameters;
+(NSString *) string_s: (NSArray *) parameters;

@end
