# Chat SDK for iOS

<img target="_blank" src="http://img.chatcatapp.com/chat-sdk-hand.jpg" />

Chat SDK is a fully featured open source instant messaging framework for iOS. Chat SDK is fully featured, scalable and flexible and follows the following key principles:

- **Open Source.** The Chat SDK is open source under the MIT license.
- **Full data control.** You have full and exclusive access to the user's chat data
- **Quick integration.** Chat SDK is fully featured out of the box

A demo of the project is available on the App Store.  

<a target="_blank" href="https://itunes.apple.com/us/app/chatcat/id962537653?mt=8"><img src="http://www.binpress.com/uploads/store33364/itunes-app-store-logo.png" width="290" height="100" alt="App Store" /></a>

### Features

- Private and group messages
- Public chat rooms
- Username / password, Facebook, Twitter, Anonymous and custom login
- Push notifications
- Text, Image and Location messages
- User profiles
- User search

<img src="http://img.chatcatapp.com/chat-sdk-3.jpg" />

Full breakdown is available on the [features page](http://chatsdk.co/features/).

### Additional Features

In order to fund the development of the Chat SDK we also offer premium add-ons for the Chat SDK:

- Typing indicator
- Read Receipts
- Audio / Video Messages
- Contact book integration
- Location based user search
- Stickers
- Two Factor Authentication

These modules can be purchased on <a href="http://chatsdk.co/pricing/" target="_blank">our store</a>.

## Running the demo project
This repository contains a fully functional verion of the Chat SDK which is configured using our Firebase account and social media logins. This is great way to test the features of the Chat SDK before you start itegrating it with your app. 

1. Clone Chat SDK  
2. Run ```pod install``` in the ChatSDK directory  
3. Open the ```Chat SDK Firebase.xcworkspace``` file in Xcode  
4. Compile and run   

## Integration with an existing project
It's easy to integrate the Chat SDK with an existing project. 

1. Clone Chat SDK  
2. Add the Chat SDK development pods to your Podfile  

```
  pod "ChatSDK", :path => "[Path to ChatSDK folder]"
```

> **Note**  
> Chat SDK supports push notifications but this requires the installation of an additional free module. This guide includes the additional steps necessary to setup push notifications. These steps will be marked with a comment. 

For push notifications you should download the free [BackendlessPushHandler](http://chatsdk.co/downloads/backendless-push-notifications/) module. 

```
  pod "ChatSDKModules/Backendless", :path => "[Path to ChatSDKModules folder]"
```

3. Run ```Pod install```  
4. Copy the **BTwitterHelper** and **GooglerService-Info.plist** files into your main project target folder  
5. Copy the following rows from the ChatSDK **Info.plist** file to your project's Info.plist  
  1. chat_sdk
  2. App Transport Security Settings
  3. Privacy rows appropriate for your project (location, photo library, microphone, camera etc)
6. Open the **AppDelegate.m** add the following code to initialise the chat

```objc
#import "BTwitterHelper.h"
#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>
#import <ChatSDK/ChatFirebaseAdapter.h>
#import <ChatSDK/ChatCoreData.h>
```

For push notifications:

```objc
#import <ChatSDKModules/BBackendlessPushHandler.h>
```

Add the following code to the start of your didFinishLaunchingWithOptions function:

```objc
// Configure app for Facebook login
[FIRApp configure];
[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

// Start the twitter helper to handle login
[BTwitterHelper sharedHelper];

// Set the default interface manager
[BInterfaceManager sharedManager].a = [[BDefaultInterfaceAdapter alloc] init];
    
// This is the main view that contains the tab bar
_mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];

// Create a network adapter to communicate with Firebase
// The network adapter handles network traffic
BFirebaseNetworkAdapter * adapter = [[BFirebaseNetworkAdapter alloc] init];

// Set the login screen
// This screen is customizable - for example if you are using the
// Two factor authentication module
adapter.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];

// Set the adapter
[BNetworkManager sharedManager].a = adapter;
    
// Set the data handler
// The data handler is responsible for persisting data on the device
[BStorageManager sharedManager].a = [[BCoreDataManager alloc] init];

// Set the root view controller
[self.window setRootViewController:_mainViewController];
```

For push notifications also add:

```objc
adapter.push = [[BBackendlessPushHandler alloc] initWithAppKey:[BSettingsManager backendlessAppId] secretKey:[BSettingsManager backendlessSecretKey] versionKey:[BSettingsManager backendlessVersionKey]];
    
[[BNetworkManager sharedManager].a.push  registerForPushNotificationsWithApplication:application launchOptions:launchOptions];
```

Finally Make sure the following functions are either copied into your AppDelegate.m file or the code is added to your existing functions:

```objc
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:[NSString stringWithFormat:@"fb%@",     [BSettingsManager facebookAppId]]]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else {
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
}
```

For push notifications also add:

```objc
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[BNetworkManager sharedManager].a.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[BNetworkManager sharedManager].a.push application:application didReceiveRemoteNotification:userInfo];
}

```

## Firebase Setup

The ChatSDK relies on a number of different backends for its functionality.

**Firebase.** Firebase is a real-time data and storage service provided by Google. Firebase is free up to around 20k daily active users. 

**Backendless:** Backendless is a mobile app development platform with server functionality. Backendless provide free targeted push notifications.

1. Create a Firebase account
  1. Create a Firebase account [here](https://console.firebase.google.com/)
  2. Create a new project 
  
2. Adding Firebase details to your project Info.plist
  1. Open your new project and click database in the left menu
  2. Copy the URL at the top of your browser e.g. https://appname.firebaseio.com/
  3. Modify the URL into the following format: gs://appname.appspot.com
  4. Copy the modified URL into your plist field: **chat_sdk** -> **firebase** -> **storage_path**
  5. Enter a custom root_path. 
  
>**Note:**  
>The root path is the initial path which your ChatSDK data will be stored on Firebase. It allows you to use a single Firebase database for multiple versions of your project. For example you could create a ```/live``` path and a ```/testing``` path. This allows you to test new features without fear of corrupting your current data model.

3. Configure your Firebase iOS App 
  1. In your Firebase project, click the cog at the top of the page
  2. Select Project settings
  3. Click to add an iOS App
  4. Enter your BundleID
  5. Click through the remaining steps (all this code has already been added)
  6. Copy the GoogleService-Info.plist into your main project folder (replace the previous one copied from ChatSDK)

>**Note:**  
>It is worth opening your downloaded ```GoogleService-Info.plist``` and checking there is an ```API_KEY``` field included. Sometimes Firebase's automatic download doesn’t include this in the plist. To rectify, just re-download the plist from the project settings menu.

## Backendless Set up for push notifications

Configuring your project with Backendless is very simple due to the large amount of documentation Backendless provide. 

To get started with Backendless you need to complete the following steps:

1. Create an account on [Backendless](https://backendless.com/)
2. Create a new app on the dashboard
3. Navigate to your app settings (Manage -> App Settings) and copy the following keys into your plist
  1. The AppID (**chat_sdk** -> **backendless** -> **app_id**) 
  2. The iOS Secret Key (**chat_sdk** -> **backendless** -> **app_secret**) 
  3. The App Version Key (**chat_sdk** -> **backendless** -> **app_secret**) 

You have now added the custom keys to your project. Next, you need to configure the certificates to enable push notifications. 

Backendless provide extremely detailed documentation for this and we recommend you to work through this to set up Push Notifications correctly. You can find the iOS Push Notification guide [here](https://backendless.com/ios-push-notifications-with-backendless/).

>**Note:**  
>There have been some instances of the push notifications not being sent and received until the app has been uploaded to iTunes Connect. We recommend carefully configuring Push Notifications before uploading your app and testing it with TestFlight before final release.

Your project is now set up with the ChatSDK. 

>**Note:**  
>Don’t forget that it is still using many of our test accounts for social media.

You find complete documentation to set these up here.


