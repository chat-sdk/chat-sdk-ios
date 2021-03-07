//
//  ButtonCell.swift
//  ChatSDK
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

@objc public class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func bind(row: DButtonRow) {
        title.text = row.title
        if let color = row.color {
            title.textColor = color
        } else {
            if #available(iOS 13.0, *) {
                title.textColor = .label
            } else {
                title.textColor = .black
            }
        }
    }
    
}
