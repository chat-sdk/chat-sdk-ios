//
//  BSettingsManager.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 30/03/2016.
//
//

#import "BSettingsManager.h"
#import <ChatSDK/Core.h>

#define bMainKey @"chat_sdk"

#define bAnonymousKey @"anonymous"
#define bFacebookKey @"facebook"
#define bFirebaseKey @"firebase"
#define bSettingsKey @"settings"
#define bTwitterKey @"twitter"
#define bGoogleKey @"google"
#define bModules @"modules"

#define bEnabledKey @"enabled"
#define bPathKey @"path"

#define bAppIDKey @"app_id"
#define bAppSecret @"app_secret"
#define bAppVersion @"app_version"
#define bRootPathKey @"root_path"
#define bClientKey @"client_key"
#define bTimeFormat @"time_format"
#define bApiKey @"api_key"
#define bSecretKey @"secret"
#define bFirebaseStorageBucket @"STORAGE_BUCKET"

@implementation BSettingsManager

+(NSDictionary *) settings {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:bMainKey];
}

+(id) s: (NSArray *) parameters {
    id obj = self.settings;
    for (NSString * p in parameters) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = obj[p];
        }
        else {
            return Nil;
        }
    }
    return obj;
}

+(NSNumber *) number_s: (NSArray *) parameters {
    id obj = [self s:parameters];
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    }
    else {
        return @0;
    }
}

+(NSString *) string_s: (NSArray *) parameters {
    id obj = [self s:parameters];
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    else {
        return Nil;
    }
}

+(NSString *) twitterApiKey {
    return [self string_s:@[bTwitterKey, bApiKey]];
}

+(NSString *) twitterSecret {
    return [self string_s:@[bTwitterKey, bSecretKey]];
}

+(NSString *) googleClientKey {
    return [self string_s:@[bGoogleKey, bClientKey]];
}

+(BOOL) anonymousLoginEnabled {
    return [[self number_s:@[bAnonymousKey, bEnabledKey]] boolValue];
}

+(NSString *) facebookAppId {
    return [self string_s:@[bFacebookKey, bAppIDKey]];
}

+(NSString *) firebasePath {
    return [self string_s:@[bFirebaseKey, bPathKey]];
}

+(NSString *) firebaseRootPath {
    return [self string_s:@[bFirebaseKey, bRootPathKey]];
}

+(NSString *) property: (NSString *) property forModule: (NSString *) module {
    NSDictionary * modules = self.settings[bModules];
    if(modules) {
        return modules[module][property];
    }
    return @"";
}


@end
