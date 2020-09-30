//
//  QRCodeScanner.swift
//  AFNetworking
//
//  Created by ben3 on 16/07/2020.
//

import Foundation

@objc public class AddContactWithQRCodeModule : NSObject, PModule {

    @objc public func activate() {
        BChatSDK.ui()?.addSearch(QRScannerViewController.init(usersToExclude: []), withType: "QRCode", withName: Bundle.t(bQRCode))

        let qrCode = ProfileItem(name: Bundle.t(bQRCode), icon: "icn_36_qr", showFor: nil, executor: {(vc: UIViewController, user: PUser) -> Void in
            let qrCodeViewController = QRCodeViewController.init(image: user.imageAsImage())
            qrCodeViewController.setCode(code: user.entityID())
            vc.present(qrCodeViewController, animated: true, completion: nil)
        })

        let contactSection = ProfileSection(name: Bundle.t(bContact), showFor: {(user: PUser?) -> Bool in
            return true
        })

        contactSection.addItem(item: qrCode)

        ChatSDKUI.shared().addUserProfileSection(section: contactSection)
    }

}
