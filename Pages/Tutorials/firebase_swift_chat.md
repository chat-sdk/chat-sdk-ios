# Building a mobile messenger using Firebase and Swift

In this tutorial we're going to learn how to build a mobile messaging app using Google's [Firebase](http://firebase.google.com) real-time database. 

It will cover the following points:

1. Creating a new Xcode project 
2. Setting up your Firebase account and adding Firebase to the project. 
3. User authentication
4. Adding a simple group chat room using UI components from the Chat SDK

## Part 1 Creating a new Xcode project

Open up Xcode and click **File -> Project -> Single View Application**

Call the project "FirebaseGroupChat" and make sure that you have selected Swift as the language. 

Next we will need to install some pods. Make sure that you have Cocoapods installed. If not, you can use this [guide](https://guides.cocoapods.org/using/getting-started.html) to install it.

Add a new file called **Podfile** in the same directory as the `.xcodeproj` file and add the following lines to the file.

```
source 'https://github.com/CocoaPods/Specs.git'

target 'FirebaseGroupChat' do
  
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
	
end
```

This will add a dependency for the Firebase libraries. 

While we're working with the Podfile, we need to add some extra dependencies. 

Building a chat app involves building quite a bit of user interface, so to save time, we'll be using the UI components from the Chat SDK Github project. 

Using the terminal, navigate to your project directory using the `cd` command. i.e. `cd ../path/to/your/Xcode project`

Then run the following command.

```
git clone https://github.com/chat-sdk/chat-sdk-ios.git
```

Alternatively, you can download the project manually [here](https://github.com/chat-sdk/chat-sdk-ios/archive/master.zip). 

Now your project folder should look like this:

```
chat-sdk-ios/
FirebaseGroupChat/
FirebaseGroupChat.xcodeproj
Podfile
```

Now we're going to add the Chat SDK to our project using the Podfile. Add the following lines:

```
    pod 'ChatSDK/Core', :path => 'chat-sdk-ios'
    pod 'ChatSDK/ChatUI', :path => 'chat-sdk-ios'
```

Then in the terminal run the command.

```
pod install
```

This will install Firebase and the Chat SDK UI components. Close Xcode and open the new **FirebaseGroupChat.xcworkspace** file that has been created. 

The Chat SDK is written in Objective-C which means that we need to add a little bit of configuration to allow the Chat SDK classes to be called by our Swift code. 

In Xcode create a new **Header file** called **FirebaseGroupChat-Bridging-Header**. 

Then click the **FirebaseGroupChat** header in the left navigation panel and click **Build Settings**. In the search bar type "bridging" and it will display the **Objective-C Bridging Header** setting. Enter the link to the header file you created.

```
FirebaseGroupChat/FirebaseGroupChat-Bridging-Header.h
```

Now add the following lines to the bridging header file.

```
#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>
```

There are a couple of setup steps left to complete. Open the **Main.storyboard** file and delete the default view controller. 

Next use the object navigator in the bottom right of the screen to drag a new `Navigation Controller` onto the canvas. By default, you will see two boxes - one is the navigation controller and the other is a table view controller. Click the table view controller and hit delete. 

Using the object navigator drag a View Controller onto the canvas. Right click the navigation controller and drag on to the new View Controller. Click **rootViewController** this will connect the view controller as the root view controller of the navigation controller. 

Now, click the **View Controller Scene** title in the left panel and then use the right Identity Inspector to set the **Class** property. Set this to `ViewController`.

Finally, click the **Navigation Controller** title in the left panel and then in the right Attribute Inspector, check the box **Is Initial View Controller**. 

When the app first loads up, it will inspect the `Info.plist` file and will look at the **Main storyboard file base name** property. This will lead it to load the **Main** storyboard. 

It will then look at the initial view controller to load - in this case the navigation controller we made. When the navigation controller loads, it will display it's root view controller. Finally, when the view controller loads, it will call functions from the class defined in the **Class** property. 


Now run the project to make sure everything is working. If you see any problems, you can download the starter project [here](). 

##Authenticating with Firebase



For this app, we will only allow annonymous login but you could easily add support for other 



