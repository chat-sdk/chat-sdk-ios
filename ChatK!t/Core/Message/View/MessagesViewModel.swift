//
//  ChatViewModel.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

@objc public class MessagesViewModel: NSObject, UITableViewDataSource {
    
    let _thread: Thread
    let _messageTimeFormatter = DateFormatter()
    
    var _messages = [CKMessage]()
    
    var _messageCellRegistrations = [String: MessageCellRegistration]()
    
    @objc public init(thread: Thread) {
        _thread = thread
        _messageTimeFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
    }
    
    @objc public func itemCount() -> Int {
        return _thread.threadMessages().count
    }
    
    @objc public func message(indexPath: IndexPath) -> Message {
        return _thread.threadMessages()[indexPath.row]
    }
    
    @objc public func messageTimeFormatter() -> DateFormatter {
        return _messageTimeFormatter
    }
    
    @objc public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messages.count
    }
    
    @objc public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the message
        let message = _messages[indexPath.row]
        
        var cell: UITableViewCell?
        
        // Get the registration so we know which cell identifier to use
        if let registration = _messageCellRegistrations[message.messageType()] {
            cell = tableView.dequeueReusableCell(withIdentifier: registration.identifier)
            if let cell = cell as? MessageCell {
                
            } else {
                
            }
        }

//        if cell == nil {
//        }
//        if let cell = cell as? OutcomingTextMessageCell {
//
//            cell.setMessage(message: messages[indexPath.row], model: self)
//        }
        return cell!
    }
    
    @objc public func registerMessageCell(registration: MessageCellRegistration) {
        _messageCellRegistrations[registration.messageType()] = registration
    }

    @objc public func registerMessageCells(registrations: [MessageCellRegistration]) {
        for registration in registrations {
            registerMessageCell(registration: registration)
        }
    }

    @objc public func messageCellRegistrations() -> [MessageCellRegistration] {
        return _messageCellRegistrations.map { $1 }
    }
    
    @objc public func estimatedRowHeight() -> CGFloat {
        return 44
    }

}

