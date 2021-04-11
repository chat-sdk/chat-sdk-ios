//
//  ChatView.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout
import LoremIpsum

public class MessagesView: UIView, UITableViewDelegate {
    
    var tableView = UITableView()
    var model: MessagesViewModel?
        
    // Message selection
    var selectionModeIsEnabled = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public convenience required init?(coder: NSCoder) {
        self.init()
    }

    public func setup() {
        
        addSubview(tableView)
        
        tableView.keepInsets.equal = 0

        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        
        // Hide the dividers between cells
        tableView.separatorColor = .clear
                
    }
    
    public func setModel(model: MessagesViewModel) {
        
        assert(self.model == nil, "The model can't be set more than once")
        
        self.model = model

        tableView.dataSource = model
        tableView.estimatedRowHeight = model.estimatedRowHeight()

        for registration in model.messageCellRegistrations() {
            tableView.register(registration.nib(direction: .incoming), forCellReuseIdentifier: registration.identifier(direction: .incoming))
            tableView.register(registration.nib(direction: .outgoing), forCellReuseIdentifier: registration.identifier(direction: .outgoing))
        }

    }
    
    public func selectionModeEnabled() -> Bool {
        return selectionModeIsEnabled;
    }
    
}
