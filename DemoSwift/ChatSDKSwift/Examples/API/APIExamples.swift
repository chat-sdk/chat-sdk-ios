//
//  APIExamples.swift
//  ChatSDKSwift
//
//  Created by ben3 on 10/01/2021.
//  Copyright © 2021 deluge. All rights reserved.
//

import Foundation
import ChatSDK

public class APIExamples {
    
    public func customizeUI() {
        
        // Override the login view controller
        BChatSDK.ui().setLoginViewController(ALoginViewController.init(nibName: nil, bundle: nil))
        
        // Override the chat view controller
        BChatSDK.ui().setChatViewController({ thread -> UIViewController in
            return AChatViewController.init(thread: thread)
        })
        
    }
    
    public func sendImageMessage(image: UIImage, threadEntityID: String) {
        _ = BChatSDK.imageMessage()?.sendMessage(with: image, withThreadEntityID: threadEntityID)?.thenOnMain({ success in
            
            return success
        }, { error in

            return error
        })
    }

    public func sendTextMessage(text: String, threadEntityID: String) {
        _ = BChatSDK.thread().sendMessage(withText: text, withThreadEntityID: threadEntityID)?.thenOnMain({ success in
            
            return success
        }, { error in

            return error
        })
    }
    
    public func listenForSentOrReceivedMessage() {
        
        BChatSDK.hook().add(BHook.init(onMain: { dict in
            if let message = dict?[bHook_PMessage] as? PMessage {
                
            }
        }, weight: 10), withNames: [bHookMessageRecieved, bHookMessageDidSend])
        
    }
    
    public func createThread(name: String, userEntityID: String) {
        BChatSDK.db().perform(onMain: {
            if let user = BChatSDK.db().fetchEntity(withID: userEntityID, withType: bUserEntity) {
                BChatSDK.thread().createThread(withUsers: [user], threadCreated: { error, thread in
                    if let error = error {
                        
                    }
                    if let thread = thread {
                        
                    }
                })
            }
        })
    }
    
    public func openChatActivity(with thread: PThread, parent: UIViewController) {
        if let vc = BChatSDK.ui().chatViewController(with: thread) {
            parent.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /**
     * If you already have a Firebase log in for your app you can setup the
     * Chat SDK by calling the following after you user has authenticated.
     * Calling this method will perform all the necessary setup for the Chat SDK
     */
    public func authenticateWithCachedUserDetails() {
        _ = BChatSDK.auth().authenticate()?.thenOnMain({ success in
            
            return success
        }, { error in
            
            return error
        })
    }
    
    public func getUserAndUpdateProfileFromServer(userEntityID: String) {
        let user = BChatSDK.core().user(forEntityID: userEntityID)
    }
    
    public func customPushHandling() {
        BChatSDK.shared().networkAdapter.setPush(APushHandler())
    }
    
    public func getUnreadMessageCount(thread: PThread) {
        let count = thread.unreadMessageCount()
    }

    

}
