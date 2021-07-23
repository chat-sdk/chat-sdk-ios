//
//  CellSizeCache.swift
//  ChatK!t
//
//  Created by ben3 on 18/05/2021.
//

import Foundation

public class MessageCellSizeCache {
    
    var cells = [String: MessageCell]()
    var heights = [String: CGFloat]()

    public init(_ model: MessagesModel) {
        for registration in model.messageCellRegistrations() {
            addCell(direction: .incoming, registration: registration)
            addCell(direction: .outgoing, registration: registration)
        }
    }
    
    public func addCell(direction: MessageDirection, registration: MessageCellRegistration) {
        let cell: MessageCell = .fromNib(nib: registration.nib(direction: direction))
        cell.setContent(content: registration.content(direction: direction))
        cells[registration.identifier(direction: direction)] = cell
    }
    
    public func heightForIndexPath(_ message: AbstractMessage, model: MessagesModel, width: CGFloat) -> CGFloat? {
        if let height = heights[message.messageId()] {
            return height
        } else if let identifier = model.cellRegistration(message.messageType())?.identifier(direction: message.messageDirection()), let cell = cells[identifier] {
            cell.bind(message, model: model)
            let height = cell.systemLayoutSizeFitting(CGSize(width: width, height: 100)).height
            heights[message.messageId()] = height
            return height
        }
        return nil
    }

}
