//
//  QRCodeScanner.swift
//  AFNetworking
//
//  Created by ben3 on 16/07/2020.
//

import Foundation

@objc public class AddContactWithQRCodeModule : NSObject, PModule {
    static let instance = AddContactWithQRCodeModule()
    @objc public static func shared() -> AddContactWithQRCodeModule {
        return instance
    }
    
    @objc public var watermark: UIImage?
    @objc public var showWatermark = false

    @objc public func activate() {
        
        BChatSDK.ui().addSearch(QRScannerViewController.init(usersToExclude: []), withType: "QRCode", withName: Bundle.t(bQRCode))

        let qrCode = ProfileItem(name: Bundle.t(bQRCode), icon: "icn_36_qr", showFor: nil, executor: { [weak self] (vc: UIViewController, user: PUser) -> Void in
            let qrCodeViewController = QRCodeViewController.init()
            
            if self?.showWatermark ?? false {
                qrCodeViewController.style = self?.watermark ?? user.imageAsImage() ?? BChatSDK.config().logoImage
            }
            
            qrCodeViewController.setCode(code: user.entityID())
            vc.present(UINavigationController(rootViewController: qrCodeViewController), animated: true, completion: nil)
        })

        let contactSection = ProfileSection(name: Bundle.t(bContact), showFor: {(user: PUser?) -> Bool in
            return true
        })

        contactSection.addItem(item: qrCode)

        ChatSDKUI.shared().addUserProfileSection(section: contactSection)
    }

}

