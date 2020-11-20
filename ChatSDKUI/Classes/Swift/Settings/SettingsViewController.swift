//
//  SettingsViewController.swift
//  AFNetworking
//
//  Created by ben3 on 13/11/2020.
//

import Foundation
import QuickTableViewController

public class SettingsViewController: QuickTableViewController {
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = Bundle.t(bSettings)

        var contents = [Section]()
        
        if let sections = BChatSDK.ui()?.settingsSections() as? [SettingsSection] {
            for section in sections {
                var rows = [Row & RowStyle]()
                
                for item in section.items {
                    
//                    let test = NavigationRow(text: "CellStyle.default", detailText: .none, icon: .named("gear"))
//                    let test2 = NavigationRow(text: "CellStyle", detailText: .value1(".value1"), icon: .named("time"), action: { _ in })
//
//                    let detailText = item.subtitle != nil ?? .subtitle(item.subtitle!) : .none
//                    let icon = item.icon != nil ?? .named(item.icon!) : .none
                    
                    if let boolItem = item as? BoolSettingsItem {
                        
                        let row = SwitchRow(text: boolItem.title, detailText: (boolItem.subtitle != nil) ? .subtitle(boolItem.subtitle!) : nil, switchValue: boolItem.getValue(), icon: (boolItem.icon != nil) ? .named(boolItem.icon!) : nil, action: { row in
                            if let row = row as? SwitchRow {
                                item.notify(value: row.switchValue)
                            }
                        })
//                        rows.append(SwitchRow(text: boolItem.title, detailText: .subtitle(boolItem.subtitle), switchValue: boolItem.getValue(), icon: .named(boolItem.icon), action: { row in
////                            boolItem.setValue(value: row.getV)
//                            print("Test")
//                        }))
                        rows.append(row)
                    }
                }
                contents.append(Section(title: section.title, rows: rows))
            }
            tableContents = contents
        }
    }
    
}
