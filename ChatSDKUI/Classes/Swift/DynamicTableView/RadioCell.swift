//
//  RadioCell.swift
//  ChatSDK
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

public class RadioCell: UITableViewCell {
         
    public func bind(row: DRadioRow) {
        if row.isSelected() {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
        textLabel?.text = row.getTitle()
    }
    
}
