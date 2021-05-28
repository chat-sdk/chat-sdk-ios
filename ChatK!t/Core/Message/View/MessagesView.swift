//
//  ChatView.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation
import UIKit
import KeepLayout
import RxSwift

public class MessagesView: UIView {
    
    public enum RefreshState {
        case none
        case willLoad
        case loading
        case loaded
    }
    
    public var _tableView = UITableView()
    public var _model: MessagesModel?
    public var _lazyReloadManager: LazyReloadManager?
    
    public var _longPressRecognizer: UIGestureRecognizer?
    public var _tapRecognizer: UIGestureRecognizer?
    public var _refreshControl: UIRefreshControl?
    
    public var _refreshState: RefreshState = .none
    public var _loadedMessages: [Message]?
    
    public var _hideKeyboardListener: (() -> Void)?
    
    // This is used to preseve the Y position when we change the table insets
    public var _bottomYClearance: CGFloat = 0
    
    public var _datasource: UITableViewDiffableDataSource<Section, Message>?
    
    public var _messageCellSizeCache: MessageCellSizeCache?
            
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
        
        _refreshControl = UIRefreshControl()
        _refreshControl?.addTarget(self, action: #selector(startLoading), for: .valueChanged)
        _tableView.addSubview(_refreshControl!)
        

    }
    
    @objc public func startLoading() {
        _refreshState = .willLoad
        _tableView.isUserInteractionEnabled = false
    }
    
    @objc public func loadMoreMessages() {
        _refreshState = .loading
        _ = _model?.loadMessages().subscribe(onSuccess: { [weak self] messages in
            self?._loadedMessages = messages
            self?._refreshState = .loaded
            self?._refreshControl?.endRefreshing()
        }, onFailure: { [weak self] error in
            self?._tableView.isUserInteractionEnabled = true
            self?._refreshState = .none
            self?._refreshControl?.endRefreshing()
        })
    }
    
    public func addLoadedMessages() {
        _tableView.isUserInteractionEnabled = true
        _refreshState = .none
        if let messages = _loadedMessages, !messages.isEmpty {
            if let indexPath = _tableView.indexPathsForVisibleRows?.first, let message = _model?.adapter().message(for: indexPath) {
                _ = _model?.addMessages(toStart: messages, animated: false).subscribe(onCompleted: { [weak self] in
                    if let newIndexPath = self?._model?.adapter().indexPath(for: message) {
                        self?._tableView.scrollToRow(at: newIndexPath, at: .top, animated: false)
                    }
                })
            }
        }
    }
    
    public func setModel(model: MessagesModel) {
        
        assert(_model == nil, "The model can't be set more than once")
        
        _model = model
        model.setView(self)
        
        _lazyReloadManager = LazyReloadManager(model, messageAdder: { messages -> Completable? in
            return model.addMessages(toStart: messages, updateView: true, animated: false)
        })

        _datasource = UITableViewDiffableDataSource<Section, Message>(tableView: _tableView) { tableView, indexPath, message in
            let registration = model.cellRegistration(message.messageType())!
            let identifier = registration.identifier(direction: message.messageDirection())
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MessageCell
            cell.setContent(content: registration.content(direction: message.messageDirection()))
            cell.bind(message, model: model)
            return cell
        }
        _datasource?.defaultRowAnimation = .fade

        for registration in model.messageCellRegistrations() {
            _tableView.register(registration.nib(direction: .incoming), forCellReuseIdentifier: registration.identifier(direction: .incoming))
            _tableView.register(registration.nib(direction: .outgoing), forCellReuseIdentifier: registration.identifier(direction: .outgoing))
        }
        _tableView.register(model.sectionNib(), forCellReuseIdentifier: model.sectionIdentifier())
        
        // Add the cell cache
        _messageCellSizeCache = ChatKit.provider().messageCellSizeCache(model)

        _tableView.dataSource = _datasource!

//        _tableView.estimatedRowHeight = model.estimatedRowHeight()
//        _tableView.estimatedSectionHeaderHeight = ChatKit.config().messagesViewSectionHeight

        _tableView.estimatedRowHeight = 0
        _tableView.estimatedSectionHeaderHeight = 0

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

        print("Inset: \(height), Content height: \(contentHeight), Y clearance: \(_bottomYClearance), tableViewHeight: \(tableViewHeight)")
        
//        _bottomYClearance = 0
        // Apply the bottom clearance
        _tableView.contentOffset.y = contentHeight - _bottomYClearance - tableViewHeight

    }
        
    @objc public func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && !isSelectionModeEnabled() {
            let point = sender.location(in: _tableView)
            if let indexPath = _tableView.indexPathForRow(at: point) {
                if let message = _datasource?.itemIdentifier(for: indexPath) {
                    _model?.toggleSelection(message)
                    _ = reload(messages: [message], animated: true).subscribe()
                }
            }
        }
    }

    @objc public func onTap(_ sender: UITapGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && isSelectionModeEnabled() {
            let point = sender.location(in: _tableView)
            if let indexPath = _tableView.indexPathForRow(at: point) {
                if let message = _datasource?.itemIdentifier(for: indexPath) {
                    _model?.toggleSelection(message)
                    _ = reload(messages: [message], animated: true).subscribe()
                }
            }
        } else {
            _hideKeyboardListener?()
        }
    }
    
    public func isSelectionModeEnabled() -> Bool {
        return !(_model?.selectedMessages().isEmpty ?? false)
    }
        
}

extension MessagesView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = _model?.section(for: section) {
            return ChatKit.provider().sectionView(for: section)
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ChatKit.config().messagesViewSectionHeight
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForIndexPath(indexPath)
    }
    
    public func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat {
        var height: CGFloat?
        if let message = _datasource?.itemIdentifier(for: indexPath), let heightCache = _messageCellSizeCache, let model = _model {
            height = heightCache.heightForIndexPath(message, model: model, width: frame.width)
        }
        return height ?? ChatKit.config().estimatedMessageCellHeight
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
                print("Scroll to bottom", row, section)
                let indexPath = IndexPath(row: row, section: section)
//                _tableView.setContentOffset(CGPoint(0, 1000), animated: false)
                _tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }

    public func apply(snapshot: NSDiffableDataSourceSnapshot<Section, Message>, animated: Bool) -> Completable {
        return Completable.create { [weak self] completable in
            self?._datasource?.apply(snapshot, animatingDifferences: animated, completion: {
                completable(.completed)
            })
            return Disposables.create {}
        }
    }
    
    public func reload(messages: [Message], animated: Bool) -> Completable {
        return Completable.create { [weak self] completable in
            if var snapshot = self?._datasource?.snapshot() {
                snapshot.reloadItems(messages)
                self?._datasource?.apply(snapshot, animatingDifferences: animated, completion: {
//                    self?.layout()
                    completable(.completed)
                })
            }
            return Disposables.create {}
        }
    }
    
}

extension MessagesView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _lazyReloadManager?.tableViewDidScroll(_tableView)
        
        let offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        if abs(offset) < 5 && offset != 0 && _refreshState == .willLoad {
            loadMoreMessages()
        }
        if abs(offset) < 1 && offset != 0 && _refreshState == .loaded  {
            addLoadedMessages()
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _lazyReloadManager?.scrollViewWillBeginDragging(scrollView: scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _lazyReloadManager?.scrollViewDidEndDecelerating(scrollView: scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        _lazyReloadManager?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
        
}
