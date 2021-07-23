//
//  TestInterfaceAdapter.swift
//  ChatSDKSwift
//
//  Created by Ben on 10/20/17.
//  Copyright © 2017 deluge. All rights reserved.
//

import Foundation
import ChatSDK

class TestInterfaceAdapter: BDefaultInterfaceAdapter {
    
    var privateThreadViewController : BPrivateThreadsViewController?;
    
    override func privateThreadsViewController() -> UIViewController! {
        if(privateThreadViewController == nil) {
            privateThreadViewController = BPrivateThreadsViewController.init()
        }
        return privateThreadViewController;
    }
}
