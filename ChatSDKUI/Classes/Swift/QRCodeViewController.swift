//
//  QRCodeViewController.swift
//  AFNetworking
//
//  Created by ben3 on 13/07/2020.
//

import Foundation
import UIKit
import ChatSDK
import EFQRCode

public class QRCodeViewController: UIViewController {
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var copyButton: UIImageView!
    
    var qrImage: UIImage?
    var code: String?
    
    public init() {
        super.init(nibName: "QRCodeViewController", bundle: Bundle.ui())
    }
    
    public required init?(coder: NSCoder) {
        super.init(nibName: "QRCodeViewController", bundle: Bundle.ui())
    }
    
    @objc public func setCode(code: String) {
        self.code = code
        if let image = EFQRCode.generate(content: code, watermark: BChatSDK.config()?.logoImage?.cgImage) {
            qrImage = UIImage(cgImage: image)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImageView.image = qrImage
        textView.text = code
    }
    
    @IBAction func copyButtonPressed(_ sender: Any) {
        UIPasteboard.general.string = textView.text
        view.makeToast("Copied to clipboard!")
    }
    
    @objc public func hideCopyButton() {
        copyButton.isHidden = true
    }

}


