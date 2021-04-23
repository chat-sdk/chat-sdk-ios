//
//  OptionCellView.swift
//  ChatK!t
//
//  Created by ben3 on 16/04/2021.
//

import Foundation
import UIKit
import CollectionKit

public class OptionBucket {
    var options = [Option]()
    
    public func add(_ option: Option) {
        options.append(option)
    }

    public func isFull() -> Bool {
        return options.count >= OptionBucket.max()
    }
    
    public static func max() -> Int {
        return 4
    }
}

public class Option {
    public let image: UIImage
    public let text: String
    public let onClick: (() -> Void)?
    public init(text: String, image: UIImage, onClick: (() -> Void)? = nil) {
        self.text = text
        self.image = image
        self.onClick = onClick
    }
}

public class BucketCellView: UIView {
    
    var optionViews = [OptionCellView]()
    var onClick: ((Option) -> Void)?
    
    public func addView(_ view: OptionCellView) {
        optionViews.append(view)
        addSubview(view)
        view.keepTopInset.equal = 0
        view.keepBottomInset.equal = 0
    }
    
    public func bind(bucket: OptionBucket) {
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
                
                let view: OptionCellView = .fromNib()
                view.background.layer.cornerRadius = 5
                view.background.backgroundColor = ChatKit.asset(color: ChatKit.config().chatOptionsIconBackgroundColor)
                view.label.textColor = ChatKit.asset(color: ChatKit.config().chatOptionsTextColor)
                view.imageView.tintColor = ChatKit.asset(color: ChatKit.config().chatOptionsIconColor)

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

public class OptionCellView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var background: UIView!
    var gestureRecognizer: UIGestureRecognizer?
    public var onClick: (() -> Void)?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(click))
        addGestureRecognizer(gestureRecognizer!)
    }
    
    @objc public func click() {
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
