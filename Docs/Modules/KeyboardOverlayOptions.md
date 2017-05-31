## Installation

+ Download and unzip the module
+ Add the folder `KeyboardOverlayOptions` to `ChatSDKModules`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKModules/KeyboardOverlayOptions", :path => "../ChatSDKModules"
```
+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
  #import <ChatSDKModules/KeyboardOverlayOptions.h>
  ```
   
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  [[[BKeyboardOverlayOptionsModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKModules
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BKeyboardOverlayOptionsModule.init().activate()
  ```

+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)
