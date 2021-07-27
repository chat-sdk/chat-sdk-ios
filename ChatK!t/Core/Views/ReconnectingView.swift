//
//  ReconnectingView.swift
//  ChatSDK
//
//  Created by ben3 on 21/10/2020.
//

import Foundation
import KeepLayout

open class ReconnectingView : UIView {
    
    var imageView: UIImageView?
    var label: UILabel?
    var tapGestureRecognizer: UITapGestureRecognizer?
    var status: ConnectionStatus?
   
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience required init?(coder: NSCoder) {
        self.init()
    }
    
    open func setup() {
        
        imageView = UIImageView()
        imageView?.image = ChatKit.asset(icon: "icn_20_offline")
        
        label = UILabel()
//        label?.text = Bundle.t(bWaitingForNetwork)
        label?.font = UIFont.systemFont(ofSize: 14)
        label?.textAlignment = .center
        
//        addSubview(activityIndicator!)
        addSubview(imageView!)
        addSubview(label!)
                
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
                
        update()
                
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGestureRecognizer!)
        
    }
    
    open func update(_ connStatus: ConnectionStatus? = .none) {
        if connStatus != .none {
            isHidden = false
            if connStatus != status {
                                
                if connStatus == .connecting {
                    label?.text = t(Strings.connecting)
                    startBlink()
                    imageView?.image = ChatKit.asset(icon: "icn_20_connecting")
                } else {
                    stopBlink()
                    if connStatus == .disconnected {
                        label?.text = t(Strings.offline)
                        imageView?.image = ChatKit.asset(icon: "icn_20_offline")
                    }
                    if connStatus == .connected {
                        label?.text = t(Strings.online)
                        imageView?.image = ChatKit.asset(icon: "icn_20_connected")
                    }
                }
                label?.keepWidth.equal = label?.intrinsicContentSize.width ?? 130
            }
            status = connStatus
        } else {
            isHidden = true
        }
    }
    
    @objc open func tap() {
    }
    
    open func startBlink() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            self?.imageView?.alpha = 0
        })
    }
    
    open func stopBlink() {
        imageView?.layer.removeAllAnimations()
        imageView?.alpha = 1
    }

}
