//
//  FileMessageView.swift
//  ChatK!tExtras
//
//  Created by ben3 on 08/09/2021.
//

import Foundation
import FFCircularProgressView
import ChatKit

open class FileMessageView: UIView {
    
    @IBOutlet open weak var textLabel: UILabel!
    @IBOutlet open weak var progressView: FFCircularProgressView!
    @IBOutlet open weak var imageView: UIImageView!
    
    open var progressHelper: MessageProgressHelper?
        
    open override func awakeFromNib() {
        super.awakeFromNib()
        progressHelper = MessageProgressHelper(progressView)
    }

}
