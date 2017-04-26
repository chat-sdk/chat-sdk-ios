## Backendless Installation

+ Download and unzip the module
+ Drag the source code files into your project
+ Add the pod to the `Podfile`

```
pod "Backendless"
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

### Push notifications

Open the App delegate and add the following code:

**Objective C**

```
#import "BBackendlessPushHandler.h"
``` 

At the end of `didFinishLaunchingWithOptions` after all the Chat SDK setup code:
  
```
BBackendlessPushHandler * pushHandler = [[BBackendlessPushHandler alloc] initWithAppKey:[BSettingsManager backendlessAppId] secretKey:[BSettingsManager backendlessSecretKey] versionKey:[BSettingsManager backendlessVersionKey]];
[[BNetworkManager sharedManager].a setPush:pushHandler];
[[BNetworkManager sharedManager].a.push registerForPushNotificationsWithApplication:application launchOptions:launchOptions];
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

**Swift**

```
let pushHandler = BBackendlessPushHandler.init(appKey: BSettingsManager.backendlessAppId(), secretKey: BSettingsManager.backendlessSecretKey(), versionKey: BSettingsManager.backendlessVersionKey())
BNetworkManager.shared().a.setPush(pushHandler)
BNetworkManager.shared().a.push().registerForPushNotifications(with: application, launchOptions: launchOptions)
```
  
Make sure the following methods are added: 
  
```
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    if (BNetworkManager.shared().a.push() != nil) {
        BNetworkManager.shared().a.push().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}
    
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if (BNetworkManager.shared().a.push() != nil) {
        BNetworkManager.shared().a.push().application(application, didReceiveRemoteNotification: userInfo)
    }
}

```
  
Add this to the `ChatSDK-Bridging-Header.h`
  
```
#import "BBackendlessPushHandler.h"
```

For extra instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/).