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

        let version = ProcessInfo.processInfo.operatingSystemVersion;
        if (version.majorVersion < 13) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: Bundle.t(bBack), style: .done, target: self, action: #selector(back));
        }

        var contents = [Section]()
        
        if let sections = BChatSDK.ui().settingsSections() as? [SettingsSection] {
            for section in sections {
                var rows = [Row & RowStyle]()
                var options = [OptionRowCompatible]()

                for item in section.items {
                    
                    if let boolItem = item as? BoolSettingsItem {
                        let row = SwitchRow(text: boolItem.title!, detailText: (boolItem.subtitle != nil) ? .subtitle(boolItem.subtitle!) : nil, switchValue: boolItem.getValue(), icon: (boolItem.icon != nil) ? .named(boolItem.icon!) : nil, action: { row in
                            if let row = row as? SwitchRow {
                                item.notify(value: row.switchValue)
                            }
                        })
                        rows.append(row)
                    }
                    if let radioItem = item as? RadioSettingsItem {
                        for key in radioItem.keys {
                            if let name = radioItem.options[key] {
                                let row = OptionRow(text: name, isSelected: radioItem.getValue() == key, action: { row in
                                    if let row = row as? OptionRow {
                                        if row.isSelected {
                                            radioItem.setValue(value: key)
                                        }
                                    }
                                })
                                options.append(row)
                            }
                        }
                    }
                }
                if section.isRadio {
                    contents.append(RadioSection(title: section.title, options: options))
                } else {
                    contents.append(Section(title: section.title, rows: rows))
                }
            }
            tableContents = contents
        }
    }
    
    @objc public func back() {
        dismiss(animated: true, completion: nil)
    }
    
}
