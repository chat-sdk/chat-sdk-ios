//
//  AppDelegate.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 07/03/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

import UIKit
import ChatSDKCore
import ChatSDKUI
import ChatSDKCoreData
import ChatSDKFirebaseAdapter

//import ChatSDKFirebase
//import ChatSDKModules
//import TwoFactorAuth


@UIApplicationMain
/* Two Factor Auth */
//class AppDelegate: UIResponder, UIApplicationDelegate, BTwoFactorAuthDelegate {
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /* Two Factor Auth */
    //var verifyViewController:BVerifyViewController?;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /* Set up main adapters */
        BInterfaceManager.shared().a = BDefaultInterfaceAdapter.init()
        BNetworkManager.shared().a = BFirebaseNetworkAdapter.init()
        BStorageManager.shared().a = BCoreDataManager.init()
        
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
        
        /* Two Factor Authentication */
        //verifyViewController = BVerifyViewController(nibName: nil, bundle: nil)
        //verifyViewController?.delegate = self
        //BNetworkManager.shared().a.auth().setChallenge(verifyViewController)
        
        let mainViewController = BAppTabBarController.init(nibName: nil, bundle: nil)
        BNetworkManager.shared().a.auth().setChallenge(BLoginViewController.init(nibName: nil, bundle: nil));
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = mainViewController;
        self.window?.makeKeyAndVisible();
        
    
        // Override point for customization after application launch.
        return true
    }
    
    /* Start Two Factor Authentication Code */
    
//    func numberVerified(withToken token: String) {
//        let dict = [bLoginTypeKey: bAccountTypeCustom.rawValue, bLoginCustomToken: token] as [String : Any]
//        
//        let promise = BNetworkManager.shared().a.auth().authenticate(with: dict)
//        _ = promise!.promiseKitThen().then { (result: Any?) in
//            
//            if (result is Error) {
//                BTwoFactorAuthUtils.alertWithError((result as! Error).localizedDescription)
//                // Still need to remove the HUD else we get stuck
//                self.authenticationFinished(error: result)
//            }
//            else {
//                self.authenticationFinished(error: nil)
//            }
//
//            return AnyPromise.promiseWithValue(result)
//        }
//    }
//    
//    func authenticationFinished(error: Any?) {
//        if error == nil {
//            verifyViewController?.dismiss(animated: true, completion: {() -> Void in
//                self.verifyViewController?.phoneNumber?.text = ""
//            })
//        }
//        verifyViewController?.hideHUD()
//    }
    
    /* End Two Factor Authentication Code */

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        if(BNetworkManager.shared().a.socialLogin() != nil) {
           BNetworkManager.shared().a.socialLogin().applicationDidBecomeActive(application)
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if (BNetworkManager.shared().a.push() != nil) {
            BNetworkManager.shared().a.push().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if (BNetworkManager.shared().a.push() != nil) {
            BNetworkManager.shared().a.push().application(application, didReceiveRemoteNotification: userInfo)
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if(BNetworkManager.shared().a.socialLogin() != nil) {
            return BNetworkManager.shared().a.socialLogin().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        return false
    }

}

