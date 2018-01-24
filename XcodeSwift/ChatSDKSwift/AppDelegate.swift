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
        config.rootPath! = "firebase_v4_web_new_4"
        BChatSDK.initialize(config);
        
        /* Set up main adapters */
        BInterfaceManager.shared().a = BDefaultInterfaceAdapter.init()
        BNetworkManager.shared().a = BFirebaseNetworkAdapter.init()
        BStorageManager.shared().a = BCoreDataManager.init()
        
        BFirebaseSocialLoginModule.init().activate(with: application, withOptions: launchOptions);
        BFirebaseFileStorageModule.init().activateForFirebase();
        BFirebasePushModule.init().activateForFirebase(with: application, withOptions: launchOptions);
        
        /* Social Login */
        //BNetworkManager.shared().a.setSocialLogin(BFirebaseSocialLoginHandler.init())
        //BNetworkManager.shared().a.socialLogin().application(application, didFinishLaunchingWithOptions: launchOptions)

        /* Backendless Push Notifications */
        //let pushHandler = BBackendlessPushHandler.init(appKey: BSettingsManager.backendlessAppId(), secretKey: BSettingsManager.backendlessSecretKey(), versionKey: BSettingsManager.backendlessVersionKey())
        //BNetworkManager.shared().a.setPush(pushHandler)
        //BNetworkManager.shared().a.push().registerForPushNotifications(with: application, launchOptions: launchOptions)
        
        /*
         * Module Setup - http://chatsdk.co/modules-2
         */
        
        //BTypingIndicatorModule.init().activate()
        //BVideoMessageModule.init().activate()
        //BAudioMessageModule.init().activate()
        //BReadReceiptsModule.init().activate()
        //BContactBookModule.init().activate()
        //BNearbyUsersModule.init().activate()
        //BKeyboardOverlayOptionsModule.init().activate()
        //BStickerMessageModule.init().activate()
        
        
//        NM.hook().add(BHook.init(function: { (user: [AnyHashable: Any]?) -> Void in
//
//            let block = NM.core().pushUser().thenOnMain;
//            _ = block!({(result: Any?) -> Any? in
//
//                return result
//            }, {(error: Error?) -> Any? in
//
//                return error
//            })
//
//        }), withName: bHookUserAuthFinished)

        
        let mainViewController = BAppTabBarController.init(nibName: nil, bundle: nil)
        NM.auth().setChallenge(BLoginViewController.init(nibName: nil, bundle: nil));
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = mainViewController;
        self.window?.makeKeyAndVisible();
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if (NM.push() != nil) {
            NM.push().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (NM.push() != nil) {
            NM.push().application(application, didReceiveRemoteNotification: userInfo)
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if(BNetworkManager.shared().a.socialLogin() != nil) {
            return NM.socialLogin().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if(NM.socialLogin() != nil) {
            return NM.socialLogin().application(app, open: url, options: options)
        }
        return false
    }
}

