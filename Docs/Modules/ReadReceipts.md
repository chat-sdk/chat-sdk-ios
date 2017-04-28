## Installation

+ Download and unzip the module
+ Add the folder `ReadReceipts` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/ReadReceipts", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
  #import <ChatSDKFirebase/ReadReceipts.h>
  ```
   
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  [[[BReadReceiptsModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKFirebase
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BReadReceiptsModule.init().activate()
  ```
+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)