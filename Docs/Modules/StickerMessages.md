##Installation

+ Download and unzip the module
+ Add the folder `StickerMessages` to `ChatSDK/ChatSDKModules`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKModules/StickerMessages", :path => "../ChatSDKModules"
```
+ Run ```pod install```
+ Add this to the `BModules.h` file:
```
#import <ChatSDKModules/StickerMessages.h>
```
+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)