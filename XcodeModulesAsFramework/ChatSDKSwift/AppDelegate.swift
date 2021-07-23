//
//  AppDelegate.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 07/03/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

import UIKit
import ChatSDK
import ChatSDKModules
import ChatSDKFirebase
import UserNotifications
//import ChatKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var chatKit: ChatKitModule?
//    var clank: Clank?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = BConfiguration.init();
        config.googleMapsApiKey = "AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE"
        config.rootPath = "pre_3"
        config.logoImage = Icons.get(name: "icn_120_main")
        config.allowUsersToCreatePublicChats = false
        config.showUserAvatarsOn1to1Threads = true
        config.allowUsersToCreatePublicChats = true
        config.loginUsernamePlaceholder = "Email"
        config.showEmptyChats = true
        config.clearDataWhenRootPathChanges = true
        config.messagesToLoadPerBatch = 20
        config.messageHistoryDownloadLimit = 100
        config.maxImageDimension = 4000
        config.messageSelectionEnabled = true
        
        let modules = [
            FirebaseNetworkAdapterModule.shared(),
            FirebaseUploadModule.init(),
            FirebasePushModule.init(),
            BBlockingModule.init(),
            BReadReceiptsModule.init(),
            BTypingIndicatorModule.init(),
            BLastOnlineModule.init(),
            StickerMessageModule.shared(),
            BVideoMessageModule.init(),
            FileMessageModule.init(),
            BAudioMessageModule.init(),
            BKeyboardOverlayOptionsModule.init(),
//            BNearbyUsersModule.shared(),
            AddContactWithQRCodeModule.init(),
            BReachabilityModule.init(),
//            EncryptionModule.init(),
        ]

        BChatSDK.initialize(config, app: application, options: launchOptions, modules: modules)

//        chatKit = ChatKitModule()
//        chatKit?.activate()
        
//        BChatSDK.ui().setLo
        
//        clank = Clank()

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BChatSDK.ui().splashScreenNavigationController()
        self.window?.makeKeyAndVisible();

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BChatSDK.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BChatSDK.application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return BChatSDK.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    } 
    
}

