//
//  AppDelegate.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 07/03/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

import UIKit
import ChatSDK
import ChatSDKFirebase
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebasePhoneAuthUI
import FirebaseOAuthUI

@UIApplicationMain
/* Two Factor Auth */
//class AppDelegate: UIResponder, UIApplicationDelegate, BTwoFactorAuthDelegate {
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /* Two Factor Auth */
    //var verifyViewController:BVerifyViewController?;

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let config = BConfiguration.init();
        config.rootPath = "pre_1"
        config.allowUsersToCreatePublicChats = false
        config.googleMapsApiKey = "AIzaSyCwwtZrlY9Rl8paM0R6iDNBEit_iexQ1aE"
        config.clearDatabaseWhenDataVersionChanges = true
        config.clearDataWhenRootPathChanges = true;
        config.databaseVersion = "2"
        config.loginUsernamePlaceholder = "Email"
        config.messageSelectionEnabled = false
        config.logoImage = UIImage(named: "logo")

        var modules = [
            FirebaseNetworkAdapterModule.shared(),
            FirebasePushModule.shared(),
            FirebaseUploadModule.shared(),
        ]

        // If you want to use Firebase UI
        let module = FirebaseUIModule.init()
        let authUI = FUIAuth.defaultAuthUI()
        module.setProviders([FUIEmailAuth(), FUIPhoneAuth.init(authUI: authUI!)])
        modules.append(module)
                
        BChatSDK.initialize(config, app: application, options: launchOptions, modules: modules)
        BChatSDK.activateLicense(withEmail: "ben@sdk.chat")

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BChatSDK.ui().splashScreenNavigationController();
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return BChatSDK.application(app, open: url, options: options)
    }

}
