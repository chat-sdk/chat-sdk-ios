//
//  AppDelegate.swift
//  ChatSDKSwift
//
//  Created by Benjamin Smiley-andrews on 07/03/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

import UIKit
import ChatSDK
import ChatKit
import ChatSDKXMPP

import ContactBook
import MessageModules
import ChatSDKFirebase

@UIApplicationMain 

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let config = BConfiguration.init();
        config.allowUsersToCreatePublicChats = true
        config.googleMapsApiKey = "YourGoogleStaticMapsAPIKey"
        config.clearDatabaseWhenDataVersionChanges = true
        config.clearDataWhenRootPathChanges = true;
        config.databaseVersion = "2"
        config.loginUsernamePlaceholder = "Email"
        config.messageSelectionEnabled = false
        config.logoImage = UIImage(named: "logo")
        config.xmpp(withDomain: "xmpp.app", hostAddress: "75.119.138.93")

        config.xmppUseHTTP = true
        
//        config.enableMessageModerationTab = true;

        // Uncomment this if you want the user avatar and name before the messages
//        config.nameLabelPosition = bNameLabelPositionTop
//        config.showMessageAvatarAtPosition = bMessagePosFirst
//        config.combineTimeWithNameLabel = true
//        config.messageBubbleMaskLast = "chat_bubble_right_S0.png"
//        config.messageBubbleMaskFirst = "chat_bubble_right_SS.png"
//        config.messageBubbleMaskSingle = "chat_bubble_right_S0.png"

        var modules = [
            BXMPPModule(),
            FirebasePushModule.shared(),
            FirebaseUploadModule.shared(),

            StickerMessageModule.shared(),
            BVideoMessageModule.init(),
            FileMessageModule.init(),
            BAudioMessageModule.init(),
            BContactBookModule.init(),
            AddContactWithQRCodeModule.init(),
            BReachabilityModule.init(),
            XMPPReadReceiptModule(),
            ChatKitModule.shared(),
            GiphyMessageModule(apiKey:"UbNvvVZ72miUV5MiFEbV38ZrsC048xUg"),//"VEd7qFZobZNWYX8QEBoqTjjBMJoa3JY7"
        ]
                
        BChatSDK.initialize(config, app: application, options: launchOptions, modules: modules, networkAdapter: nil, interfaceAdapter: nil)
        
        BChatSDK.acceptLicense(withEmail: "ben@sdk.chat")

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
