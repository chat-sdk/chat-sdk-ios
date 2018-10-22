# Chat SDK 4.9.0 Migration Guide

In `4.9.0` we made the decision to split the Firebase related code into a separate pod. The reason for this is that the Firebase we want to start slowly tranistioning the project over to Swift and the Firebase dependencies can't be included in dynamic libraries. 

Going forward we will have the following libraries:

`ChatSDK` - Dynamic library which contains core components and UI
`ChatSDKFirebase` - Static library which contains Firebase network adapter and dependencies
`ChatSDKSwift` - As we rewrite the project in Swift, code will be moved to this pod

To make your project compatible with `4.9.0` you will need to do the following:

Update your `Podfile`:

`pod ChatSDK/FirebaseAdapter` becomes `pod ChatSDKFirebase/Adapter`  
`pod ChatSDK/FirebasePush` becomes `pod ChatSDKFirebase/Push`  
`pod ChatSDK/FirebaseFileStorage` becomes `pod ChatSDKFirebase/FileStorage`  
`pod ChatSDK/FirebaseSocialLogin` becomes `pod ChatSDKFirebase/SocialLogin`  

All Firebase pods have been moved to the new `ChatSDKFirebase` pod. 

Imports:

`#import <ChatSDK/FirebaseNetworkAdapther.h>` becomes `#import <ChatSDKFirebase/FirebaseNetworkAdapter.h>`

Any Firebase imports should be updated to reflect the fact that they are now in the `ChatSDKFirebase` module. 

## Push Notifications

We have improved the way that push notifications are handled. To keep using the legacy system, you will need to set:

```
config.clientPushEnabled = true
```

During the configuration stage. Otherwise, you should do the following:

##### Setup Firebase Cloud Functions

To handle push notifications, we use [Firebase Cloud Functions](https://firebase.google.com/docs/functions/). This service allows you to upload a script to Firebase hosting. This script monitors the realtime database and whenever a new messsage is detected, it sends a push notification to the recipient. 

Below is a summary of the steps that are required to setup push using the FCF script. For further instructions you can look at the [Firebase Documentation](https://firebase.google.com/docs/functions/get-started). 

1. Run `firebase login` and login using the browser
2. Make a new directory to store your push functions in. It can be called anything
3. Navigate to that directory using the terminal
4. Run `firebase init functions`
5. Choose the correct app from the list
6. Choose `JavaScript`
7. Choose `y` for ESLint
8. Choose `Y` to install node dependencies
9. Find the `functions` directory you've just created and copy the `index.js` file from Github into the directory
10. Run `firebase deploy --only functions:pushListener` 

Now the script is active and push notifications will be set out automatically. 

