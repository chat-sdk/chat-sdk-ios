## Installation

+ Download and unzip the module
+ Add the folder `TypingIndicator` to `ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/TypingIndicator", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
  #import <ChatSDKFirebase/TypingIndicator.h>
  ```
   
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  [[[BTypingIndicatorModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKFirebase
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BTypingIndicatorModule.init().activate()
  ```

+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)
