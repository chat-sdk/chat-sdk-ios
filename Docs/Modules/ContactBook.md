##Installation

+ Download and unzip the module
+ Add the folder `ContactBook` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/AudioMessages", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Add this to the `BModules.h` file:
```
    #import <ChatSDKFirebase/ContactBook.h>
```
 + For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)