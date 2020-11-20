//
//  ReconnectingView.swift
//  ChatSDK
//
//  Created by ben3 on 21/10/2020.
//

import Foundation
import KeepLayout

@objc public class ReconnectingView : UIView {
    
//    var activityIndicator: UIActivityIndicatorView?
    var imageView: UIImageView?
    var label: UILabel?
    var tapGestureRecognizer: UITapGestureRecognizer?
   
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    @objc public convenience required init?(coder: NSCoder) {
        self.init()
    }
    
    @objc public func setup() {

//        activityIndicator = UIActivityIndicatorView(style: .white)
//        activityIndicator?.startAnimating()
        
        imageView = UIImageView()
        imageView?.image = Bundle.uiImageNamed("icn_20_offline")
        
        label = UILabel()
//        label?.text = Bundle.t(bWaitingForNetwork)
        label?.font = UIFont.systemFont(ofSize: 14)
        label?.textAlignment = .center
        
//        addSubview(activityIndicator!)
        addSubview(imageView!)
        addSubview(label!)
        
//        imageView?.keepLeftInset.equal = 0
//        imageView?.keepLeftInset.equal = 0
//        imageView?.keepTopInset.equal = 0
//        imageView?.keepBottomInset.equal = 0
        
        imageView?.keepVerticallyCentered()
        
        imageView?.keepWidth.equal = 10
        imageView?.keepHeight.equal = 10

        imageView?.keepRightOffsetTo(label!)?.equal = 4

        label?.keepCentered()
        
//        label?.keepRightInset.equal = 0
//        label?.keepTopInset.equal = 0
//        label?.keepBottomInset.equal = 0
        label?.keepWidth.equal = 135
        
//        keepWidth.equal = 190
        keepHeight.equal = 30
        
//        backgroundColor = .red
        
        BChatSDK.hook()?.add(BHook({ [weak self] dict in
            self?.update(status: nil)
        }), withName: bHookServerConnectionStatusUpdated)
        
        update(status:nil)
        
        self.startBlink()
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGestureRecognizer!)
        
    }
    
    @objc public func update(status: String?) {
        DispatchQueue.main.async { [weak self] in
            if let connStatus = BChatSDK.core()?.connectionStatus?() {
//                self.isHidden = status == bConnectionStatusConnected
                
                self?.label?.isHidden = connStatus == bConnectionStatusNone

                if connStatus == bConnectionStatusConnecting {
//                    self.label?.text = Bundle.t(bConnecting)
                    self?.label?.text = Bundle.t(bConnecting)
                    self?.startBlink()
                    self?.imageView?.image = Bundle.uiImageNamed("icn_20_connecting")
                }
                else if connStatus == bConnectionStatusDisconnected {
                    self?.label?.text = Bundle.t(bOffline)
                    self?.stopBlink()
                    self?.imageView?.image = Bundle.uiImageNamed("icn_20_offline")
                }
                else if connStatus == bConnectionStatusConnected {
                    self?.label?.text = Bundle.t(bOnline)
                    self?.stopBlink()
                    self?.imageView?.image = Bundle.uiImageNamed("icn_20_connected")
                }
                self?.label?.keepWidth.equal = self?.label?.intrinsicContentSize.width ?? 130
            } else {
                self?.isHidden = true
            }
        }
    }
    
    @objc public func tap() {
        BChatSDK.core()?.reconnect?()
    }
    
    public func startBlink() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            self?.imageView?.alpha = 0
        })
    }
    
    public func stopBlink() {
        imageView?.alpha = 1
    }

}
