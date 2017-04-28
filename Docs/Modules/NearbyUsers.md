## Installation

+ Download and unzip the module
+ Add the folder `NearbyUsers` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`

  ```
  pod "ChatSDKFirebase/NearbyUsers", :path => "../ChatSDKFirebase"
  ```

+ Run ```pod install```
+ Open the App delegate and add the following code:

  #### Objective C
  
  ```
  #import <ChatSDKFirebase/NearbyUsers.h>
  ```
   
  At the end of `didFinishLaunchingWithOptions` after all the Chat SDK setup code:
  
  ```
  [[[BNearbyUsersModule alloc] init] activate];
  ```
  
  #### Swift
  
  ```
  import ChatSDKFirebase
  ```
  
  In `didFinishLaunchingWithOptions` after setting up the network and interface adapters:
  
  ```
  BNearbyUsersModule.init().activate()
  ``` 

+ For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)

> **Note:**  
> Currently the Firebase pods don't work with the `use_frameworks!` flag. For this reason, we have to include them manually in the Firebase adapter pod as vendored frameworks. For this reason, we don't include the GeoFire pod it would import the Firebase pods which will cause problems - the libraries will be imported twice. For this reason, we include the GeoFire source code directly in the module. If you want to update GeoFire, just use the terminal to `cd` into the `NearbyUsers/geofire-objc` folder and run `git pull origin master`.
