## Installation

+ Download and unzip the module
+ Add the folder `VideoMessages` to `ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/VideoMessages", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
  #import <ChatSDKFirebase/VideoMessages.h>
  ```
   
  At the end of `didFinishLaunchingWithOptions` after all the Chat SDK setup code:
  
  ```
  [[[BVideoMessageModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKFirebase
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BVideoMessageModule.init().activate()
  ``` 
  
+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)
