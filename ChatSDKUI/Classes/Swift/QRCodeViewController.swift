//
//  QRCodeViewController.swift

//
//  Created by ben3 on 13/07/2020.
//

import Foundation
import UIKit
import EFQRCode

public class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var copyButton: UIImageView!
    
    @objc public var qrImage: UIImage?
    @objc public var style: UIImage?
    @objc public var code: String?
    
    public init(image: UIImage?) {
        super.init(nibName: "QRCodeViewController", bundle: Bundle.ui())
        style = image
    }
    
    public init() {
        super.init(nibName: "QRCodeViewController", bundle: Bundle.ui())
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func setCode(code: String) {
        self.code = code
        
//        let generator = if let image = style?.cgImage {
//            try? EFQRCode.notGenerator(code, style: .image(
//                params: .init(image: .init(image: .static(image: image), allowTransparent: true)))
//            )
//        } else {
//            try? EFQRCode.Generator(code, style: .basic(params: .init()))
//        }
//
//        if let image = try? generator?.toImage(width: 360).cgImage {
//            qrImage = UIImage(cgImage: image)
//            print("Create QRCode image success \(image)")
//        } else {
//            print("Create QRCode image failed!")
//        }
        
        var generator: EFQRCode.Generator?

        if let image = style?.cgImage {
            generator = try? EFQRCode.Generator(
                code,
                style: .image(params: .init(image: .init(image: .static(image: image),
                                                         allowTransparent: true)))
            )
        } else {
            generator = try? EFQRCode.Generator(
                code,
                style: .basic(params: .init())
            )
        }

        if let cgImage = try? generator?.toImage(width: 360).cgImage {
            qrImage = UIImage(cgImage: cgImage)
            print("Create QRCode image success \(cgImage)")
        } else {
            print("Create QRCode image failed!")
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImageView.image = qrImage
        textView.text = code
        
        let version = ProcessInfo.processInfo.operatingSystemVersion;
        if (version.majorVersion < 13 || BChatSDK.config().alwaysShowBackButtonOnModalViews) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: Bundle.t(bBack), style: .plain, target: self, action: #selector(back))
        }
        
        textView.isUserInteractionEnabled = false

    }
    
    @objc public func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyButtonPressed(_ sender: Any) {
        UIPasteboard.general.string = textView.text
        view.makeToast(Bundle.t(bCopiedToClipboard))
    }
    
    @objc public func hideCopyButton() {
        copyButton.isHidden = true
    }

}


