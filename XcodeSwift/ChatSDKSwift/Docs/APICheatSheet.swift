//
//  APICheatSheet.swift
//  ChatSDKSwift
//
//  Created by ben3 on 07/01/2021.
//  Copyright © 2021 deluge. All rights reserved.
//

import Foundation
import ChatSDK

public class APICheatSheet {
    
    public func configuration() {
        let config: BConfiguration = BChatSDK.config()
        
        // Example
        config.googleMapsApiKey = "Google Maps API Key"
    }

    public func messagingServerAPI() {
        let networkAdapter: PNetworkAdapter = BChatSDK.shared().networkAdapter
        
        // Core Methods
        let core: PCoreHandler = networkAdapter.core()
        let auth: PAuthenticationHandler = networkAdapter.auth()
        let thread: PThreadHandler = networkAdapter.thread()
        let imageMessage: PImageMessageHandler = networkAdapter.imageMessage()
        let locationMessage: PLocationMessageHandler = networkAdapter.locationMessage()
        let contact: PContactHandler = networkAdapter.contact()
        let search: PSearchHandler = networkAdapter.search()
        let publicThread: PPublicThreadHandler = networkAdapter.publicThread()

        // Free modules
        let push: PPushHandler = networkAdapter.push()
        let upload: PUploadHandler =  networkAdapter.upload()

        // Paid modules
        let videoMessage: PVideoMessageHandler = networkAdapter.videoMessage()
        let audioMessage: PAudioMessageHandler = networkAdapter.audioMessage()
        let typingIndicator: PTypingIndicatorHandler = networkAdapter.typingIndicator()
        let lastOnline: PLastOnlineHandler = networkAdapter.lastOnline()
        let blocking: PBlockingHandler = networkAdapter.blocking()
        let nearbyUsers: PNearbyUsersHandler = networkAdapter.nearbyUsers()
        let readReceipt: PReadReceiptHandler = networkAdapter.readReceipt()
        let stickerMessage: PStickerMessageHandler = networkAdapter.stickerMessage()
        let fileMessage: PFileMessageHandler = networkAdapter.fileMessage()
        let encryption: PEncryptionHandler = networkAdapter.encryption()
        
        // Example
        BChatSDK.config().anonymousLoginEnabled = false
        
        // Push the user's profile data to the server
        BChatSDK.core().pushUser()?.thenOnMain({ success in
            
            return success
        }, { error in
            
            return error
        })
        
        // Get the current user
        let user: PUser = BChatSDK.currentUser();
        
        // Get a user and update their proifle from the server
        let otherUser: PUser = BChatSDK.core().user(forEntityID: "User Entity ID")

        // Login
        BChatSDK.auth().authenticate(BAccountDetails.username("username", password: "password"))?.thenOnMain({ success in
            
            return success
        }, { error in
            
            return error
        })

        // Check if user is logged in
        let isLoggedIn = BChatSDK.auth().isAuthenticated()

        // Log out
        BChatSDK.auth().logout()
        
        // Create thread
        BChatSDK.thread().createThread(withUsers: [otherUser], name: "Name", threadCreated: { error, thread in
          
            // Send a message
            BChatSDK.thread().sendMessage(withText: "Hi", withThreadEntityID: thread?.entityID())

        })
        
        // Get a list of public threads
        let threads = BChatSDK.thread().threads(with: bThreadType1to1)
    }
    
    public func messagingServerNotifications() {

        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: bNotificationLogout), object: nil, queue: nil, using: { notification in
            
        })
        
        BChatSDK.hook().add(BHook.init(onMain: { dict in
            if let message = dict?[bHook_PMessage] as? PMessage {
                print(message.text())
            }
        }, weight: 10), withNames: [bHookMessageRecieved, bHookMessageWillSend])

        
    }
    
    public func uiService() {
        
        let interfaceAdapter: PInterfaceAdapter = BChatSDK.ui()


        // Override the chat view controller
        BChatSDK.ui().setChatViewController({ thread -> UIViewController in
            return AChatViewController.init(thread: thread)
        })

        // Override the private threads tab
        BChatSDK.ui().setPrivateThreadsViewController(APrivateThreadsViewController.init(nibName: nil, bundle: nil))
    }

    public func localDatabase() {
        
        let storageAdapter: PStorageAdapter = BChatSDK.db()
        
        // Create entity
        if let user: PUser = BChatSDK.db().createEntity(bUserEntity) as? PUser {
            
            user.setName("test");
            user.setImageURL("http://something.png")
            
        }

        // Fetch an entity with a given ID
        if let thread: PThread? = BChatSDK.db().fetchEntity(withID: "threadEntityID", withType: bThreadEntity) as? PThread {
            let users = thread?.users()
            let messages = thread?.messagesOrderedByDateNewestFirst()
        }

        // Fetch or create an entity with a given ID
        if let otherUser: PUser = BChatSDK.db().fetchOrCreateEntity(withID: "userEntityID", withType: bUserEntity) as? PUser {
            
        }

        
    }
}
