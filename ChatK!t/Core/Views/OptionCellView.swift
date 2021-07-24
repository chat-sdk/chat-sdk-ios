//
//  OptionCellView.swift
//  ChatK!t
//
//  Created by ben3 on 16/04/2021.
//

import Foundation
import UIKit
import CollectionKit

open class OptionBucket {
    var options = [Option]()
    
    open func add(_ option: Option) {
        options.append(option)
    }

    open func isFull() -> Bool {
        return options.count >= OptionBucket.max()
    }
    
    public static func max() -> Int {
        return 4
    }
}

open class Option {
    public let image: UIImage
    public let text: String
    public let onClick: (() -> Void)?
    public init(text: String, image: UIImage, onClick: (() -> Void)? = nil) {
        self.text = text
        self.image = image
        self.onClick = onClick
    }

    public init(cameraOnClick: (() -> Void)? = nil) {
        self.text = Strings.t(Strings.camera)
        self.image = ChatKit.asset(icon: "icn_100_camera")
        self.onClick = cameraOnClick
    }

    public init(galleryOnClick: (() -> Void)? = nil) {
        self.text = Strings.t(Strings.gallery)
        self.image = ChatKit.asset(icon: "icn_100_gallery")
        self.onClick = galleryOnClick
    }

    public init(locationOnClick: (() -> Void)? = nil) {
        self.text = Strings.t(Strings.location)
        self.image = ChatKit.asset(icon: "icn_100_location")
        self.onClick = locationOnClick
    }

    public init(fileOnClick: (() -> Void)? = nil) {
        self.text = Strings.t(Strings.file)
        self.image = ChatKit.asset(icon: "icn_100_file")
        self.onClick = fileOnClick
    }

    public init(stickerOnClick: (() -> Void)? = nil) {
        self.text = Strings.t(Strings.sticker)
        self.image = ChatKit.asset(icon: "icn_100_sticker")
        self.onClick = stickerOnClick
    }

    public init(videoOnClick: (() -> Void)? = nil) {
        self.text = Strings.t(Strings.video)
        self.image = ChatKit.asset(icon: "icn_100_video")
        self.onClick = videoOnClick
    }

}

open class BucketCellView: UIView {
    
    var optionViews = [OptionCellView]()
    var onClick: ((Option) -> Void)?
    
    open func addView(_ view: OptionCellView) {
        optionViews.append(view)
        addSubview(view)
        view.keepTopInset.equal = 0
        view.keepBottomInset.equal = 0
    }
    
    open func bind(bucket: OptionBucket) {
        for view in optionViews {
            view.isHidden = true
        }
        for i in 0 ..< bucket.options.count {
            let option = bucket.options[i]
            let view = optionViews[i]
            view.imageView.image = option.image.withRenderingMode(.alwaysTemplate)
            view.label.text = option.text
            view.keepWidth.equal = frame.width != 0 ? frame.width / 4 : UIScreen.main.bounds.width / 4
            view.isHidden = false
            view.onClick = {
                option.onClick?()
            }
        }
        setNeedsLayout()
    }
    
    public static func viewSource() -> ViewSource<OptionBucket, BucketCellView> {
        return ClosureViewSource(viewGenerator:{ data, index in
            let bucket = BucketCellView()
            
            var lastView: UIView?
            for i in 0 ..< OptionBucket.max() {
                
                let view = ChatKit.provider().optionCellView()

                bucket.addView(view)
                
                if i == 0 {
                    view.keepLeftInset.equal = 0
                } else if i == OptionBucket.max() {
                    view.keepRightInset.equal = 0
                } else if let last = lastView {
                    view.keepLeftOffsetTo(last)?.equal = 0
                }
                lastView = view
            }
            return bucket
        }, viewUpdater: { (view: BucketCellView, data: OptionBucket, index: Int) in
            view.bind(bucket: data)
        })
    }
    
}

open class OptionCellView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var background: UIView!
    var gestureRecognizer: UIGestureRecognizer?
    open var onClick: (() -> Void)?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(click))
        addGestureRecognizer(gestureRecognizer!)
    }
    
    @objc open func click() {
        onClick?()
    }
    
//    public static func viewSource() -> ViewSource<Option, OptionCellView> {
//        return ClosureViewSource(viewGenerator:{ (Data, Int) in
//            let view: OptionCellView = .fromNib()
//            view.background.layer.cornerRadius = 5
//            view.background.backgroundColor = ChatKit.asset(color: "gray_6")
//            return view
//        }, viewUpdater: { (view: OptionCellView, data: Option, index: Int) in
//            view.imageView.image = data.image
//            view.label.text = data.text
//        })
//    }
//
}
