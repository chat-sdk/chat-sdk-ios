//
//  ChatView.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout

public class MessagesView: UIView {
    
    public var _tableView = UITableView()
    public var _model: MessagesModel?
    
    public var _longPressRecognizer: UIGestureRecognizer?
    public var _tapRecognizer: UIGestureRecognizer?
    
    public var _hideKeyboardListener: (() -> Void)?
    
    // This is used to preseve the Y position when we change the table insets
    public var _bottomYClearance: CGFloat = 0
    
    public var tableUpdateQueue = [TableUpdate]()
    public var tableUpdating = false
            
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
        _tableView.estimatedSectionHeaderHeight = 20

        for registration in model.messageCellRegistrations() {
            _tableView.register(registration.nib(direction: .incoming), forCellReuseIdentifier: registration.identifier(direction: .incoming))
            _tableView.register(registration.nib(direction: .outgoing), forCellReuseIdentifier: registration.identifier(direction: .outgoing))
        }
        _tableView.register(model.sectionNib(), forCellReuseIdentifier: model.sectionIdentifier())

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
    
    public func popTableUpdateQueue() {
        if let update = tableUpdateQueue.first {
            tableUpdateQueue.remove(at: 0)
            updateTable(update)
        }
    }
    
    @objc public func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && !isSelectionModeEnabled() {
            let point = sender.location(in: _tableView)
            if let path = _tableView.indexPathForRow(at: point) {
                _model?.select(indexPaths: [path], updateView: true)
            }
        }
    }

    @objc public func onTap(_ sender: UITapGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && isSelectionModeEnabled() {
            let point = sender.location(in: _tableView)
            if let path = _tableView.indexPathForRow(at: point) {
                if isSelected(path) {
                    _model?.deselect(indexPaths: [path], updateView: true)
                } else {
                    _model?.select(indexPaths: [path], updateView: true)
                }
            }
        } else {
            _hideKeyboardListener?()
        }
    }

    public func isSelected(_ path: IndexPath) -> Bool {
        return _model?.isSelected(path) ?? false
    }
    
    public func isSelectionModeEnabled() -> Bool {
        return !(_model?.selectedIndexPaths().isEmpty ?? false)
    }
        
}

extension MessagesView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = _model?.section(for: section) {
            return ChatKit.provider().sectionView(for: section)
        }
        return nil
    }
}

extension MessagesView: PMessagesView {
    
    public func scrollToBottom(animated: Bool = true, force: Bool = false) {
        if _tableView.numberOfSections > 0 {
            let section = _tableView.numberOfSections - 1
            let row = _tableView.numberOfRows(inSection: section) - 1
            if row < 0 {
                return
            }
            let scroll = _tableView.contentSize.height - _tableView.frame.height - _tableView.contentOffset.y <= ChatKit.config().messagesViewRefreshHeight
            
            if scroll || force {
                let indexPath = IndexPath(row: row, section: section)
                _tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    public func updateTable(_ update: TableUpdate, completion: ((Bool) -> Void)? = nil) {
        if !update.hasChanges() {
            return
        }
        update.log()
        
        if tableUpdating && !update.allowConcurrent {
            tableUpdateQueue.append(update)
        } else {
            tableUpdating = true
            _tableView.performBatchUpdates({ [weak self] in
                if update.type == .add {
                    self?._tableView.insertSections(IndexSet(update.sections), with: update.animation)
                    self?._tableView.insertRows(at: update.indexPaths, with: update.animation)
                }
                if update.type == .remove {
                    if !update.sections.isEmpty {
                        self?._tableView.deleteSections(IndexSet(update.sections), with: update.animation)
                    } else {
                        self?._tableView.deleteRows(at: update.indexPaths, with: update.animation)
                    }
                }
                if update.type == .update {
                    self?._tableView.reloadSections(IndexSet(update.sections), with: update.animation)
                    self?._tableView.reloadRows(at: update.indexPaths, with: update.animation)
                }
            }, completion: { [weak self] success in
                self?.tableUpdating = false
                self?.popTableUpdateQueue()
                completion?(success)
            })
        }
    }
    
    public func reloadData() {
        _tableView.reloadData()
    }

}
