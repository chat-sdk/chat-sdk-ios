//
//  PMessagesView.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation

public protocol PMessagesView {
    
    func insertItems(at: [IndexPath], completion: ((Bool) -> Void)?)
    func updateItems(at: [IndexPath], completion: ((Bool) -> Void)?)
    func scrollToBottom(animated: Bool, force: Bool)
//    func addMessage(toEnd: Message)
//    func addMessages(toStart: [Message])
//    func addMessages(toEnd: [Message])
//    func removeMessage( _message: Message)
//    func removeMessages( _message: [Message])
//    func updateMessage(_ message: Message)

}
