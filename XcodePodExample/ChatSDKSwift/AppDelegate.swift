//
//  AppDelegate.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 07/03/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

import UIKit
import ChatSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = BConfiguration.init();
        config.googleMapsApiKey = "AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE"
        config.rootPath = "pre_1"
        config.allowUsersToCreatePublicChats = false
        config.showUserAvatarsOn1to1Threads = true
        config.allowUsersToCreatePublicChats = true
        config.loginUsernamePlaceholder = "Email"
        config.showEmptyChats = true
        config.clearDataWhenRootPathChanges = true
        config.messagesToLoadPerBatch = 100
        config.messageHistoryDownloadLimit = 100
        config.maxImageDimension = 4000
        
 

//        config.setRemoteConfigValue("MC4CAQAwBQYDK2VwBCIEIFrI4pSMCz8DOo/EXrB/HC4UAwS/PsqAjrKB7bdcMPz3", forKey: "private-key")
        // Public key: MCowBQYDK2VwAyEAjBPW4rDT51sFF8nQRbYAZ7pD5xCCDL+kxfAQhVktWrk=
        
//        config.clientPushEnabled = true;
        
        
        BChatSDK.initialize(config, app: application, options: launchOptions)
//        BDiagnosticModule().activate()
        
//      _ = BChatSDK.auth()?.authenticate()?.thenOnMain({ success in
//          // Success
//           return nil
//       }, { error in
//           // Error
//           return nil
//       })
        
                
        /*
         * Module Setup - http://chatsdk.co/modules-2
         */
        
//        let auth = FUIAuth.init(uiWith: Auth.auth())
//        BFirebaseUIModule.init().activate(withProviders: [FUIPhoneAuth.init(authUI: auth!)]);

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BChatSDK.ui()?.splashScreenNavigationController()
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
