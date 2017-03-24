## Installation

+ Download and unzip the module
+ Add the folder `NearbyUsers` to `ChatSDK/ChatSDKFirebase`
+ Add the pod to the `Podfile`

  ```
  pod "ChatSDKFirebase/NearbyUsers", :path => "../ChatSDKFirebase"
  pod 'GeoFire', :git => "https://github.com/firebase/geofire-objc.git", :branch => 'master'  
  ```

+ Run ```pod install```


> **Note**  
> The nearby users module overrides the ```InferfaceAdapter```. If you also want to override the interface adapter, you should inherit from ```BGeoFireInterfaceAdapter.h```. 

 + For full instructions see the [Module installation guide](http://chatsdk.co/docs/ios-installing-modules/)