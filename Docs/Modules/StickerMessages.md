## Installation

+ Download and unzip the module
+ Add the folder `StickerMessages` to `ChatSDKModules`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKModules/StickerMessages", :path => "../ChatSDKModules"
```
+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
  #import <ChatSDKModules/KeyboardOverlayOptions.h>
  #import <ChatSDKModules/StickerMessages.h>
  ```
   
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  [[[BStickerMessageModule alloc] init] activate];
  [[[BKeyboardOverlayOptionsModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKModules
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BStickerMessageModule.init().activate()
  BKeyboardOverlayOptionsModule.init().activate()
  ```

+ **Important** - you must activate the Sticker Message module before the keyboard overlay module otherwise the sticker option won't be added. This is also the case if you want to add other options. 

+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)
