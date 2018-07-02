//
//  BChatSDK.m
//  AFNetworking
//
//  Created by Ben on 11/7/17.
//

#import "BChatSDK.h"
#import "BConfiguration.h"
#import <ChatSDK/Core.h>

#define bRootPathKey @"chat_sdk_root_path"
#define bDatabaseVersionKey @"chat_sdk_database_version"

@implementation BChatSDK

@synthesize configuration = _configuration;

static BChatSDK * instance;

+(BChatSDK *) shared {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(instance == nil) {
            // Allocate and initialize an instance of this class
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions interfaceAdapter: (id<PInterfaceFacade>) adapter {
    [self shared]->_configuration = config;
    
    [BModuleHelper activateCoreModules];
    if(adapter) {
        [BInterfaceManager sharedManager].a = adapter;
    }
    [BModuleHelper activateModules];
    [self application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[self shared] clearDataIfNecessary];
    
    if (config.clearDataWhenRootPathChanges) {
    }
}

+(void) initialize: (BConfiguration *) config app:(UIApplication *)application options:(NSDictionary *)launchOptions {
    [self initialize:config app:application options:launchOptions interfaceAdapter:Nil];
}

+(void) activateModules {
    [BModuleHelper activateModules];
}

+(void) activateModulesForFirebase {
    [BModuleHelper activateModulesForFirebase];
}

+(void) activateModulesForXMPP {
    [BModuleHelper activateModulesForXMPP];
}

// If the configuration isn't set, return a default value
-(BConfiguration *) configuration {
    if(!_configuration) {
        _configuration = [BConfiguration configuration];
    }
    return _configuration;
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
+(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (NM.socialLogin) {
        return [NM.socialLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return NO;
}

+(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (NM.socialLogin) {
        return [NM.socialLogin application: app openURL: url options: options];
    }
    return NO;
}

+(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if(NM.push) {
        [NM.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    }
}

+(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(NM.push) {
        [NM.push application:application didReceiveRemoteNotification:userInfo];
    }
}

+(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    if(NM.push) {
        [NM.push registerForPushNotificationsWithApplication:application launchOptions:launchOptions];
    }
    if(NM.socialLogin) {
        [NM.socialLogin application:application didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

// Authenticate using a Firebase token
+(RXPromise *) authenticateWithToken: (NSString *) token {
    return [BIntegrationHelper authenticateWithToken:token];
}

// Update the username image and image url safely i.e. this method will wait until
// the user has been authenticated correctly by using the post auth hook
+(void) updateUserWithName: (NSString *) name image: (UIImage *) image url: (NSString *) url {
    [BIntegrationHelper updateUserWithName:name image:image url:url];
}

// Logout
+(RXPromise *) logout {
    return [BIntegrationHelper logout];
}

+(BConfiguration *) config {
    return [self shared].configuration;
}

-(void) clearDataIfNecessary {
    NSString * rootPath = [[NSUserDefaults standardUserDefaults] stringForKey:bRootPathKey];
    NSString * newRootPath = _configuration.rootPath;

    NSString * databaseVersion = [[NSUserDefaults standardUserDefaults] stringForKey:bDatabaseVersionKey];
    NSString * newDatabaseVersion = _configuration.databaseVersion;
    
    if ([BChatSDK config].clearDataWhenRootPathChanges && rootPath && newRootPath && ![rootPath isEqualToString:newRootPath]) {
        [[BStorageManager sharedManager].a deleteAllData];
        [[BStorageManager sharedManager].a saveToStore];
    }
    else if ([BChatSDK config].clearDatabaseWhenDataVersionChanges && ![databaseVersion isEqual:newDatabaseVersion]) {
        [[BStorageManager sharedManager].a deleteAllData];
        [[BStorageManager sharedManager].a saveToStore];
    }

    if (newRootPath) {
        [[NSUserDefaults standardUserDefaults] setObject:newRootPath forKey:bRootPathKey];
    }
    if (newDatabaseVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:newDatabaseVersion forKey:bDatabaseVersionKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
