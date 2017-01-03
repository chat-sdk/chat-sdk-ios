##Installation

+ Download and unzip the module
+ Add the folder `ReadReceipts` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`
```
    pod "ChatSDKFirebase/ReadReceipts", :path => "../ChatSDKFirebase"
```
+ Run ```pod install```
+ Add this to the `BModules.h` file:
```
    #import <ChatSDKFirebase/ReadReceipts.h>
```
 + For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)