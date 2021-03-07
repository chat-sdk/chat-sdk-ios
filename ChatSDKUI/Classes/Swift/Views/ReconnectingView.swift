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
    var status: bConnectionStatus?
   
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
        
        BChatSDK.hook().add(BHook(onMain: { [weak self] dict in
            self?.update()
        }), withName: bHookServerConnectionStatusUpdated)
        
        update()
                
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGestureRecognizer!)
        
    }
    
    @objc public func update() {
        if let connStatus = BChatSDK.core().connectionStatus?() {
            if connStatus != status {
                
                label?.isHidden = connStatus == bConnectionStatusNone
                imageView?.isHidden = connStatus == bConnectionStatusNone
                
                print("ReconnectingView: ", connStatus, "last ", status)

                if connStatus == bConnectionStatusConnecting {
                    label?.text = Bundle.t(bConnecting)
                    startBlink()
                    imageView?.image = Bundle.uiImageNamed("icn_20_connecting")
                } else {
                    stopBlink()
                    if connStatus == bConnectionStatusDisconnected {
                        label?.text = Bundle.t(bOffline)
                        imageView?.image = Bundle.uiImageNamed("icn_20_offline")
                    }
                    if connStatus == bConnectionStatusConnected {
                        label?.text = Bundle.t(bOnline)
                        imageView?.image = Bundle.uiImageNamed("icn_20_connected")
                    }
                }
                label?.keepWidth.equal = label?.intrinsicContentSize.width ?? 130
            }
            status = connStatus
        } else {
            isHidden = true
        }
    }
    
    @objc public func tap() {
        BChatSDK.core().reconnect?()
    }
    
    public func startBlink() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            self?.imageView?.alpha = 0
        })
    }
    
    public func stopBlink() {
        imageView?.layer.removeAllAnimations()
        imageView?.alpha = 1
    }

}
