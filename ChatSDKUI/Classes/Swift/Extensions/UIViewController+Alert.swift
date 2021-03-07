//
//  UIViewControllerAlert.swift
//  AFNetworking
//
//  Created by ben3 on 31/08/2020.
//

import Foundation

extension UIViewController {
    public func showError(error: Error, completion: (() -> Void)? = nil) {
        showError(message: error.localizedDescription, completion: completion)
    }
    public func showError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    public func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    public func showAlert(title: String, message: String, accept: (() -> Void)? = nil, reject: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { sender in
            accept?()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { sender in
            reject?()
        }))
        self.present(alert, animated: true, completion: completion)
    }
}
