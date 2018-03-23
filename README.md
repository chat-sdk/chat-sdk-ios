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

- [Typing indicator](http://chatsdk.co/downloads/typing-indicator/)
- [Read receipts](http://chatsdk.co/downloads/read-receipts/)
- [Location based chat](http://chatsdk.co/downloads/location-based-chat/)
- [Audio messages](http://chatsdk.co/downloads/audio-messages/)
- [Video messages](http://chatsdk.co/downloads/video-messages/)
- [Keyboard overlay](http://chatsdk.co/downloads/keyboard-overlay/)
- [Sticker messages](http://chatsdk.co/downloads/sticker-messages/)
- [Contact book integration](http://chatsdk.co/downloads/contact-book-integration/)
- [User Blocking](http://chatsdk.co/downloads/user-blocking-for-ios/)
- [Social Login](https://github.com/chat-sdk/chat-sdk-ios#social-login)
- [Push Notifications](https://github.com/chat-sdk/chat-sdk-ios#push-notifications)
- [File Storage](https://github.com/chat-sdk/chat-sdk-ios#file-storage)
- [Firebase UI](https://github.com/chat-sdk/chat-sdk-ios#firebase-ui)

## Help spread the word
Chat SDK is free and open source. If you like the project help us spread the word by:

+ Giving us a Github star ⭐
+ Upvoting our page on [Product Hunt](https://www.producthunt.com/posts/chat-sdk)

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
Document](https://github.com/chat-sdk/chat-sdk-ios/blob/master/CONTRIBUTING.md) for details of our development flow and the CLA then email me at [**team@chatsdk.co**](mailto:team@chatsdk.co).

## Apps that use Chat SDK

Here are the apps we know about that are using Chat SDK. If you've relased an app that uses the framework let us know and we'll add it to the list:

+ [Parlor](http://parlor.me/)
+ [Runbuddy](https://itunes.apple.com/us/app/run-buddy/id1050833009?mt=8)
+ [INDX01](https://itunes.apple.com/us/app/keynote/id1265222713?mt=8)

Stats:


## Setup Service and consulting

##### Setup Service

We provide extensive documentation on Github but if you’re a non-technical user or want to save yourself some work you can take advantage of our [setup and integration service](http://chatsdk.co/downloads/chat-sdk-setup-service/).

##### Consulting services

We are specialists in real-time application development including: Firebase, Firestore, XMPP and WebRTC for iOS and Android. If you need help integrating the Chat SDK with your app or another app development project email us at [team@chatsdk.co](mailto: team@chatsdk.co). 

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
  ```

3. Add additional support pods. These are external pods that are needed by the Chat SDK

  ```
  pod "Firebase/Auth"  
  pod "Firebase/Database"  
  pod "Firebase/Messaging"  
  pod "Firebase/Storage"  
  ```
  
4. Run `pod install` or `pod update` to get the latest version of the code.

5. Download the source code for the Chat SDK that matches the version you are instlling using CocoaPods from [this loction](https://github.com/chat-sdk/chat-sdk-ios/releases). Copy the **FirebaseNetworkAdapter** folder into the source code directory of your Xcode project. From inside Xcode, right click in the left panel click **Add Files** and add the **FirebaseNetworkAdapter** folder.

  You can see how to add it via symlink [here](https://github.com/chat-sdk/chat-sdk-ios#adding-the-firebase-adapter-source-code).

6. Open the **App Delegate** add the following code to initialise the chat

  **Objective C**

  _AppDelegate.m -> application: didFinishLaunchingWithOptions:_
  
  ```
  #import <ChatSDK/ChatCore.h>
  #import <ChatSDK/ChatUI.h>
  ```

  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  BConfiguration * config = [BConfiguration configuration];
  config.rootPath = @"test";
  // Configure other options here...
  
  [BChatSDK initialize:config app:application options:launchOptions];

  // Set the root view controller
  [self.window setRootViewController:[BInterfaceManager sharedManager].a.appTabBarViewController];
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
  config.rootPath! = "test"
  // Configure other options here...
  
  config.allowUsersToCreatePublicChats = true
  BChatSDK.initialize(config, app: application, options: launchOptions)
        
  self.window = UIWindow.init(frame: UIScreen.main.bounds)
  self.window?.rootViewController = BInterfaceManager.shared().a.appTabBarViewController();
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
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return BChatSDK.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    }
  ```
  
  ##### The Root Path

  >The root path variable allows you to run multiple Chat SDK instances on one Firebase account. Each different root path will represent a completely separate set of Firebase data. This can be useful for testing because you could have separate **test** and **prod** root paths.
      
7. The Chat SDK is now added to your project
8. Add the [Firebase File Storage](https://github.com/chat-sdk/chat-sdk-ios#file-storage) module which is required for image and location messages and user profile avatars. 
9. Add the [security rules](https://github.com/chat-sdk/chat-sdk-ios#security-rules)

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
  3. `FacebookAppID`
  4. Make sure that the URL types are all set correctly. The URL type for your app should be set to your bundle `id`
  5. All the privacy rows. These will allow the app to access the camera, location and address book

11. In the Firebase dashboard click **Authentication -> Sign-in method** and enable all the appropriate methods 
12. Enable file storage - Click **Storage -> Get Started** 
13. Enable [push notifications](https://github.com/chat-sdk/chat-sdk-ios#push-notifications)
14. Enable location messages. Get a [Google Maps API](https://developers.google.com/maps/documentation/ios-sdk/get-api-key) key. Then add it during the Chat SDK configuration

  **Objective C**
  
  ```
  config.googleMapsApiKey = @"YOUR API KEY";
  ```
  
  **Swift**
  
  ```
  config.googleMapsApiKey = "YOUR API KEY"
  ```

### Conclusion

Congratulations! 🎉🎉 You've just turned your app into a fully featured instant messenger! Keep reading below to learn how to further customize the Chat SDK.

# Next Steps

### Configuration

There are a number of configuration options available. Check out the [BConfiguration](https://github.com/chat-sdk/chat-sdk-ios/blob/master/ChatSDKCore/Classes/Session/BConfiguration.h) class. Using this class you can do things like:

- Changing the chat bubble colors
- Changing the default user name
- Enable or disable different types of login
- Show or hide empty chats
- etc...

### Use Chat SDK views in your app

Any of the Chat SDK views can be added into your app. Checkout the [PInterfaceFacade](https://github.com/chat-sdk/chat-sdk-ios/blob/master/ChatSDKCore/Classes/UI/PInterfaceFacade.h) for options. You can add a any view using the following pattern. Here we are using the interface service to get the particular view. 

*Objective-C*

```
UIViewController * privateThreadsViewController = [[BInterfaceManager sharedManager].a privateThreadsViewController];
```

*Swift*

```
let privateThreadsViewController = BInterfaceManager.shared().a.privateThreadsViewController()
```

### Checkout the full development documentation

The [documentation](https://github.com/chat-sdk/docs#custom-authentication) contains guides for the following:

1. Interacting with the Firebase server
2. Creating and updating entities
3. Custom authentication
4. Common code examples
5. Customizing the user interface

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

- [Firebase File Storage](https://github.com/chat-sdk/chat-sdk-ios#file-storage) (free)
- [Firebase Push Notifications](https://github.com/chat-sdk/chat-sdk-ios#push-notifications) (free)
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

The [social login module](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebaseSocialLogin) allows you to support user authentication using some popular social networks including Twitter, Facebook and Google Plus. 

After adding the **SocialLogin** files to your Xcode project, add the following to your Podfile:

```
pod 'TwitterKit',
pod 'GoogleSignIn'
pod 'FBSDKLoginKit'
```

#### Facebook

1. On the [Facebook developer](https://developers.facebook.com/) site get the **App ID** and **App Secret**
2. Go to the [Firebase Console](https://console.firebase.google.com/) and open the **Auth** section
3. On the **Sign in method** tab, enable the **Facebook** sign-in method and specify the **App ID** and **App Secret** you got from Facebook.
4. Then, make sure your **OAuth redirect URI** (e.g. `my-app-12345.firebaseapp.com/__/auth/handler`) is listed as one of your **OAuth redirect URIs** in your Facebook app's settings page on the Facebook for Developers site in the **Product Settings > Facebook Login** config
5. Open your projects Info.plist
6. Add a new entry `FacebookAppID` then add your Facebook App ID
7. Then open the `chat_sdk -> facebook` entry and add your AppID in the `app_id` field
8. Open `URL types -> Item 0 -> URL Schemes` and then add your AppID with "fb" at the front (e.g. fb0123456789). 
9. Add a new item to the plist called `LSApplicationQueriesSchemes` of type `Array`. Add a new entry `fbauth2`. 

#### Twitter

1. [Register your app](https://apps.twitter.com/) as a developer application on Twitter and get your app's **API Key** and **API Secret**.
2. In the [Firebase console](https://console.firebase.google.com/), open the **Auth** section.
3. On the **Sign in method** tab, enable the **Twitter** sign-in method and specify the **API Key** and **API Secret** you got from Twitter.
4. Then, make sure your Firebase **OAuth redirect URI** (e.g. `my-app-12345.firebaseapp.com/__/auth/handler`) is set as your **Callback URL** in your app's settings page on your [Twitter app's config](https://apps.twitter.com/).
5. Open your projects **Info.plist**
6. Open **chat_sdk -> twitter**
7. Add your Consumer Key to the **api_key** field
8. Add your Consumer Secret to the **secret** field
9. Open URL types and add a new item of type `Dictionary`
10. Add two entries `Document Role`: `Editor` and `URL Schemes`: `Array`
11. Add your Consumer Key prefixed with `twitterkit-` as an item in the new `URL Schemes` array. e.g. `twitterkit-0123456789`

#### Google
  
1. In the [Firebase console](https://console.firebase.google.com/), open the **Auth** section.
2. On the **Sign in method** tab, enable the **Google** sign-in method and click **Save**.
3. Open your projects **Info.plist**
4. Open **chat_sdk -> google**
5. Add your Client Key to the **client_key** field
  
### Push Notifications

The Push Notification module allows you to send free push notifications using Firebase Clound Messenger.

Add [Push Notifications](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebasePush) module to your Xcode project.

Then:

1. Setup an [APN certificate](https://firebase.google.com/docs/cloud-messaging/ios/certs). 
2. Inside your project in the Firebase console, select the gear icon, select Project Settings, and then select the Cloud Messaging tab.
3. In APNs authentication key under iOS app configuration, click the Upload button.
4. Browse to the location where you saved your key, select it, and click Open. Add the key ID for the key (available in Certificates, Identifiers & Profiles in the Apple Developer Member Center) and click Upload.
5. Enable the push notifications Capability in your Xcode project **Project -> Capabilities -> Push Notifications**
6. Add the Server key from the Firebase console **Settings -> Cloud Messaging -> Project credentials** to the `cloud_messaging_server_key` entry in **Info.plist -> chat_sdk -> firebase**

>**Note:**
>We add the server key directly to the project because it makes it very easy to send targeted push notifications. However, this method isn't the best from a security perspective because it means that if someone decompiled and examined the app package, they could gain access to the key and send push notifications using your account. A more secure approach would be to use a separate app server to send the pushes or to use Google Cloud Code. 

### File Storage

The [File Storage module](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebaseFileStorage) allows you to send image messages. These messages are stored on the Firebase server. 

After adding the modules files to your Xcode project. The module is installed automatically. 

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
  
#### Security Rules

Firebase secures your data by allowing you to write rules to govern who can access the database and what can be written. On the Firebase dashboard click **Database** then the **Rules** tab. 

Copy the contents of the [**rules.json**](https://github.com/chat-sdk/chat-sdk-ios/blob/master/rules.json) file into the rules and click publish.

## Using the Chat SDK API

The Chat SDK API is based around the network manager and a series of handlers. A good place to start is by looking at the handlers `Pods/Development Pods/ChatSDK/Core/Core/Classes/Interfaces`. Here you can review the handler interfaces which are well documented. To use a handler you would use the following code:

**Objective C**

```
[[BNetworkManager sharedManager].a.handler_name function: to: call:]
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
UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
```

So a more complete example would look like this:

```
-(void) startChatWithUser {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSBundle t:bCreatingThread];
    
    [[BNetworkManager sharedManager].a.core createThreadWithUsers:@[_user] threadCreated:^(NSError * error, id<PThread> thread) {
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
        UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}
```

### Adding the Firebase Adapter Source Code

#### Recommended Project Structure

We've tried to make it as easy as possible to add Chat SDK to your project. However since it's it's a relatively complex project with a lot of dependencies (and because of some issues with Cocoapods) the setup needs to be handeled carefully. 

So that things run smoothly, we recommend that you keep the Chat SDK Firebase Adapter library in the folder outside your Xcode project folder. A typical structure would look like this:

```
- ChatSDKModules
- ChatSDKFirebase

- YourProject
- /---- YourProject.xcodeproj
- /---- YouProject
- /---- /---- [.m and .h files]
- /---- /---- setup_links.sh
- /---- Podfile
```

All the paths in the instructions will be provided assuming this project structure. If you use a different structure, you will need to modify the paths accordingly. 

You can add the Chat SDK Firebase Adapter in two ways:

#### Drag and drop

Download the version of the Chat SDK that corresponds to the vesion that you are installing from CocoaPods from [this location](https://github.com/chat-sdk/chat-sdk-ios/releases). Copy the **FirebaseNetworkAdapter** folder from [chat-sdk-ios/ChatSDK/ChatSDKFirebase/FirebaseNetworkAdapter](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebaseNetworkAdapter) into your Xcode project. From inside Xcode, right click in the left panel click **Add Files** and add the **FirebaseNetworkAdapter** folder. 

  >**Note**  
  >There are currently ongoing issues with the Firebase pods which make it very difficult for us to include the Chat SDK Firebase Adapter in a pod. Until these issues are resolved, the easiest approach is to drag the files into Xcode directly. 
  
#### Symlink
  
Adding via symlink allows you to have one copy of the Firebase adapter source code which can be referenced by multiple Xcode projects. The idea is to create a symbolic link inside your Xcode project to the folder containing the source code which is outside of the project. This way you can reference the same code with multiple projects. 

To setup the [symlinks](https://kb.iu.edu/d/abbe) you need to find the [**setup_links.sh**](https://github.com/chat-sdk/chat-sdk-ios/blob/master/Xcode/ChatSDK%20Demo/setup_links.sh) script. This should be added to your Xcode project where you want to setup the symlinks (see [Project Structure](https://github.com/chat-sdk/chat-sdk-ios#project-structure)). Run the script by opening the folder in the terminal and running `sh setup_links.sh`. Enter the path to the ChatSDKFirebase folder (you can also find the `chat-sdk-ios` folder in Finder and drag and drop it into the terminal). If you use the default project structure, you can just leave this blank (the default path is `../../`). Then open Xcode and add the symlink folders using the normal process.  

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

 


