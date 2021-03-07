//
//  Section.swift
//  ChatSDK-ChatUI
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit

@objc public class DSection: NSObject {
    
    let title: String?
    var rows = [DRow]()
    
    public init(title: String? = nil, rows: [DRow]? = nil) {
        self.title = title
        super.init()
        rows?.forEach { addRow(row: $0) }
    }
    
    @objc public func addRow(row: DRow) {
        rows.append(row)
    }
        
    @objc public func getRows() -> [DRow] {
        return rows
    }
    
    @objc public func getTitle() -> String {
        return title ?? ""
    }
}

@objc public class DRadioSection: DSection {
    
    @objc override public func addRow(row: DRow) {
        super.addRow(row: row)
        if let row = row as? DRadioRow {
            row.setSection(section: self)
        }
    }
    
    @objc public func selected(row: DRadioRow) {
        for row in rows {
            if let row = row as? DRadioRow {
                row.deselect()
            }
        }
    }
    
}
