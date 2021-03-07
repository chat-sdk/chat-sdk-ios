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
        if let image = EFQRCode.generate(content: code, watermark: style?.cgImage) {
            qrImage = UIImage(cgImage: image)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImageView.image = qrImage
        textView.text = code
        
        if #available(iOS 13.0, *) {
        } else {
//            if presentingViewController != nil {
                navigationItem.leftBarButtonItem = UIBarButtonItem(title: Bundle.t(bBack), style: .plain, target: self, action: #selector(back))
//            }
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


