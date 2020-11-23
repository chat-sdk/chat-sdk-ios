//
//  PasswordChangeViewController.swift
//  AFNetworking
//
//  Created by ben3 on 31/08/2020.
//

import Foundation
import UIKit
import RXPromise

@objc public class PasswordChangeViewController: UIViewController {
    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    
    public var progressHUD: MBProgressHUD?
    
    public var updatePassword: ((String, String) -> RXPromise)?
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "PasswordChangeViewController", bundle: Bundle.ui())
        title = "Change Password"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()


        if #available(iOS 13.0, *) {
            
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Bundle.t(bBack), style: .done, target: self, action: #selector(close))
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc public func updateHUD(message: String) {
        DispatchQueue.main.async { [weak self] in
            if let hud = self?.progressHUD {
                hud.label.text = message
            }
        }
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        if let update = updatePassword, let old = oldPassword.text, let new = newPassword.text, let retype = retypePassword.text {

            // Validation
            if old.isEmpty || new.isEmpty || retype.isEmpty {
                showError(message: "Password fields cannot be empty")
            }
            else if new != retype {
                showError(message: "The retyped password must match your new password")
            } else {
                
                progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
                
                _ = update(old, new).thenOnMain({ [weak self] success in
                    if let view = self?.view {
                        MBProgressHUD.hide(for: view, animated: true)
                        self?.progressHUD = nil
                        self?.dismiss(animated: true, completion: nil)
                    }
                    return nil
                }, { [weak self] error in
                    if let view = self?.view {
                        MBProgressHUD.hide(for: view, animated: true)
                        self?.progressHUD = nil
                        if let error = error {
                            self?.showError(error: error)
                        }
                    }
                    return nil
                })
                
            }
        }
    }

}
