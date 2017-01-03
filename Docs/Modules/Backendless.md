##Installation

+ Download and unzip the module
+ Add the folder `Backendless` to `ChatSDK/ChatSDKModules`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKModules/Backendless", :path => "../ChatSDKModules"
```
+ Run ```pod install```
+ Add your API details to the `info.plist`

```
chat_sdk/
    backendless/
       app_id
       app_secret
       app_version
```
These details are available on the Backendless dashboard. 

## Push notifications

In the `AppDelegate.m` add the following:

```
#import <ChatSDKModules/BBackendlessPushHandler.h>
``` 

Set the push handler in `app: didFinishLaunchingWithOptions:` method:

```ObjC
    adapter.push = [[BBackendlessPushHandler alloc] initWithAppKey:[BSettingsManager backendlessAppId] secretKey:[BSettingsManager backendlessSecretKey] versionKey:[BSettingsManager backendlessVersionKey]];

    [adapter.push  registerForPushNotificationsWithApplication:application launchOptions:launchOptions];

```
Make sure the following methods are added: 
```
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[BNetworkManager sharedManager].a.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[BNetworkManager sharedManager].a.push application:application didReceiveRemoteNotification:userInfo];
}
```

###For file upload
In the `AppDelegate.m` add the following:
```
#import <ChatSDKModules/BBackendlessUploadHandler.h>
```

Set the push handler in `app: didFinishLaunchingWithOptions:` method:

```ObjC
    adapter.upload = [[BBackendlessUploadHandler alloc] initWithAppKey:[BSettingsManager backendlessAppId] secretKey:[BSettingsManager backendlessSecretKey] versionKey:[BSettingsManager backendlessVersionKey]];
```

>**Note**
>You only to `initWithAppKey: secretKey: versionKey:` once. If you are using both the Backendless file upload handler and the push handler, the second time you can just alloc/init. This is because both handlers use the same Backendless singleton and the keys only need to be set once. 

```ObjC
	// If you have already setup the push handler previously
    adapter.upload = [[BBackendlessUploadHandler alloc] init];
```

 For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)