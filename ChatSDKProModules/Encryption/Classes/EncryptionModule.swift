//
//  TestInterfaceAdapter.swift
//  ChatSDKSwift
//
//  Created by Ben on 9/28/18.
//  Copyright © 2018 deluge. All rights reserved.
//

import Foundation
import ChatSDK
import UIKit
import AVFoundation
import QRCodeReader
import Licensing

open class EncryptionModule : NSObject, PModule, QRCodeReaderViewControllerDelegate {

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = true
            $0.showSwitchCameraButton = false

            let version = ProcessInfo.processInfo.operatingSystemVersion;
            $0.showCancelButton       = version.majorVersion < 13
            $0.showOverlayView        = true
//            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    var currentViewController: UIViewController?
    var newKeyPair: String?

    public func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        reader.dismiss(animated: true, completion: nil)

        if let vc = currentViewController {
            newKeyPair = result.value
            confirmationDialog(vc: vc)
        }
    }
    
    public func readerDidCancel(_ reader: QRCodeReaderViewController) {
    }

    open func activate() {
        
        Licensing.shared().add(item: String(describing: self))
                
        BChatSDK.shared().networkAdapter.setEncryption(EncryptionHandler())
        
//        let authHook = BHook.init({ dict in
//            BChatSDK.encryption()?.publishKey()
//        })
//        _ = BChatSDK.hook().add(authHook, withName: bHookDidAuthenticate)
        
        let exportKey = ProfileItem(name: Bundle.t(bExportKeys), icon: "icn_36_export", showFor: { (user: PUser?) -> Bool in
            return user?.isMe() ?? false
        }, executor: {(vc: UIViewController, user: PUser) -> Void in
            let qrCodeViewController = QRCodeViewController.init()
           
            do {
                let keyPair = try EncryptionHandler.exportKeyPair()
                qrCodeViewController.setCode(code: keyPair)

                vc.present(UINavigationController(rootViewController: qrCodeViewController), animated: true, completion: nil)
            } catch {
                self.showError(vc: vc, error.localizedDescription)
            }

        })

        let importKey = ProfileItem(name: Bundle.t(bImportKeys), icon: "icn_36_import", showFor: { (user: PUser?) -> Bool in
            return user?.isMe() ?? false
        },  executor: { [weak self] (vc: UIViewController, user: PUser) -> Void in
            self?.currentViewController = vc
            
            self?.readerVC.delegate = self
            self?.readerVC.modalPresentationStyle = .formSheet
            
            if let reader = self?.readerVC {
                vc.present(reader, animated: true, completion: nil)
            }
        })

        let encryptionSection = ProfileSection(name: Bundle.t(bEncryption), showFor: {(user: PUser?) -> Bool in
            if let user = user {
                return user.isMe()
            }
            return true
        })

        encryptionSection.addItem(item: exportKey)
        encryptionSection.addItem(item: importKey)

        ChatSDKUI.shared().addUserProfileSection(section: encryptionSection)
                
        BChatSDK.hook().add(BHook({ [weak self] dict in
            BChatSDK.encryption()?.publishKey()
        }), withName: bHookDidAuthenticate)

        
    }
    
    public func showError(vc: UIViewController, _ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

    public func confirmationDialog(vc: UIViewController) {
        let alert = UIAlertController(title: "Import Private key?", message: "Warning, your old key will be lost forever!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(sender: UIAlertAction) in
            if let pair = self.newKeyPair {
                do {
                    try EncryptionHandler.importKeyPair(keyPairString: pair)
                    vc.view.makeToast(Bundle.t(bSuccess))
                } catch {
                    if let vc = self.currentViewController {
                        self.showError(vc: vc, error.localizedDescription)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }

}
