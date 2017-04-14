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
//class AppDelegate: UIResponder, UIApplicationDelegate, BTwoFactorAuthDelegate {
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //var verifyViewController:BVerifyViewController?;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //BTwitterHelper.shared()
        
        /* Set up main adapters */
        BInterfaceManager.shared().a = BDefaultInterfaceAdapter.init()
        BNetworkManager.shared().a = BFirebaseNetworkAdapter.init()
        BStorageManager.shared().a = BCoreDataManager.init()

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
        
        self.window?.rootViewController = mainViewController;
        self.window?.makeKeyAndVisible();
        
        
        // Override point for customization after application launch.
        return true
    }
    
    /* Start Two Factor Authentication Code */
//    func numberVerified(withToken token: String) {
//        let dict = [bLoginTypeKey: (bAccountTypeCustom), bLoginCustomToken: token] as [String : Any]
//        
//        let block = BNetworkManager.shared().a.auth().authenticate(with: dict).thenOnMain
//        _ = block!({(user: Any) -> Any? in
//            if(user is PUser) {
//                self.authenticationFinished(with: user as? PUser)
//            }
//            return nil
//        }, {(error: Error?) -> Any? in
//            BTwoFactorAuthUtils.alertWithError(error?.localizedDescription)
//            // Still need to remove the HUD else we get stuck
//            self.authenticationFinished(with: nil)
//            return nil
//        })
//
//    }
//    
//    func authenticationFinished(with user: PUser?) {
//        if user != nil {
//            verifyViewController?.dismiss(animated: true, completion: {() -> Void in
//                self.verifyViewController?.phoneNumber?.text = ""
//            })
//        }
//        verifyViewController?.hideHUD()
//    }
    /* End Two Factor Authentication Code */


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //FBSDKAppEvents.activateApp();
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

