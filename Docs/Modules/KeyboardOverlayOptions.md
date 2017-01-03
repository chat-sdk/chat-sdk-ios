##Installation

+ Download and unzip the module
+ Add the folder `KeyboardOverlayOptions` to `ChatSDK/ChatSDKModules`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKModules/KeyboardOverlayOptions", :path => "../ChatSDKModules"
```
+ Run ```pod install```
+ Add this to the `BModules.h` file:
```
#import <ChatSDKModules/KeyboardOverlayOptions.h>
```
+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)