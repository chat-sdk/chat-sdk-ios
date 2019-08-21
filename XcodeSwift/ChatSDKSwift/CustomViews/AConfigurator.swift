//
//  AConfigurator.swift
//  ChatSDKSwift
//
//  Created by ben3 on 21/08/2019.
//  Copyright © 2019 deluge. All rights reserved.
//

import Foundation
import ChatSDK

class AConfigurator : NSObject {
    
    public static func configure () {
        
        BChatSDK.ui()?.setChatViewController({thread in
            return AChatViewController.init(thread: thread)
        })
        BChatSDK.ui()?.setContactsViewController(AContactViewController.init())
        BChatSDK.ui()?.setLoginViewController(ALoginViewController.init())
        BChatSDK.ui()?.setPrivateThreadsViewController(APrivateThreadsViewController.init())
        BChatSDK.ui()?.setPublicThreadsViewController(APublicThreadsViewController.init())
        BChatSDK.ui()?.setProfileViewController({user in
            let controller = UIStoryboard(name: "ADetailedProfile", bundle: nil).instantiateInitialViewController()
            if let controller = controller as? ADetailedProfileTableViewController {
                controller.user = user
            }
            return controller
        })

        
    }
    
}
