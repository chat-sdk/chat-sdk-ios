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
+(NSString *) googleClientKey;

+(NSString *) twitterSecret;

+(NSString *) firebasePath;
+(NSString *) firebaseRootPath;
+(NSString *) firebaseStoragePath;

+(BOOL) anonymousLoginEnabled;

+(id) s: (NSArray *) parameters;
+(NSNumber *) number_s: (NSArray *) parameters;
+(NSString *) string_s: (NSArray *) parameters;

+(NSString *) property: (NSString *) property forModule: (NSString *) module;

@end
