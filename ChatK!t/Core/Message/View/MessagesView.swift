//
//  ChatView.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout

public class MessagesView: UIView, UITableViewDelegate {
    
    public var _tableView = UITableView()
    public var _model: MessagesModel?
    
    public var _longPressRecognizer: UIGestureRecognizer?
    public var _tapRecognizer: UIGestureRecognizer?
    public var _selectedIndexPaths: Set<IndexPath> = []
    
    public var _hideKeyboardListener: (() -> Void)?
    
    // This is used to preseve the Y position when we change the table insets
    public var _bottomYClearance: CGFloat = 0
        
    // Message selection
    public var _selectionModeIsEnabled = false
    
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
        
        addSubview(_tableView)
        
        _tableView.keepInsets.equal = 0
        _tableView.allowsSelection = false
        _tableView.showsVerticalScrollIndicator = false
        
        _tableView.delegate = self

        _tableView.rowHeight = UITableView.automaticDimension
        
        // Hide the dividers between cells
        _tableView.separatorColor = .clear
        
        _longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        _tableView.addGestureRecognizer(_longPressRecognizer!)

        _tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        _tableView.addGestureRecognizer(_tapRecognizer!)

    }
    
    public func setModel(model: MessagesModel) {
        
        assert(_model == nil, "The model can't be set more than once")
        
        _model = model
        model.setView(self)

        _tableView.dataSource = model
        _tableView.estimatedRowHeight = model.estimatedRowHeight()

        for registration in model.messageCellRegistrations() {
            _tableView.register(registration.nib(direction: .incoming), forCellReuseIdentifier: registration.identifier(direction: .incoming))
            _tableView.register(registration.nib(direction: .outgoing), forCellReuseIdentifier: registration.identifier(direction: .outgoing))
        }
        _tableView.register(model.sectionNib(), forCellReuseIdentifier: model.sectionIdentifier())

    }
    
    public func selectionModeEnabled() -> Bool {
        return _selectionModeIsEnabled;
    }
    
    public func willSetBottomInset() {
        // Save the scroll percentage
        let tableViewHeight = _tableView.frame.height - _tableView.contentInset.bottom - _tableView.contentInset.top
        let contentHeight = _tableView.contentSize.height
        _bottomYClearance = contentHeight - (_tableView.contentOffset.y + tableViewHeight)
    }
    
    public func setBottomInset(height: CGFloat) {
        var insets = _tableView.contentInset
        insets.bottom = height
        _tableView.contentInset = insets
        _tableView.scrollIndicatorInsets = insets

        let tableViewHeight = _tableView.frame.height - _tableView.contentInset.bottom - _tableView.contentInset.top
        let contentHeight = _tableView.contentSize.height

        // Apply the bottom clearance
        _tableView.contentOffset.y = contentHeight - _bottomYClearance - tableViewHeight

    }
    
    @objc public func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && !isSelectionModeEnabled() {
            let point = sender.location(in: _tableView)
            if let path = _tableView.indexPathForRow(at: point) {
                select(path)
            }
        }
    }

    @objc public func onTap(_ sender: UITapGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && isSelectionModeEnabled() {
            let point = sender.location(in: _tableView)
            if let path = _tableView.indexPathForRow(at: point) {
                if isSelected(path) {
                    deselect(path)
                } else {
                    select(path)
                }
            }
        } else {
            _hideKeyboardListener?()
        }
    }

    public func isSelected(_ path: IndexPath) -> Bool {
        return _selectedIndexPaths.contains(path)
    }
    
    public func isSelectionModeEnabled() -> Bool {
        return !_selectedIndexPaths.isEmpty
    }
    
    public func select(_ path: IndexPath) {
        if(!isSelected(path)) {
            _selectedIndexPaths.insert(path)
            notifySelectionChange()
            _tableView.reloadRows(at: [path], with: .none)
        }
    }
    
    public func deselect(_ path: IndexPath) {
        if(isSelected(path)) {
            _selectedIndexPaths.remove(path)
            notifySelectionChange()
            _tableView.reloadRows(at: [path], with: .none)
        }
    }
    
    public func clearSelection() {
        if !_selectedIndexPaths.isEmpty {
            let rows = Array(_selectedIndexPaths)
            _selectedIndexPaths.removeAll()
            notifySelectionChange()
            _tableView.reloadRows(at: rows, with: .none)
        }
    }
    
    public func notifySelectionChange() {
        _model?.selectionChanged(paths: _selectedIndexPaths)
    }
    


    
}

extension MessagesView: PMessagesView {
    public func insertItems(at: [IndexPath], completion: ((Bool) -> Void)? = nil) {
        _tableView.performBatchUpdates({ [weak self] in
            self?._tableView.insertRows(at: at, with: .none)
        }, completion: completion)
    }

    public func updateItems(at: [IndexPath], completion: ((Bool) -> Void)? = nil) {
        _tableView.performBatchUpdates({ [weak self] in
            self?._tableView.reloadRows(at: at, with: .none)
        }, completion: completion)
    }
    public func scrollToBottom(animated: Bool = true, force: Bool = false) {
        let row = _tableView.numberOfRows(inSection: 0) - 1
        if row < 0 {
            return
        }
        
        let scroll = _tableView.contentSize.height - _tableView.frame.height - _tableView.contentOffset.y <= ChatKit.config().messagesViewRefreshHeight
        
        if scroll || force {
            let indexPath = IndexPath(row: row, section: 0)
            _tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
//    public func addMessage(toStart: Message) {
//        _tableView.performBatchUpdates({ [weak self] in
//            let indexPath = IndexPath(row: 0, section: 0)
//            self?._tableView.insertRows(at: [indexPath], with: .none)
//        }, completion: nil)
//     }
    
//    public func addMessage(toEnd: Message) {
//        _tableView.performBatchUpdates({ [weak self] in
//            let indexPath = IndexPath(row: 0, section: 0)
//            self?._tableView.insertRows(at: [indexPath], with: .none)
//        }, completion: nil)
//    }
//
//    public func addMessages(toStart: [Message]) {
//    }
//
//    public func addMessages(toEnd: [Message]) {
//    }
//
//    public func removeMessage(_message: Message) {
//    }
//
//    public func removeMessages(_message: [Message]) {
//    }
//
//    public func updateMessage(_ message: Message) {
//    }
}
