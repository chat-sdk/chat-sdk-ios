//
//  NavigationCell.swift
//  ChatSDK-ChatUI
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

public class NavigationCell: UITableViewCell {
 
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func bind(row: DNavigationRow) {
        textLabel?.text = row.getTitle()
        accessoryType = .disclosureIndicator
    }
    
}
