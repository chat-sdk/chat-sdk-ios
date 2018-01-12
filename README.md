# Chat SDK
### Open Source Messaging framework for iOS

<img target="_blank" src="http://img.chatcatapp.com/chat-sdk-hand.jpg" />

Chat SDK is a fully featured open source instant messaging framework for iOS. Chat SDK is fully featured, scalable and flexible and follows the following key principles:

- **Open Source.** The Chat SDK is open source under the MIT license for compiled binaries
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
- Phone number authentication
- Push notifications (using FCM)
- Text, Image and Location messages
- User profiles
- User search
- Powered by Firebase
- Firebase UI
- [Android Version](https://github.com/chat-sdk/chat-sdk-android)
- [Web Version](https://github.com/chat-sdk/chat-sdk-web)

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

+ [Parlor](http://parlor.me/)
+ [Runbuddy](https://itunes.apple.com/us/app/run-buddy/id1050833009?mt=8)
+ [INDX01](https://itunes.apple.com/us/app/keynote/id1265222713?mt=8)

If you have an app that uses the Chat SDK let us know and we'll add a link. 

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

### Setup Service

We provide extensive documentation on Github but if you’re a non-technical user or want to save yourself some work you can take advantage of our [setup and integration service](http://chatsdk.co/downloads/chat-sdk-setup-service/).

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

5. Copy the **FirebaseAdapter** folder from [chat-sdk-ios/ChatSDK/ChatSDKFirebase/FirebaseAdapter](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDK/ChatSDKFirebase/FirebaseAdapter) into the source code directory of your Xcode project. From inside Xcode, right click in the left panel click **Add Files** and add the **FirebaseAdapter** folder.

  You can see how to add it via symlink [here](https://github.com/chat-sdk/chat-sdk-ios#adding-the-firebase-adapter-source-code).

6. Open the **App Delegate** add the following code to initialise the chat

  **Objective C**

  _AppDelegate.m -> application: didFinishLaunchingWithOptions:_
  
  ```
  #import <ChatSDK/ChatCore.h>
  #import <ChatSDK/ChatUI.h>
  #import <ChatSDK/ChatCoreData.h>
  #import "ChatFirebaseAdapter.h"
  ```

  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  BConfiguration * config = [BConfiguration configuration];
  config.rootPath = @"test";
  [BChatSDK initialize:config]
  
  [BNetworkManager sharedManager].a = [[BFirebaseNetworkAdapter alloc] init];
  [BInterfaceManager sharedManager].a = [[BDefaultInterfaceAdapter alloc] init];
  [BStorageManager sharedManager].a = [[BCoreDataManager alloc] init];
  
  UIViewController * mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];

  // Set the login screen
  [BNetworkManager sharedManager].a.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];

  [self.window setRootViewController:mainViewController];
  ```
  
  **Swift**
  
  _AppDelegate.swift_
  
  ```
  import ChatSDK
  ```

  Add the following to your bridging header
  
  ```
  #import "ChatFirebaseAdapter.h"
  ```
  
  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  let config = BConfiguration.init();
  config.rootPath! = "test"
  BChatSDK.initialize(config);
  
  BInterfaceManager.shared().a = BDefaultInterfaceAdapter.init()
  BNetworkManager.shared().a = BFirebaseNetworkAdapter.init()
  BStorageManager.shared().a = BCoreDataManager.init()
  
  let mainViewController = BAppTabBarController.init(nibName: nil, bundle: nil)
  BNetworkManager.shared().a.auth().setChallenge(BLoginViewController.init(nibName: nil, bundle: nil));
        
  self.window = UIWindow.init(frame: UIScreen.main.bounds)
  self.window?.rootViewController = mainViewController;
  self.window?.makeKeyAndVisible();
  ```
  
  ##### The Root Path

  >The root path variable allows you to run multiple Chat SDK instances on one Firebase account. Each different root path will represent a completely separate set of Firebase data. This can be useful for testing because you could have separate **test** and **prod** root paths.
      
7. The Chat SDK is now added to your project
8. Add the [Firebase File Storage](https://github.com/chat-sdk/chat-sdk-ios#file-storage) module which is required for image and location messages and user profile avatars. 

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
  4. All the privacy rows. These will allow the app to access the camera, location and address book

11. In the Firebase dashboard click **Authentication -> Sign-in method** and enable all the appropriate methods 

### Conclusion

Congratulations! 🎉🎉 You've just turned your app into a fully featured instant messenger! Keep reading below to learn how to further customize the Chat SDK.

# Next Steps

## Check out the Development Guide

We've written a [comprehensive Development Guide](https://github.com/chat-sdk/docs) which is available in the docs repository. 

If you thing that something is missing, you can post a new issue and we will update the guide. 

We have a number of additional guides available on our [Wiki](https://github.com/chat-sdk/chat-sdk-ios/wiki) including:

- [Exploring the Chat SDK Architecture](https://github.com/chat-sdk/chat-sdk-ios/wiki/Exploring-the-Chat-SDK-Architecture)
- [Calculating the cost of different backends](https://github.com/chat-sdk/blog/wiki/Messaging-service-price-comparison)
- [Facebook login setup guide](https://github.com/chat-sdk/chat-sdk-ios/wiki/Chat-SDK-iOS:-Facebook-login)
- [Twitter login setup guide](https://github.com/chat-sdk/chat-sdk-ios/wiki/Chat-SDK-iOS:-Twitter-Login)

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
3. Import the module's header file (or add it to the bridging header for a Swift project)
4. Activate the module in the `AppDelegate.m` file

### Social Login

The [social login module](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebaseSocialLogin) allows you to support user authentication using some popular social networks including Twitter, Facebook and Google Plus. 

After adding the **SocialLogin** files to your Xcode project, add the following to your Podfile:

```
pod 'TwitterKit', '2.3'
pod 'GoogleSignIn'
pod 'FBSDKLoginKit'
```

**Objective C**

_AppDelegate.m -> application: didFinishLaunchingWithOptions:_

```
 #import "BFirebaseSocialLoginModule.h"

[[[BFirebaseSocialLoginModule alloc] init] activateWithApplication:application withOptions:launchOptions];

```

Also add this function:

```
// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([BNetworkManager sharedManager].a.socialLogin) {
        return [[BNetworkManager sharedManager].a.socialLogin application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return NO;
}
```

**Swift**

_[YourProject]-Bridging-Header.h_

```
 #import "BFirebaseSocialLoginModule.h"
```

_AppDelegate.swift_

```
BFirebaseSocialLoginModule.init().activate(with: application, withOptions: launchOptions);
```

Also add this function:

```
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if(BNetworkManager.shared().a.socialLogin() != nil) {
        return BNetworkManager.shared().a.socialLogin().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    return false
}
```

Follow the social login [setup guides](https://github.com/chat-sdk/chat-sdk-ios/wiki). 

### Push Notifications

The Push Notification module allows you to send free push notifications using Firebase Clound Messenger.

After adding the [Push Notifications](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebasePush) module to your Xcode project, add the following to the App Delegate to enable the module.

**Objective C**

_AppDelegate.m -> application: didFinishLaunchingWithOptions:_

```
 #import "BFirebasePushModule.h"

[[[BFirebasePushModule alloc] init] activateForFirebaseWithApplication:application withOptions:launchOptions];
```

Also add these functions:

```
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[BNetworkManager sharedManager].a.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[BNetworkManager sharedManager].a.push application:application didReceiveRemoteNotification:userInfo];
}
```

**Swift**

_[YourProject]-Bridging-Header.h_

```
 #import "BFirebasePushModule.h"
```

_AppDelegate.swift_

```
BFirebasePushModule.init().activateForFirebase(with: application, withOptions: launchOptions);
```

Also add these functions:

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

Then follow the Firebase Push notification [setup guide](https://github.com/chat-sdk/chat-sdk-ios/wiki/FIrebase-Push-Notification-Setup). 

### File Storage

The [File Storage module](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDKFirebase/FirebaseFileStorage) allows you to send image messages. These messages are stored on the Firebase server. 

After adding the files to your Xcode project, add the following to the App Delegate to enable the module.

**Objective C**

_AppDelegate.m -> application: didFinishLaunchingWithOptions:_

```
 #import "BFirebaseFileStorageModule.h"

[[[BFirebaseFileStorageModule alloc] init] activateForFirebase];
```

**Swift**

_[YourProject]-Bridging-Header.h_

```
 #import "BFirebaseFileStorageModule.h"
```

_AppDelegate.swift_

```
BFirebaseFileStorageModule.init().activateForFirebase();
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
  ChatSDKModules/[ModuleName], :path => "[Path to ChatSDKModules folder]"
  ```
3. Run `pod install`
4. In your _AppDelegate -> application: didFinishLaunchingWithOptions:_ add the following

  **Objective C**

  ```
  #import "B[ModuleName]Module.h"
  
  [[[B[ModuleName]Module alloc] init] activate];
  ```
  
  **Swift**

  __AppDelegate.swift__
  
  ```
  import ChatSDKModules
  
  B[Module Name]Module.init().activate()
  ```


#### Security Rules

Firebase secures your data by allowing you to write rules to govern who can access the database and what can be written. On the Firebase dashboard click **Database** then the **Rules** tab. 

Copy the contents of the [**rules.json**](https://github.com/chat-sdk/chat-sdk-ios/blob/master/rules.json) file into the rules and click publish.

## Integrating the Chat SDK with an existing login system

To start with, you should have completed the steps above to add the Chat SDK to your project. To integrate the Chat SDK we need to intercept three key events in your app:

- Login
- User profile update
- Logout

Once this is done, you will be able to access the Chat SDK API to perform actions like searching for users, creating threads and sending messages. 

When integrating the Chat SDK with an existing app it's best practice to create a new class with static methods to handle the lifecycle of the Chat SDK. This means that you can perform actions like setting the authentication token, updating the user and logging out from anywhere in your app. This also helps to separate the Chat SDK code from your own code. 

### Login

To integrate with a third party server two steps are necessary:

1. Generate an authentication token on your server
2. Pass the token to the Chat SDK

To generate a token, you should follow the Firebase [custom authentication guide](https://firebase.google.com/docs/auth/admin/create-custom-tokens).

In PHP, an implementation may look like this:

```
// Get your service account's email address and private key from the JSON key file
$service_account_email = "abc-123@a-b-c-123.iam.gserviceaccount.com";
$private_key = "-----BEGIN PRIVATE KEY-----...";

function create_custom_token($uid, $is_premium_account) {
  global $service_account_email, $private_key;

  $now_seconds = time();
  $payload = array(
    "iss" => $service_account_email,
    "sub" => $service_account_email,
    "aud" => "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
    "iat" => $now_seconds,
    "exp" => $now_seconds+(60*60),  // Maximum expiration time is one hour
    "uid" => $uid,
    "claims" => array(
      "premium_account" => $is_premium_account
    )
  );
  return JWT::encode($payload, $private_key, "RS256");
}
``` 

>**Note:**  
>It is recommended to set the token expiry to a high value to prevent the case where the user is logged in to the server but not the Chat SDK.

The id should be the id your server uses to identify the user who is currently logged in. This token should be passed back to the app. Then the user can be authenticated as follows:

**Objective C**

```
[[BNetworkManager sharedManager].a.auth authenticateWithDictionary:@{bLoginTypeKey: @(bAccountTypeCustom),
bLoginCustomToken: token}].thenOnMain(^id(id<PUser> user) {
    // Login Success
    return Nil;
}, ^id(NSError * error) {
    // Login Failure
    return Nil;
});
```

**Swift**

```
let dict = [bLoginTypeKey: bAccountTypeCustom.rawValue, bLoginCustomToken: token] as [String : Any]

let block = BNetworkManager.shared().a.auth().authenticate(with: dict).thenOnMain
_ = block!({(result: Any?) -> Any? in
      // Login Success
      return result
  }, {(error: Error?) -> Any? in
      // Login Failure
      return error
  })
```

>**Note:**  
>This code could be added as a static function to the Chat SDK handler class as mentioned above. 

### User integration

The Chat SDK uses CoreData to persist it's data. This includes a user object which is used to store the current user's information. 

Whenever the user updates their details in your app, they should also update the information that is used by Chat SDK. 

```
id<PUser> user = [BNetworkManager sharedManager].a.core.currentUserModel;

user.name = @"Name goes here";
user.email = @"Email goes here";
user.phoneNumber = @"Number goes here"

// Set the 
[user setImage:UIImagePNGRepresentation(image)];
[user setThumbnail:UIImagePNGRepresentation(thumbnail)];

// Upload the image and thumbnail if necessary
[[BNetworkManager sharedManager].a.upload uploadImage:image thumbnail:thumbnail].thenOnMain(^id(NSDictionary * urls) {
    
    // Set the paths to the image and thumbnail
    [user setMetaString:urls[bImagePath] forKey:bUserPictureURLKey];
    [user setMetaString:urls[bThumbnailPath] forKey:bUserPictureURLThumbnailKey];
    
    // Update the user profile on Firebase
    [[BNetworkManager sharedManager].a.core pushUser];
    
    return urls;
}, Nil);
```

### Logging out

When your user logs out of the app, they should also log out of the Chat SDK. 

**Objective C**

```
[[BNetworkManager sharedManager].a.auth logout];
```

**Swift**

```
BNetworkManager.shared().a.auth().logout()
```

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

Copy the **FirebaseAdapter** folder from [chat-sdk-ios/ChatSDK/ChatSDKFirebase/FirebaseAdapter/Classes](https://github.com/chat-sdk/chat-sdk-ios/tree/master/ChatSDK/ChatSDKFirebase/FirebaseAdapter/Classes) into your Xcode project. From inside Xcode, right click in the left panel click **Add Files** and add the **FirebaseAdapter** folder. 

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

 


