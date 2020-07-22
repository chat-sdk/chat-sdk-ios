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

@objc public class MessagesView: UIView, UITableViewDelegate {
    
    var tableView = UITableView()
    var model: MessagesViewModel?
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @objc public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    @objc public convenience required init?(coder: NSCoder) {
        self.init()
    }

    @objc public func setup() {
        
        addSubview(tableView)
        
        tableView.keepInsets.equal = 0

        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        
        // Hide the dividers between cells
        tableView.separatorColor = .clear
                
    }
    
    @objc public func setModel(model: MessagesViewModel) {
        
        assert(self.model == nil, "The model can't be set more than once")
        
        self.model = model

        tableView.dataSource = model
        tableView.estimatedRowHeight = model.estimatedRowHeight()

        for registration in model.messageCellRegistrations() {
            tableView.register(registration.nib(direction: .incoming), forCellReuseIdentifier: registration.identifier(direction: .incoming))
            tableView.register(registration.nib(direction: .outgoing), forCellReuseIdentifier: registration.identifier(direction: .outgoing))
        }

    }
    
}
