//
//  PMessagesView.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation

public protocol PMessagesView {
    
    func scrollToBottom(animated: Bool, force: Bool)
    func clearSelection()
    func updateTable(_ update: TableUpdate, completion: ((Bool) -> Void)?)
    func reloadData()

}
