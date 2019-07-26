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
/* Two Factor Auth */
//class AppDelegate: UIResponder, UIApplicationDelegate, BTwoFactorAuthDelegate {
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /* Two Factor Auth */
    //var verifyViewController:BVerifyViewController?;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let config = BConfiguration.init();
        config.rootPath = "18_10"
        config.allowUsersToCreatePublicChats = false
        config.googleMapsApiKey = "AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE"
        config.clearDatabaseWhenDataVersionChanges = true
        config.clearDataWhenRootPathChanges = true;
        config.databaseVersion = "2"
        config.loginUsernamePlaceholder = "Email"
        
        // Twitter Setup
        config.twitterApiKey = "Kqprq5b6bVeEfcMAGoHzUmB3I"
        config.twitterSecret = "hPd9HCt3PLnifQFrGHJWi6pSZ5jF7kcHKXuoqB8GJpSDAlVcLq"
        
        // Facebook Setup
        config.facebookAppId = "648056098576150"
        
        // Google Setup
        config.googleClientKey = "1088435112418-4cm46hg39okkf0skj2h5roj1q62anmec.apps.googleusercontent.com"
        
        BChatSDK.initialize(config, app: application, options: launchOptions)

        NM.moderation().on()

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BChatSDK.ui().appTabBarViewController();
        self.window?.makeKeyAndVisible();

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

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    }

}
