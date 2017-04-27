## Installation

+ Download and unzip the module
+ Drag the files into your Xcode project. Because of problems with the vendor frameworks not supporting dynamic frameworks, it's not possible for us to provide this code in the form of a developer pod. 

+ Add the following lines to your `Podfile`:

  ```
  pod 'GoogleSignIn'
  pod 'TwitterKit'
  pod 'FBSDKLoginKit'
  ```
  
+ Open the App delegate and add the following code:

  **Objective C**
  
  ```
  #import "BFirebaseSocialLoginHandler.h"
  ```
   
  At the end of `didFinishLaunchingWithOptions` after all the Chat SDK setup code:
  
  ```
  [BNetworkManager sharedManager].a.socialLogin = [[BFirebaseSocialLoginHandler alloc] init];
  [[BNetworkManager sharedManager].a.socialLogin application: application didFinishLaunchingWithOptions:launchOptions];
 ```
  
  **Swift**
  
  At the end of `didFinishLaunchingWithOptions` after all the Chat SDK setup code:
  
  ```
  BNetworkManager.shared().a.setSocialLogin(BFirebaseSocialLoginHandler.init())
  BNetworkManager.shared().a.socialLogin().application(application, didFinishLaunchingWithOptions: launchOptions)
  ```
  
  Add this to the `ChatSDK-Bridging-Header.h`
  
  ```
  #import "BFirebaseSocialLoginHandler.h"
  ```
  
+ Follow the social login setup steps outlined in the [Github Wiki](https://github.com/chat-sdk/chat-sdk-ios/wiki).