# Chat SDK
### Open Source Messaging framework for iOS

<img target="_blank" src="http://img.chatcatapp.com/chat-sdk-hand.jpg" />

Chat SDK is a fully featured open source instant messaging framework for iOS. Chat SDK is fully featured, scalable and flexible and follows the following key principles:

- **Open Source.** The Chat SDK is open source under the MIT license for compiled binaries
- **Full data control.** You have full and exclusive access to the user's chat data
- **Quick integration.** Chat SDK is fully featured out of the box
- **Firebase** Powered by [Google Firebase](https://firebase.google.com/)

A demo of the project is available on the App Store.  

<a target="_blank" href="https://itunes.apple.com/us/app/chatcat/id962537653?mt=8"><img src="http://www.binpress.com/uploads/store33364/itunes-app-store-logo.png" width="290" height="100" alt="App Store" /></a>

## Features

- Private and group messages
- Public chat rooms
- Username / password, Facebook, Twitter, Anonymous and custom login
- Push notifications
- Text, Image and Location messages
- User profiles
- User search
- Powered by Firebase
- Firebase UI
- [Cross Platform - see Android Version](https://github.com/chat-sdk/chat-sdk-android)

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
- [Push notifications](http://chatsdk.co/downloads/backendless-push-notifications/)
- [Social Login](https://chatsdk.co/downloads/firebase-social-login/)
- [Two Factor Authentication](https://chatsdk.co/downloads/two-factor-authentication/)

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

If you have an app that uses the Chat SDK let us know and we'll add a link. 

## Running the demo project
This repository contains a fully functional version of the Chat SDK which is configured using our Firebase account and social media logins. This is great way to test the features of the Chat SDK before you start itegrating it with your app. 

1. Clone Chat SDK  
2. Run ```pod install``` in the **Xcode** directory  
3. Open the ```Chat SDK Firebase.xcworkspace``` file in Xcode  
4. Compile and run

## Swift Version
The Chat SDK is fully compatible with Swift projects and contains a Swift demo project. 

1. Clone Chat SDK  
2. Run ```pod install``` in the **XcodeSwift** directory  
3. Open the ```ChatSDKSwift.xcworkspace``` file in Xcode  
4. Compile and run 

## Setup Service

We provide extensive documentation on Github but if you’re a non-technical user or want to save yourself some work you can take advantage of our [setup and integration service](http://chatsdk.co/downloads/chat-sdk-setup-service/).

## Explore the Wiki

We have a number of additional guides available on our [Wiki](https://github.com/chat-sdk/chat-sdk-ios/wiki) including:

- [Exploring the Chat SDK Architecture](https://github.com/chat-sdk/chat-sdk-ios/wiki/Exploring-the-Chat-SDK-Architecture)
- [Calculating the cost of different backends](https://github.com/chat-sdk/blog/wiki/Messaging-service-price-comparison)
- [Facebook login setup guide](https://github.com/chat-sdk/chat-sdk-ios/wiki/ChatSDK-iOS:-Facebook-login)
- [Twitter login setup guide](https://github.com/chat-sdk/chat-sdk-ios/wiki/ChatSDK-iOS:-Twitter-Login)

_And more... so check it out!_

## Integration with an existing project
It's easy to integrate the Chat SDK with an existing project. For more detail and a walkthrough video checkout the wiki [here](https://github.com/chat-sdk/chat-sdk-ios/wiki/Chat-SDK-iOS:-Adding-Chat-SDK-to-your-existing-project).

1. Clone the Chat SDK  
2. Add the Chat SDK development pods to your Podfile  

  ```
    pod "ChatSDK", :path => "[Path to ChatSDK folder]"
  ```

  > **Note**  
  > Chat SDK supports push notifications but this requires the installation of an     additional free module. This guide includes the additional steps necessary to setup push notifications. These steps will be marked with a comment. 

  For push notifications you should download the free [BackendlessPushHandler](http://chatsdk.co/downloads/backendless-push-notifications/) module. 

  ```
  pod "ChatSDKCore", :path => "../ChatSDK/ChatSDKCore"
  pod "ChatSDKUI", :path => "../ChatSDK/ChatSDKUI"
  pod "ChatSDKCoreData", :path => "../ChatSDK/ChatSDKCoreData"
  pod "ChatSDKFirebaseAdapter", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  ```
  
  >**Note**
  >Make sure to use the `use_frameworks!` flag in your Podfile. If you want to use the old version which doesn't use dynamic frameworks checkout the `master_no_frameworks` branch. However, you should bear in mind that we are no longer actively developing this branch. 

  >**Note**
  >If you see an error saying that `Firebase.h` can't be found you need to make sure that the framework search path is set correctly. Open the ChatSDKFirebaseAdapter.podspec file and verify that the following path is correct:
  
  ```
  s.user_target_xcconfig = {
      "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/../../ChatSDK/ChatSDKFirebaseAdapter/Frameworks"'
  }
  ```
  
3. Run ```Pod install```  
4. Copy the **GooglerService-Info.plist** file into your main project target folder  
5. Copy the following rows from the demo ChatSDK **Info.plist** file to your project's **Info.plist**  
  1. `chat_sdk` row
  2. `App Transport Security Settings` row
  3. `URL types` row
  4. `FacebookAppID` row
  5. Privacy rows appropriate for your project (location, photo library, microphone, camera etc)
6. Open the **App Delegate** add the following code to initialise the chat

  **Objective C**

  ```
  #import <ChatSDKCore/ChatCore.h>
  #import <ChatSDKUI/ChatUI.h>
  #import <ChatSDKFirebaseAdapter/ChatFirebaseAdapter.h>
  #import <ChatSDKCoreData/ChatCoreData.h>
  ```

  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  // Create a network adapter to communicate with Firebase
  // The network adapter handles network traffic
  [BNetworkManager sharedManager].a = [[BFirebaseNetworkAdapter alloc] init];
    
  // Set the default interface manager
  [BInterfaceManager sharedManager].a = [[BDefaultInterfaceAdapter alloc] init];

  [BStorageManager sharedManager].a = [[BCoreDataManager alloc] init];
  
  // This is the main view that contains the tab bar
  UIViewController * mainViewController = [[BAppTabBarController alloc] initWithNibName:Nil bundle:Nil];

  // Set the login screen
  [BNetworkManager sharedManager].a.auth.challengeViewController = [[BLoginViewController alloc] initWithNibName:Nil bundle:Nil];

  [self.window setRootViewController:mainViewController];
  ```
  
  **Swift**
  
  ```
  import ChatSDKCore
  import ChatSDKUI
  import ChatSDKCoreData
  import ChatSDKFirebaseAdapter
  ```
  
  Add the following code to the start of your didFinishLaunchingWithOptions function:

  ```
  BInterfaceManager.shared().a = BDefaultInterfaceAdapter.init()
  BNetworkManager.shared().a = BFirebaseNetworkAdapter.init()
  BStorageManager.shared().a = BCoreDataManager.init()
  
  let mainViewController = BAppTabBarController.init(nibName: nil, bundle: nil)
  BNetworkManager.shared().a.auth().setChallenge(BLoginViewController.init(nibName: nil, bundle: nil));
        
  self.window = UIWindow.init(frame: UIScreen.main.bounds)
  self.window?.rootViewController = mainViewController;
  self.window?.makeKeyAndVisible();
  ```
  
## Firebase Setup

[Firebase](http://firebase.google.com) is a real-time data and storage service provided by Google. Firebase is free up to around 20k daily active users. 

For full documentation of Firebase configuration checkout the complete guide and walkthrough video [here](https://github.com/chat-sdk/chat-sdk-ios/wiki/Chat-SDK-iOS:-Firebase-Configuration).

**Create a Firebase account**

1. Go to the [Firebase website](https://console.firebase.google.com/) and create an account
2. Create a new project on the dashboard
3. Click on your project and click through to database (left hand menu)
  
**Add Firebase details to your project Info.plist**

1. Open your new project and click database in the left menu
2. Copy the URL at the top of your browser e.g. `https://appname.firebaseio.com/`
3. Modify the URL into the following format: `gs://appname.appspot.com`
4. Copy the modified URL into your plist field: **chat_sdk** -> **firebase** -> **storage_path**
5. Enter a custom `root_path`

  >**Note:**  
  >The root path is the initial path which your ChatSDK data will be stored on Firebase. It allows you to use a single Firebase database for multiple versions of your project. For example you could create a ```/live``` path and a ```/testing``` path. This allows you to test new features without fear of corrupting your current data model.  

**Configure your Firebase iOS App**

1. In your Firebase project, click the cog at the top of the page
2. Select Project settings
3. Click to add an iOS App
4. Enter your BundleID
5. Click through the remaining steps (all this code has already been added)
6. Copy the **GoogleService-Info.plist** into your main project folder (replace the previous one copied from ChatSDK)

  >**Note:**  
  >It is worth opening your downloaded ```GoogleService-Info.plist``` and checking there is an ```API_KEY``` field included. Sometimes Firebase's automatic download doesn’t include this in the plist. To rectify, just re-download the plist from the project settings menu.  


#### Security Rules

Firebase secures your data by allowing you to write rules to govern who can access the database and what can be written. On the Firebase dashboard click **Database** then the **Rules** tab. 

Copy the contents of the **rules.json** file into the rules and click publish. 

## Firebase UI

We've now added support for Firebase UI to the project. To get around some issues with the [Firebase pods](https://github.com/chat-sdk/chat-sdk-ios/wiki/Issues-with-Firebase-Pods), we needed to integrate the Firebase UI code with the Chat SDK. 

To add Firebase UI to your project you need to add the following to your `Podfile`.

```
  pod "ChatSDKFirebaseAdapter/AuthBase", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  pod "ChatSDKFirebaseAdapter/Phone", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  pod "ChatSDKFirebaseAdapter/Database", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  pod "ChatSDKFirebaseAdapter/Twitter", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  pod "ChatSDKFirebaseAdapter/Facebook", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  pod "ChatSDKFirebaseAdapter/Storage", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
  pod "ChatSDKFirebaseAdapter/Google", :path => "../ChatSDK/ChatSDKFirebaseAdapter"
```

To add Firebase UI as the default login provider for the app you should do the following:

1. Import the libraries that you need to the App Delegate header file

  ```
  #import <ChatSDKFirebaseAdapter/FUIAuth.h>
  #import <ChatSDKFirebaseAdapter/FirebaseAuthUI.h>
  #import <ChatSDKFirebaseAdapter/FUIPhoneAuth.h>
  ```
  
2. Implement the `FUIAuthDelegate`

  ```
  @interface AppDelegate : UIResponder <UIApplicationDelegate, FUIAuthDelegate> {
  ```

3. In `didFinishLaunchingWithOptions` setup the providers that you need:

  ```
  FIRAuth * auth = [FIRAuth auth];
  FUIAuth * authUI = [FUIAuth authUIWithAuth:auth];
  
  // This allows us to be notified when authentication finishes
  authUI.delegate = self;

  // Add phone authentication    
  FUIPhoneAuth * phone = [[FUIPhoneAuth alloc] initWithAuthUI:authUI];
    
  // Add the phone provider  
  [authUI setProviders:@[phone]];
  
  FUIAuthPickerViewController * controller = [[FUIAuthPickerViewController alloc] initWithAuthUI:authUI];
  
  // Present the controller as the default authentication controller
  [BNetworkManager sharedManager].a.auth.challengeViewController = [[UINavigationController alloc] initWithRootViewController:controller];
  ```

4. Make sure that you've done the necessary configuration for your login providers - see [instructions](https://github.com/firebase/FirebaseUI-iOS#mandatory-sample-project-configuration) and the Firebase [authentication documentation](https://firebase.google.com/docs/auth/).
5. Finall add the delegate method: 

```
- (void)authUI:(FUIAuth *)authUI
didSignInWithUser:(nullable FIRUser *)user
         error:(nullable NSError *)error {

    if(!error) {
        [user getIDTokenWithCompletion:^(NSString * token, NSError * error) {
            if (!error) {
                
                NSDictionary * loginInfo = @{bLoginTypeKey: @(bAccountTypeCustom),
                                             bLoginCustomToken: token};
                
                [[BNetworkManager sharedManager].a.auth authenticateWithDictionary:loginInfo].thenOnMain(^id(id<PUser> user) {
                    return Nil;
                }, ^id(NSError * error) {
                    // Handle error
                    return Nil;
                });
            }
            else {
                // Handle error
            }
        }];
    }
    else {
        // Handle error
    }
}
```

## Social Login

If you want to log in using Facebook, Twitter and Google Plus you can do that by downloading the Social Login [module](https://chatsdk.co/downloads/firebase-social-login/). The social login installation instructions are available [here](https://github.com/chat-sdk/chat-sdk-ios/blob/master/Docs/Modules/SocialLogin.md). 

## Backendless Set up for push notifications

Push notifications are handled be a separate plugin. To enable push notifications using [Backendless](http://backendless.com/) you can checkout the [push notification guide](https://github.com/chat-sdk/chat-sdk-ios/blob/master/Docs/Modules/Backendless.md). 

Backendless provide 50,000 free pushes per month. 

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

Your project is now set up with the Chat SDK. 

>**Note:**  
>Don’t forget that it is still using many of our test accounts for social media.

You find complete documentation to set these up here.

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

```php
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

let promise = BNetworkManager.shared().a.auth().authenticate(with: dict)
_ = promise!.promiseKitThen().then { (result: Any?) in
    if (result is Error) {
        // Login Failure
    }
    else {
        // Login Success
    }
    return AnyPromise.promiseWithValue(result)
}

```

>**Note:**  
>This code could be added as a static function to the Chat SDK handler class as mentioned above. 

### User integration

The Chat SDK uses CoreData to persist it's data. This includes a user object which is used to store the current user's information. 

Whenever the user updates their details in your app, they should also update the information that is used by Chat SDK. 

```ObjC

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

```ObjC
-(RXPromise *) usersForIndexes: (NSArray *) indexes withValue: (NSString *) value limit: (int) limit userAdded: (void(^)(id<PUser> user)) userAdded;
```

Here you pass in a series of indexes to be used in the search i.e. name, email etc... and a value. It will then return a series of user objects. 

You can also see example implementations of these handlers by looking at the `BFirebaseSearchHandler` class. And also seeing how the method is used in the Chat SDK. 

##### Starting a chat 

To start a chat you can use the core handler. 

```ObjC
-(RXPromise *) createThreadWithUsers: (NSArray *) users
                       threadCreated: (void(^)(NSError * error, id<PThread> thread)) thread;
```
When this method completes, the thread will have been created on Firebase and all the users will have been added. You could then open the thread using the interface adapter. 

```ObjC
UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
```

So a more complete example would look like this:

```ObjC
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

 


