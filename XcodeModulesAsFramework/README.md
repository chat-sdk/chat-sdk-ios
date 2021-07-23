First you need to have CocoaPods installed. See installation instructions at: http://www.binpress.com/app/chat-messaging-sdk-for-ios/1644
Open the terminal and run 'pod install'

For a guide on how to add the code to an existing project, please see the integration guide:

https://drive.google.com/folderview?id=0B5yzhtuipbsrRFhzUUpSc0drNlk&usp=sharing

If you need to access extra files from the Chat SDK you need to import them in the ChatSDK-Bridging-Header.h file.

Instructions to enable Swift:

1. Create a new file called [project name]-Bridging-Header.h
2. Set this file in the Build Settings -> Objective-C Bridging Header. Note that this path should be relative to your .xcodeproj file
3. Add the necessary imports to this header - they will be available to your Swift project

