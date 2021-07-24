//
//  SectionCell.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation

open class SectionCell: UIView {
    
    public static let identifier = "section"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.layer.cornerRadius = ChatKit.config().messagesViewSectionViewCornerRadius
        backgroundView.clipsToBounds = true
    }


}
