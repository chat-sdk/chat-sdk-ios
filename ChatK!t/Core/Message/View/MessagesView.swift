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
        tableView.dataSource = model

        tableView.rowHeight = UITableView.automaticDimension

                
    }
    
    @objc public func setModel(model: MessagesViewModel) {
        
        assert(self.model == nil, "The model can't be set more than once")
        
        self.model = model
        
        tableView.estimatedRowHeight = model.estimatedRowHeight()

        for registration in model.messageCellRegistrations() {
            tableView.register(registration.nib(), forCellReuseIdentifier: registration.identifier)
        }

    }


    
}
