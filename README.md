# Chat SDK
### Open Source Messaging framework for iOS

<img target="_blank" src="https://raw.githubusercontent.com/chat-sdk/dev/master/img/hand.png" />

Chat SDK is a fully featured open source instant messaging framework for iOS. Chat SDK is fully featured, scalable and flexible and follows the following key principles:

- **Open Source.** The Chat SDK is open source and free for commerical apps ([see license](https://github.com/chat-sdk/chat-sdk-ios#the-license))
- **Full data control.** You have full and exclusive access to the user's chat data
- **Quick integration.** Chat SDK is fully featured out of the box
- **Firebase** Powered by [Google Firebase](https://firebase.google.com/)

<!--A demo of the project is available on the App Store.  

<a target="_blank" href="https://itunes.apple.com/us/app/chatcat/id962537653?mt=8"><img src="https://raw.githubusercontent.com/chat-sdk/dev/master/img/app-store.jpg" width="290" height="100" alt="App Store" /></a>
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

<img src="https://raw.githubusercontent.com/chat-sdk/dev/master/img/features.png" />

Full breakdown is available on the [features page](http://chatsdk.co/features/).

## Quick Start

- [Standard Documentation](https://github.com/chat-sdk/chat-sdk-ios#adding-the-chat-sdk-to-your-project) (For experienced developers) 
- [API Documentation](https://github.com/chat-sdk/docs)
- [Code Examples](https://github.com/chat-sdk/chat-sdk-ios/blob/master/Xcode/ChatSDK%20Demo/ApiExamples.m)
- [Wiki](https://github.com/chat-sdk/chat-sdk-ios/wiki)

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
- [Push Notifications (free)](https://github.com/chat-sdk/chat-sdk-ios#push-notifications)
- [File Storage (free)](https://github.com/chat-sdk/chat-sdk-ios#file-storage)
- [Firebase UI (free)](https://github.com/chat-sdk/chat-sdk-ios#firebase-ui)

## About Us

Learn about the history of Chat SDK and our future plans in [this post](https://hackmd.io/@dyR2Vn0UTFaO8tZjyiJyHw/BkBKhRO0I).

## Scalability and Cost

People always ask about how much Chat SDK costs to run. And will it scale to millions of users? So I wrote an article talking about [just that](https://hackmd.io/@dyR2Vn0UTFaO8tZjyiJyHw/r1LJ26d0L). 

## Looking for Freelance Developers

If you're a freelance developer looking for work, join our Discord server. We often have customers 



## Community

+ **Discord:** If you need support, join our [Server](https://discord.gg/abT5BM4)
+ **Support the project:** [Patreon](https://www.patreon.com/chatsdk) or [Github Sponsors](https://github.com/sponsors/chat-sdk) 🙏 and get access to premium modules
+ **Upvote:** our advert on [StackOverflow](https://meta.stackoverflow.com/questions/394409/open-source-advertising-1h-2020/396154#396154)
+ **Contribute by writing code:** Email the [Contributing
Document](https://github.com/chat-sdk/chat-sdk-ios/blob/master/CONTRIBUTING.md) to [**team@sdk.chat**](mailto:team@sdk.chat)
+ **Give us a star** on Github ⭐
+ **Upvoting us:** [Product Hunt](https://www.producthunt.com/posts/chat-sdk)
+ **Tweet:** about your Chat SDK project using [@chat_sdk](https://mobile.twitter.com/chat_sdk) 
+ **Live Stream** Join us every **Saturday 18:00 CEST for a live stream** where I answer questions about Chat SDK. For more details please join the Discord Server 

You can also help us by:

+ Providing feedback and feature requests
+ Reporting bugs
+ Fixing bugs
+ Writing documentation

Email us at: [team@sdk.chat](mailto:team@sdk.chat)

We also offer development services we are a team of full stack developers who are Firebase experts.
For more information check out our [consulting site](https://chat-sdk.github.io/hire-us/). 

## Running the demo project
This repository contains a fully functional version of the Chat SDK which is configured using our Firebase account. This is great way to test the features of the Chat SDK before you start itegrating it with your app. 

1. Clone Chat SDK  
2. Run `pod install` in the **Xcode** directory  
3. Open the `Chat SDK Firebase.xcworkspace` file in Xcode  
4. Compile and run

## Swift Version

We are currently updating the Chat SDK to use Swift, this will happen gradually. In the meantime, the Chat SDK API is fully compatible with Swift projects. 

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
  pod "ChatSDKFirebase/Upload"
  pod "ChatSDKFirebase/Push"
  ```
  _Optional_

  ```
  pod "ChatSDK/ModAddContactWithQRCode"
  ```
  
2. Run `pod update` to get the latest version of the code.

3. Open the **App Delegate** add the following code to initialise the chat

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
  
  // Define the modules you want to use. 
  var modules = [
      FirebaseNetworkAdapterModule.shared(),
      FirebasePushModule.shared(),
      FirebaseUploadModule.shared(),
      // Optional...
      AddContactWithQRCodeModule.init(),
  ]
  
  BChatSDK.initialize(config, app: application, options: launchOptions, modules: modules)
  
      
  self.window = UIWindow.init(frame: UIScreen.main.bounds)
  self.window?.rootViewController = BChatSDK.ui().splashScreenNavigationController()
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    }
  ```

**Objective C**
  
Check the [demo project](). 
  
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
  3. Make sure that the URL types are all set correctly. The URL type for your app should be set to your bundle `id`
  4. All the privacy rows. These will allow the app to access the camera, location and address book

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

## Documentation

- [Docs Home](https://chat-sdk.gitbook.io/chat-sdk/)
- [iOS Docs](https://chat-sdk.gitbook.io/ios/)
- [Firebase Schema](https://chat-sdk.gitbook.io/chat-sdk/guides/firebase-schema)
- [Custom Token Authentication](https://chat-sdk.gitbook.io/chat-sdk/guides/custom-token-authentication)
- [API Quick Start](https://chat-sdk.gitbook.io/chat-sdk/guides/api-cheatsheet)
- [Custom File Upload Handler](https://chat-sdk.gitbook.io/chat-sdk/guides/custom-file-upload-handler)
- [XMPP Setup Guide](https://chat-sdk.gitbook.io/chat-sdk/xmpp/xmpp-setup-guide)

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
3. Add the modules to the array of modules during configuration.
  
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

 


