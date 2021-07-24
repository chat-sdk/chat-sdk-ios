//
//  OptionsKeyboardOverlay.swift
//  ChatK!t
//
//  Created by ben3 on 16/04/2021.
//

import Foundation
import UIKit
import CollectionKit

open class OptionsKeyboardOverlay: UIView, KeyboardOverlay {
    
    public static let key = "options"
    
    var collectionView: CollectionView?
        
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
        collectionView = CollectionView()
        addSubview(collectionView!)
        collectionView?.keepInsets.equal = 0
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    open func setOptions(options: [Option]) {
        
        var buckets = [OptionBucket]()

        var bucket = OptionBucket()
        for option in options {
            if bucket.isFull() {
                buckets.append(bucket)
                bucket = OptionBucket()
            }
            bucket.add(option)
        }
        buckets.append(bucket)
        
        let ss = { (index: Int, data: OptionBucket, collectionSize: CGSize) -> CGSize in
            return CGSize(width: self.frame.width, height: self.frame.height / 2)
        }

        let provider = BasicProvider(
            dataSource: ArrayDataSource(data: buckets),
            viewSource: BucketCellView.viewSource(),
            sizeSource: ss
        )
                        
        provider.layout = FlowLayout(spacing: 0, justifyContent: .start).transposed()
        collectionView?.provider = provider
    }
            
    open func reload() {
        collectionView?.reloadData()
    }
    
    open func viewWillLayoutSubviews(view: UIView) {
        reload()
        keepBottomInset.equal = view.safeAreaHeight() + ChatKit.config().chatOptionsBottomMargin
    }
}
