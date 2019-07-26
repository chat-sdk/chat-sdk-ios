# Chat SDK
### Open Source Messaging framework for iOS

<img target="_blank" src="http://img.chatcatapp.com/chat-sdk-hand.jpg" />

Chat SDK is a fully featured open source instant messaging framework for iOS. Chat SDK is fully featured, scalable and flexible and follows the following key principles:

- **Open Source.** The Chat SDK is open source and free for commerical apps ([see license](https://github.com/chat-sdk/chat-sdk-ios#the-license))
- **Full data control.** You have full and exclusive access to the user's chat data
- **Quick integration.** Chat SDK is fully featured out of the box
- **Firebase** Powered by [Google Firebase](https://firebase.google.com/)

<!--A demo of the project is available on the App Store.  

<a target="_blank" href="https://itunes.apple.com/us/app/chatcat/id962537653?mt=8"><img src="http://www.binpress.com/uploads/store33364/itunes-app-store-logo.png" width="290" height="100" alt="App Store" /></a>
-->
## Features

- Private and group messages
- Public chat rooms
- Username / password, Facebook, Twitter, Anonymous and custom login
- [Phone number authentication](https://github.com/chat-sdk/chat-sdk-ios#firebase-ui)
- Free Push notifications (using [FCM](https://firebase.google.com/docs/cloud-messaging/))
- Text, Image and Location messages
- User profiles
- User search
- [Scalable](https://firebase.google.com/docs/database/usage/limits) - Supports over 400k monthly users
- Powered by [Google Firebase](https://firebase.google.com/) or [XMPP](https://chatsdk.co/xmpp-2/)
- [Firebase UI](https://github.com/chat-sdk/chat-sdk-ios#firebase-ui) support
- [Native Android Version](https://github.com/chat-sdk/chat-sdk-android)
- [Native Web Version](https://github.com/chat-sdk/chat-sdk-web)
- [Powerful flexible API](https://github.com/chat-sdk/docs)

<img src="http://img.chatcatapp.com/chat-sdk-3.jpg" />

Full breakdown is available on the [features page](http://chatsdk.co/features/).

## Quick Start

- [Standard Documentation](https://github.com/chat-sdk/chat-sdk-ios#adding-the-chat-sdk-to-your-project) (For experienced developers) 
- [API Documentation](https://github.com/chat-sdk/docs)
- [Code Examples](https://github.com/chat-sdk/chat-sdk-ios/blob/master/Xcode/ChatSDK%20Demo/ApiExamples.m)
- [Wiki](https://github.com/chat-sdk/chat-sdk-ios/wiki)

## Demo

You can test the XMPP Chat SDK on the [App Store](https://itunes.apple.com/us/app/xmpp-messenger/id1218669006?ls=1&mt=8)

## Performance and Scalability

These are the average Firebase hosting costs calculated using the Firebase Database Profiling tool. Firebase charge 1 USD per GB of data downloaded (excluding images or files). We've tabulated a few common operations and how many of them can be performed per 1 USD of monthly hosting cost:

- Messages Received (1kb) = 1,000,000
- Logins (10kb) = 100,000
- Profile Update (0.2kb) = 5,000,000
- User search (2kb) = 500,000 

What's possible on the Firebase free plan (10GB / month):

**500k logins, 5 million messages.** 

What's possible on the Flame plan (20GB / month / 20 USD):

**1 million logins, 10 million messages.**

The real-time database will support up to **100k concurrent users**. From our experience, 1 concurrent connection is enough to support 10 users per minute. That means that at peak capacity, the Chat SDK could support **1 million users per minute** and well over **20 million monthly users**. 

## Modules
- [End-To-End Encryption](https://chatsdk.co/end-to-end-encryption/)
- [File Messages](http://chatsdk.co/file-messages/)
- [Typing indicator](http://chatsdk.co/typing-indicator/)
- [Read receipts](http://chatsdk.co/read-receipts/)
- [Location based chat](http://chatsdk.co/location-based-chat/)
- [Last Online Indicator](https://chatsdk.co/firebase-last-online-indicator/)
- [Audio messages](http://chatsdk.co/audio-messages/)
- [Video messages](http://chatsdk.co/video-messages/)
- [Sticker messages](https://chatsdk.co/sticker-messages/)
- [Contact book integration](https://chatsdk.co/contact-book-integration/)
- [User Blocking](http://chatsdk.co/user-blocking/)
- [Keyboard overlay](http://chatsdk.co/downloads/keyboard-overlay/)
- [Social Login (free)](https://github.com/chat-sdk/chat-sdk-ios#social-login)
- [Push Notifications (free)](https://github.com/chat-sdk/chat-sdk-ios#push-notifications)
- [File Storage (free)](https://github.com/chat-sdk/chat-sdk-ios#file-storage)
- [Firebase UI (free)](https://github.com/chat-sdk/chat-sdk-ios#firebase-ui)

## Firebase Firestore

If you are interested in a version of the Chat SDK that supports Firebase's new database please vote on [this issue](https://github.com/chat-sdk/chat-sdk-android/issues/148) and help us meet our target on [Patreon](https://www.patreon.com/chatsdk).

## Support the project

We would love to work full time developing the open source. At the moment we have to spend a substantial amount of time doing other consulting work to cover our costs. If you like what we're doing and would like to support us to focus more of our time on the open source project we would be very grateful. 

+ Support us directly on [Patreon](https://www.patreon.com/chatsdk) 🙏
+ Giving us a Github star ⭐
+ Upvoting our page on [Product Hunt](https://www.producthunt.com/posts/chat-sdk)
+ Tweet about the project using [@chat_sdk](https://mobile.twitter.com/chat_sdk)

## Get involved!

We're very excited about the project and we're looking for other people to get involved. Over time we would like to make the best messaging framework for mobile. Helping us could involve any of the following:

+ Providing feedback and feature requests
+ Reporting bugs
+ Fixing bugs
+ Writing documentation
+ Improving the user interface
+ Help us update the library to use Swift
+ Helping to write adapters for other services such as Layer, Pusher, Pubnub etc... 
+ Write a tutorial - **we pay $100** for quality tutorials

If you're interested please review the [Contributing
Document](https://github.com/chat-sdk/chat-sdk-ios/blob/master/CONTRIBUTING.md) for details of our development flow and the CLA then email me at [**team@sdk.chat**](mailto:team@sdk.chat).

## Apps that use Chat SDK

Here are the apps we know about that are using Chat SDK. If you've relased an app that uses the framework let us know and we'll add it to the list:

+ [Parlor](http://parlor.me/)
+ [Runbuddy](https://itunes.apple.com/us/app/run-buddy/id1050833009?mt=8)
+ [INDX01](https://itunes.apple.com/us/app/keynote/id1265222713?mt=8)

## Setup Service and consulting

##### Setup Service

We provide extensive documentation on Github but if you’re a non-technical user or want to save yourself some work you can take advantage of our [setup and integration service](http://chatsdk.co/downloads/chat-sdk-setup-service/).

##### Consulting services

We are specialists in real-time application development including: Firebase, Firestore, XMPP and WebRTC for iOS and Android. If you need help integrating the Chat SDK with your app or another app development project email us at [team@sdk.chat](mailto: team@sdk.chat). 



## Updating from 4.10.x to 4.11.x

The latest update brings a range of improvements and new features including:

- Detailed profile screen:
	- User status
	- User availability
	- Country
- Update to message view
	- Vastly improved lazy loading
	- Efficiency improvements
- Contacts
	- Add / remove contact from contact screen 

There are also a range of bug fixes and overall improvments. If we aren't able to document all the changes but if you have any issues updating your project, you can post on this [issue](https://github.com/chat-sdk/chat-sdk-ios/issues/360) and we will answer your questions. 

The [security rules](firebase-rules.json) have also been updated so make sure to bring your project up to date. 	

**Update the CoreData model**

Make sure that the CoreData model is the latest version. This model lives in `ChatSDK/CoreData/Resources/ChatSDK.xcdatamodelId`
	
Several schema have also been deprecated and will be removed at some point in the future. These include:

- `message/to` field added
- `message/meta` will replace `json_v2`
- `message/from` will replace `user-firebase-id`
- `thread/meta` will replace `details`
- `thread/meta/creator` will replace `creator-entity-id`
- `thread/meta/type` will replace `type_v4`

At the moment these fields are not being used and are only included for future compatibility. However, in a future version of the client, the old fields will be removed and any old versions of the client will stop working.

## Running the demo project
This repository contains a fully functional version of the Chat SDK which is configured using our Firebase account and social media logins. This is great way to test the features of the Chat SDK before you start itegrating it with your app. 

1. Clone Chat SDK  
2. Run `pod install` in the **Xcode** directory  
3. Open the `Chat SDK Firebase.xcworkspace` file in Xcode  
4. Compile and run

## Swift Version
The Chat SDK is fully compatible with Swift projects and contains a Swift demo project. 

1. Clone Chat SDK  
2. Run `pod install` in the **XcodeSwift** directory  
3. Open the `ChatSDKSwift.xcworkspace` file in Xcode  
4. Compile and run 

## Adding the Chat SDK to your project
###### Quick start guide - it takes about 10 minutes!

### Adding the Chat SDK to your project

1. Add the Chat SDK development pods to your Podfile

  ```
  use_frameworks!
  pod "ChatSDK"
  pod "ChatSDKFirebase/Adapter"
  pod "ChatSDKFirebase/FileStorage"
  pod "ChatSDKFirebase/Push"
  
  // Optional - for social login (see setup guide below)
  
  pod "ChatSDKFirebase/SocialLogin"
  ```
  
2. Run `pod update` to get the latest version of the code.

3. Open the **App Delegate** add the following code to initialise the chat

  **Objective C**

  _AppDelegate.m -> application: didFinishLaunchingWithOptions:_
  
  ```
  #import <ChatSDK/UI.h>
  ```

  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  BConfiguration * config = [BConfiguration configuration];
  config.rootPath = @"test";
  // Configure other options here...
  
  [BChatSDK initialize:config app:application options:launchOptions];

  // Set the root view controller
  [self.window setRootViewController:BChatSDK.ui.splashScreenNavigationController];
  ```
  
  Then add the following methods:
  
  ```
  - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
      return [BChatSDK application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
  }
	
  -(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
      return [BChatSDK application: app openURL: url options: options];
  }
	
  -(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
      [BChatSDK application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  }
	
  -(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
      [BChatSDK application:application didReceiveRemoteNotification:userInfo];
  }
  ```
  
  **Swift**
  
  _AppDelegate.swift_
  
  ```
  import ChatSDK
  ```
  
  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  let config = BConfiguration.init();
  config.rootPath = "test"
  // Configure other options here...
  
  config.allowUsersToCreatePublicChats = true
  BChatSDK.initialize(config, app: application, options: launchOptions)
        
  self.window = UIWindow.init(frame: UIScreen.main.bounds)
  self.window?.rootViewController = BChatSDK.ui()?.splashScreenNavigationController()
  self.window?.makeKeyAndVisible();
  ```
  
  Then add the following methods:
  
  ```
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BChatSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BChatSDK.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        BChatSDK.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return BChatSDK.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    }
  ```
  
  ##### The Root Path

  >The root path variable allows you to run multiple Chat SDK instances on one Firebase account. Each different root path will represent a completely separate set of Firebase data. This can be useful for testing because you could have separate **test** and **prod** root paths.
      
4. The Chat SDK is now added to your project

## Firebase Setup

1. Go to the [Firebase](http://firebase.com/) website and sign up
2. Go to the [Firebase console](https://console.firebase.google.com/) and make a new project
3. Click **Add project**
4. Choose a name and a location
5. Click **Settings** (the gear icon). On the General tab, click **Add Firebase to your iOS app**
6. Enter your bundle ID
7. Download the **GoogleServices** file and add it to the root of your Xcode project

  >**Note:**  
  >It is worth opening your downloaded ```GoogleService-Info.plist``` and checking there is an ```API_KEY``` field included. Sometimes Firebase's automatic download doesn’t include this in the plist. To rectify, just re-download the plist from the project settings menu.  
   
10. Copy the following rows from the demo ChatSDK **Info.plist** file to your project's **Info.plist**  
  1. `App Transport Security Settings`
  2. `URL types`
  3. `FacebookAppID` (If you want Facebook login)
  4. Make sure that the URL types are all set correctly. The URL type for your app should be set to your bundle `id`
  5. All the privacy rows. These will allow the app to access the camera, location and address book

11. In the Firebase dashboard click **Authentication -> Sign-in method** and enable all the appropriate methods 
12. Add the [security rules](https://github.com/chat-sdk/chat-sdk-ios#security-rules). The rules also enable optimized user search so this step is very important!
13. Enable file storage - Click **Storage -> Get Started** 
14. Enable [push notifications](https://github.com/chat-sdk/chat-sdk-ios#push-notifications)
15. Enable location messages. Get a [Google Maps API](https://developers.google.com/maps/documentation/ios-sdk/get-api-key) key. Then add it during the Chat SDK configuration

  **Objective C**
  
  ```
  config.googleMapsApiKey = @"YOUR API KEY";
  ```
  
  **Swift**
  
  ```
  config.googleMapsApiKey = "YOUR API KEY"
  ```
  
### Push Notifications

The Push Notification module allows you to send free push notifications using Firebase Cloud Messaging.

1. Setup an [APN key](https://firebase.google.com/docs/cloud-messaging/ios/certs). 
2. Inside your project in the Firebase console, select the gear icon, select Project Settings, and then select the Cloud Messaging tab.
3. In APNs authentication key under iOS app configuration, click the Upload button.
4. Browse to the location where you saved your key, select it, and click Open. Add the key ID for the key (available in Certificates, Identifiers & Profiles in the Apple Developer Member Center) and click Upload.
5. Enable the push notifications Capability in your Xcode project **Project -> Capabilities -> Push Notifications**
6. In Xcode open the **Capabilities** tab. Enable **Push Notifications** and the following **Background Modes**: Location updates, Background fetch, Remote notifications. 

##### Setup Firebase Cloud Functions

Follow the instructions on our [Chat SDK Firebase repository](https://github.com/chat-sdk/chat-sdk-firebase)

### Security Rules

Firebase secures your data by allowing you to write rules to govern who can access the database and what can be written. The rules are also needed to enable user search. To enable the rules see the guide [Enabling Security Rules](https://github.com/chat-sdk/chat-sdk-firebase).

### Conclusion

Congratulations! 🎉🎉 You've just turned your app into a fully featured instant messenger! Keep reading below to learn how to further customize the Chat SDK.

##### To go deeper, checkout the API Guide for help with:

1. Interacting with the Firebase server
2. Creating and updating entities
3. Custom authentication
4. Common code examples
5. Customizing the user interface

View the [API documentation here](https://github.com/chat-sdk/docs#custom-authentication).

# Next Steps

### Configuration

There are a number of configuration options available. Check out the [BConfiguration](https://github.com/chat-sdk/chat-sdk-ios/blob/master/ChatSDKCore/Classes/Session/BConfiguration.h) class. Using this class you can do things like:

- Changing the chat bubble colors
- Changing the default user name
- Enable or disable different types of login
- Show or hide empty chats
- etc...

### Customize the UI

To customize the UI, you can register subclasses for different views. You can do that using the UI service `BChatSDK.ui`. For example, to register a new login view controller you would use:

```
BChatSDK.ui.loginViewController = [[YourViewController alloc] initWithNibName:Nil bundle: Nil];
```

To modify the chat view you would register a provider:

```
[BChatSDK.ui setChatViewController:^BChatViewController *(id<PThread> thread) {
        return [[YourChatViewController alloc] initWithThread:thread];
}];
```

Every view controller in the app can be customized this way. 

### Use Chat SDK views in your app

Any of the Chat SDK views can be added into your app. Checkout the [PInterfaceFacade](https://github.com/chat-sdk/chat-sdk-ios/blob/master/ChatSDKCore/Classes/UI/PInterfaceFacade.h) for options. You can add a any view using the following pattern. Here we are using the interface service to get the particular view. 

*Objective-C*

```
UIViewController * privateThreadsViewController = [BChatSDK.ui privateThreadsViewController];
```

*Swift*

```
let privateThreadsViewController = BChatSDK.ui().a.privateThreadsViewController()
```

### Integrate the Chat SDK with your existing app

To do that, you can take advantage of the `BIntegrationHelper` class. This makes provides some helper methods to make it easier to integrate the Chat SDK with your app. 

At the most basic level, you need to do the following:

1. Authenticate the Chat SDK when your app authenticates. The best way to do this is to generate a custom token on your server following [this guide](https://github.com/chat-sdk/docs#custom-authentication). Then use this method to initialize the Chat SDK:

  *Objective-C*

  ```
  [BIntegrationHelper authenticateWithToken:@"your token"];
  ```

  *Swift*

  ```
  BIntegrationHelper.authenticate(withToken: "your token")
  ```

2. Update the Chat SDK user's name and image whenever your user's name or image changes. You can do this using the following method:

  *Objective-C*

  ```
  [BIntegrationHelper updateUserWithName:@"Name" image: image url: imageURL];
  ```

  *Swift*

  ```
  BIntegrationHelper.updateUser(withName: "Name", image: image, url: imageURL)
  ```

3. Logout of the Chat SDK whenever your app logs out. A good place to do this is whenever your login screen is displayed:

  *Objective-C*

  ```
  [BIntegrationHelper logout];
  ```

  *Swift*

  ```
  BIntegrationHelper.logout()
  ```
  
4. Now the Chat SDK is integrated with your app. 
  
## Module Setup

There are a number of free and premium extensions that can be added to the Chat SDK. 

### Firebase Modules

For the following modules:

- [Firebase Social Login](https://github.com/chat-sdk/chat-sdk-ios#social-login) (free)
- [Firebase UI](https://github.com/chat-sdk/chat-sdk-ios#firebase-ui) (free)
- [User Blocking](https://chatsdk.co/downloads/user-blocking-for-ios/)
- [Typing indicator](http://chatsdk.co/downloads/typing-indicator/)
- [Read receipts](http://chatsdk.co/downloads/read-receipts/)
- [Location based chat](http://chatsdk.co/downloads/location-based-chat/)
- [Audio messages](http://chatsdk.co/downloads/audio-messages/)
- [Video messages](http://chatsdk.co/downloads/video-messages/)
- [Contact book integration](http://chatsdk.co/downloads/contact-book-integration/)

The free modules are located in the [chat-sdk-ios/ChatSDKFirebase](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase) folder. The premium modules can be purchased and downloaded from the links provided above. 

To install a module you should use the following steps:

1. Copy the module code into your Xcode source code folder and add the files to your project from inside Xcode. If you are using a symlink you can use the symlink script (mentioned above) and then just add a link to the **ChatSDKFirebase** folder to Xcode.
2. Add any necessary dependencies to your Podfile
3. As soon as you add the module code, it will be **detected and installed automatically** by the Chat SDK.

### Social Login

Make sure you add the Social login pod to your `Podfile` then follow the following setup guides to enable each login type.

#### Facebook

1. On the [Facebook developer](https://developers.facebook.com/) site get the **App ID** and **App Secret**
2. Go to the [Firebase Console](https://console.firebase.google.com/) and open the **Auth** section
3. On the **Sign in method** tab, enable the **Facebook** sign-in method and specify the **App ID** and **App Secret** you got from Facebook.
4. Then, make sure your **OAuth redirect URI** (e.g. `my-app-12345.firebaseapp.com/__/auth/handler`) is listed as one of your **OAuth redirect URIs** in your Facebook app's settings page on the Facebook for Developers site in the **Product Settings > Facebook Login** config
5. Add your key to the ChatSDK config object:

   ```
   config.facebookAppId = @"facebook-app-id";
   ```
   
6. Open `URL types -> Item 0 -> URL Schemes` and then add your AppID with "fb" at the front (e.g. fb0123456789). 
7. Add a new item to the plist called `LSApplicationQueriesSchemes` of type `Array`. Add a new entry `fbauth2`. 

#### Twitter

1. [Register your app](https://apps.twitter.com/) as a developer application on Twitter and get your app's **API Key** and **API Secret**.
2. In the [Firebase console](https://console.firebase.google.com/), open the **Auth** section.
3. On the **Sign in method** tab, enable the **Twitter** sign-in method and specify the **API Key** and **API Secret** you got from Twitter.
4. Then, make sure your Firebase **OAuth redirect URI** (e.g. `my-app-12345.firebaseapp.com/__/auth/handler`) is set as your **Callback URL** in your app's settings page on your [Twitter app's config](https://apps.twitter.com/).
5. Add your keys to the Chat SDK config object:

   ```
   config.twitterApiKey = @"twitter-api-key";
   config.twitterSecret = @"twitter-secret";
   ```
   
6. Open URL types and add a new item of type `Dictionary`
7. Add two entries `Document Role`: `Editor` and `URL Schemes`: `Array`
8. Add your Consumer Key prefixed with `twitterkit-` as an item in the new `URL Schemes` array. e.g. `twitterkit-0123456789`

#### Google
  
1. In the [Firebase console](https://console.firebase.google.com/), open the **Auth** section.
2. On the **Sign in method** tab, enable the **Google** sign-in method and click **Save**.
3. Add your Client Key to the Chat SDK config object:

   ```
   config.googleClientKey = @"google-client-key";
   ```
  
### Firebase UI

The [File UI module](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebaseUI) allows you to use the native Firebase user interface for authentication.

After adding the files to your Xcode project, add the following to the App Delegate to enable the module.

**Objective C**

_AppDelegate.m -> application: didFinishLaunchingWithOptions:_

```
 #import "BFirebaseUIModule.h"

[[[BFirebaseUIModule alloc] init] activateWithProviders: @[]];
```

**Swift**

_[YourProject]-Bridging-Header.h_

```
 #import "BFirebaseUIModule.h"
```

_AppDelegate.swift_

```
BFirebaseUIModule.init().activate(withProviders: []);
```

You should pass in array of the `FUIAuthProvider` objects you want to support. 

Also add the following to your Podfile depending on which authentication methods you want to support:

```
pod 'FirebaseUI/Facebook', '~> 4.0'
pod 'FirebaseUI/Google', '~> 4.0'
pod 'FirebaseUI/Twitter', '~> 4.0'
pod 'FirebaseUI/Phone', '~> 4.0'
```

Then run `pod install`.

>**Note**
>If you want to Firebase Auth UI make sure you comment out the following line:

```
BNetworkManager.shared().a.auth().setChallenge(BLoginViewController.init(nibName: nil, bundle: nil));
```

### Other Modules

For the following modules:

- [Keyboard overlay](http://chatsdk.co/downloads/keyboard-overlay/)
- [Sticker messages](http://chatsdk.co/downloads/sticker-messages/)
- [Contact book integration](http://chatsdk.co/downloads/contact-book-integration/)

These modules are distributed as development pods. After you've downloaded the module, unzip it and add it to the **ChatSDKModules** folder. Then:

1. Open your Podfile
2. Add the line:
  
  ```
  pod "ChatSDKModules/[ModuleName]", :path => "[Path to ChatSDKModules folder]"
  ```
3. Run `pod install`
4. The module is now active
  
## Using the Chat SDK API

The Chat SDK API is based around the network manager and a series of handlers. A good place to start is by looking at the handlers `Pods/Development Pods/ChatSDK/Core/Core/Classes/Interfaces`. Here you can review the handler interfaces which are well documented. To use a handler you would use the following code:

**Objective C**

```
[[BChatSDK.handler_name function: to: call:]
```

**Swift**

```
BNetworkManager.shared().a.handler_name() function: to: call:]
```

##### Searching for a user

For example, to search for a user you could use the search handler:

```
-(RXPromise *) usersForIndexes: (NSArray *) indexes withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded;
```

Here you pass in a series of indexes to be used in the search i.e. name, email etc... and a value. It will then return a series of user objects. 

You can also see example implementations of these handlers by looking at the `BFirebaseSearchHandler` class. And also seeing how the method is used in the Chat SDK. 

##### Starting a chat 

To start a chat you can use the core handler. 

```
-(RXPromise *) createThreadWithUsers: (NSArray *) users
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) thread;
```

When this method completes, the thread will have been created on Firebase and all the users will have been added. You could then open the thread using the interface adapter. 

```
UIViewController * chatViewController = [BChatSDK.ui chatViewControllerWithThread:thread];
```

So a more complete example would look like this:

```
-(void) startChatWithUser {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSBundle t:bCreatingThread];
    
    [[BChatSDK.core createThreadWithUsers:@[_user] threadCreated:^(NSError * error, id<PThread> thread) {
        if (!error) {
            [self pushChatViewControllerWithThread:thread];
        }
        else {
            [UIView alertWithTitle:[NSBundle t:bErrorTitle] withMessage:[NSBundle t:bThreadCreationError]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void) pushChatViewControllerWithThread: (id<PThread>) thread {
    if (thread) {
        UIViewController * chatViewController = [BChatSDK.ui chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}
```  

## Troubleshooting Cocoapods

1. Always open the .xcworkspace file rather than .xcodeproj
2. Check CocoaPod warnings - make sure to fix any warnings before proceeding
3. Make sure that your base configuration isn’t set: Project -> project name -> Info -> Configuration
4. Make sure that the “Build Active Architecture Only” setting is the same for both the main project and the pods project. 
5. Check the build settings in the Xcode project and check which fields are in bold (this means that their value has been overridden and CocoaPods can't access them). If you press backspace while selecting those fields, their values will be set to the default value.

## The license

We offer a choice of two license for this app. You can either use the [Chat SDK](https://chatsdk.co/chat-sdk-license/) license or the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) license. 

Most Chat SDK users either want to add the Chat SDK to an app that will be released to the App Store or they want to use the Chat SDK in a project for their client. The **Chat SDK** license gives you complete flexibility to do this for free.

**Chat SDK License Summary**

+ License does not expire.
+ Can be used for creating unlimited applications
+ Can be distributed in binary or object form only
+ Commercial use allowed
+ Can modify source-code but cannot distribute modifications (derivative works)

If a user wants to distribute the Chat SDK source code, we feel that any additions or modifications they make to the code should be contributed back to the project. The GPLv3 license ensures that if source code is distributed, it must remain open source and available to the community.

**GPLv3 License Summary**

+ Can modify and distribute source code
+ Commerical use allowed
+ Cannot sublicense or hold liable
+ Must include original license
+ Must disclose source 

**What does this mean?**

Please check out the [Licensing FAQ](https://github.com/chat-sdk/chat-sdk-ios/blob/master/LICENSE.md) for more information.

 


