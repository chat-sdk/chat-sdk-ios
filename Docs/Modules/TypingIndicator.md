##Installation

+ Download and unzip the module
+ Add the folder `TypingIndicator` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/TypingIndicator", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Add this to the `BModules.h` file:
```
    #import <ChatSDKFirebase/TypingIndicator.h>
```
 + For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)