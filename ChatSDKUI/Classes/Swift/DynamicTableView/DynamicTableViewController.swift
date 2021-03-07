//
//  DynamicTableViewController.swift
//  ChatSDK-ChatUI
//
//  Created by ben3 on 09/01/2021.
//

import Foundation
import UIKit
import KeepLayout

@objc public class DynamicTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var sections = [DSection]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: .zero, style: .grouped)
        
        view.addSubview(tableView)
        tableView.keepInsets.equal = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    public func setSections(sections: [DSection]) {
        self.sections = sections
                
        var nibs = [String: String]()
        var classes = [String: AnyClass]()
        for section in sections {
            for row in section.rows {
                if let nib = row.nibName() {
                    nibs[row.identifier()] = nib
                }
                if let cellType = row.cellType() {
                    classes[row.identifier()] = cellType
                }
            }
        }

        let bundle = Bundle.ui()
        for id in nibs.keys {
            tableView.register(UINib(nibName: nibs[id]!, bundle: bundle), forCellReuseIdentifier: id)
        }
        for id in classes.keys {
            tableView.register(classes[id], forCellReuseIdentifier: id)
        }
        tableView.reloadData()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].getRows().count
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath) ?? UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].getTitle()
    }
    
    public func cell(for indexPath: IndexPath) -> UITableViewCell? {
        let row = sections[indexPath.section].getRows()[indexPath.row]

        var cell = tableView.dequeueReusableCell(withIdentifier: row.identifier())!

        if let navigationRow = row as? DNavigationRow, let cell = cell as? NavigationCell {
            cell.bind(row: navigationRow)
        }
        if let switchRow = row as? DSwitchRow, let cell = cell as? BoolCell {
            cell.bind(row: switchRow)
        }
        if let radioRow = row as? DRadioRow, let cell = cell as? RadioCell {
            cell.bind(row: radioRow)
        }
        if let buttonRow = row as? DButtonRow, let cell = cell as? ButtonCell {
            cell.bind(row: buttonRow)
        }
        cell.selectionStyle = row.isSelectable() ? .default : .none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section].getRows()[indexPath.row]
        if row.isSelectable() {
            if let row = row as? DNavigationRow {
                row.click()
            }
            if let row = row as? DButtonRow {
                row.click()
            }
            if let row = row as? DRadioRow {
                row.click()
//                if let cell = tableView.cellForRow(at: indexPath) {
//                    cell.accessoryType = .checkmark
//                }
//                tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


