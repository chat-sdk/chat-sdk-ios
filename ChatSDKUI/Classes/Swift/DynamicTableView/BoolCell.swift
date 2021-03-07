//
//  SwitchCell.swift
//  ChatSDK
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

@objc public class BoolCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    var row: DSwitchRow?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        switchControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    public func bind(row: DSwitchRow) {
        switchControl.setOn(row.isSelected(), animated: false)
        title.text = row.getTitle()
        self.row = row
    }
    
    @objc public func valueChanged() {
        row?.onChange(value: switchControl.isOn)
    }
    
}
