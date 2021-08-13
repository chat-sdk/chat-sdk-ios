//
//  CellSizeCache.swift
//  ChatK!t
//
//  Created by ben3 on 18/05/2021.
//

import Foundation

open class MessageCellSizeCache {
    
    var cells = [String: AbstractMessageCell]()

    public init(_ model: MessagesModel) {
        for registration in model.messageCellRegistrations() {
            addCell(direction: .incoming, registration: registration)
            addCell(direction: .outgoing, registration: registration)
        }
    }
    
    open func addCell(direction: MessageDirection, registration: MessageCellRegistration) {
        let cell: AbstractMessageCell = .fromNib(nib: registration.nib(direction: direction))
        cell.setContent(content: registration.content(direction: direction))
        cells[registration.identifier(direction: direction)] = cell
    }
    
    open func heightForIndexPath(_ message: AbstractMessage, model: MessagesModel, width: CGFloat, cache: Bool = true) -> CGFloat? {
        if let height = ChatKit.messageHeightCache().get(message.messageId()) {
            return height
        } else if let identifier = model.cellRegistration(message.messageType())?.identifier(direction: message.messageDirection()), let cell = cells[identifier] {
            cell.bind(message, model: model)
            let size = cell.systemLayoutSizeFitting(CGSize(width: width, height: 100), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let height = size.height
            if cache {
                ChatKit.messageHeightCache().add(message.messageId(), height: height)
            }
            return height
        }
        return nil
    }
    
    open func clear() {
        cells.removeAll()
    }

}

open class MessageHeightCache {

    var heightsPortrait = [String: CGFloat]()
    var heightsLansacape = [String: CGFloat]()

    public init() {
        
    }
    
    open func add(_ messageId: String, height: CGFloat) {
        if UIDevice.current.orientation.isLandscape {
            heightsLansacape[messageId] = height
        } else {
            heightsPortrait[messageId] = height
        }
    }
    
    open func remove(_ messageId: String) {
        heightsPortrait[messageId] = nil
        heightsLansacape[messageId] = nil
    }
    
    open func removeAll() {
        heightsPortrait.removeAll()
        heightsLansacape.removeAll()
    }
    
    open func get(_ messageId: String) -> CGFloat? {
        if UIDevice.current.orientation.isLandscape {
            return heightsLansacape[messageId]
        } else {
            return heightsPortrait[messageId]
        }
    }
}
