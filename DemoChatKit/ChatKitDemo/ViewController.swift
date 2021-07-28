//
//  ViewController.swift
//  ChatKitDemo
//
//  Created by ben3 on 27/07/2021.
//

import UIKit
import ChatKit

class ViewController: UIViewController {

    var vc: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vc = ChatKitSetup().chatViewController()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(UINavigationController(rootViewController: vc!), animated: false, completion: nil)
    }


}

