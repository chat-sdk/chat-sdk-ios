## Installation

+ Download and unzip the module
+ Add the folder `ContactBook` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/ContactBook", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
 #import <ChatSDKFirebase/ContactBook.h>
  ```
   
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
    [[[BContactBookModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKFirebase
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BContactBookModule.init().activate()
  ```
+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)