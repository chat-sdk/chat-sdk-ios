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
    
    public var tableView = UITableView()
    public var model: MessagesModel?
    public var lazyReloadManager: LazyReloadManager?
    
    public var longPressRecognizer: UIGestureRecognizer?
    public var tapRecognizer: UIGestureRecognizer?
    public var refreshControl: UIRefreshControl?
    
    public var refreshState: RefreshState = .none
    public var loadedMessages: [Message]?
    
    public var hideKeyboardListener: (() -> Void)?
    
    // This is used to preseve the Y position when we change the table insets
    public var bottomYClearance: CGFloat = 0
    
    public var datasource: UITableViewDiffableDataSource<Section, Message>?
    
    public var messageCellSizeCache: MessageCellSizeCache?
            
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
        
        addSubview(tableView)
        
        tableView.keepInsets.equal = 0
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.delegate = self

        tableView.rowHeight = UITableView.automaticDimension
        
        
        // Hide the dividers between cells
        tableView.separatorColor = .clear
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        tableView.addGestureRecognizer(longPressRecognizer!)

        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        tableView.addGestureRecognizer(tapRecognizer!)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(startLoading), for: .valueChanged)
        tableView.addSubview(refreshControl!)
        

    }
    
    @objc public func startLoading() {
        refreshState = .willLoad
        tableView.isUserInteractionEnabled = false
    }
    
    @objc public func loadMoreMessages() {
        refreshState = .loading
        _ = model?.loadMessages().subscribe(onSuccess: { [weak self] messages in
            self?.loadedMessages = messages
            self?.refreshState = .loaded
            self?.refreshControl?.endRefreshing()
        }, onFailure: { [weak self] error in
            self?.tableView.isUserInteractionEnabled = true
            self?.refreshState = .none
            self?.refreshControl?.endRefreshing()
        })
    }
    
    public func addLoadedMessages() {
        tableView.isUserInteractionEnabled = true
        refreshState = .none
        if let messages = loadedMessages, !messages.isEmpty {
            if let indexPath = tableView.indexPathsForVisibleRows?.first, let message = model?.adapter.message(for: indexPath) {
                _ = model?.addMessages(toStart: messages, animated: false).subscribe(onCompleted: { [weak self] in
                    if let newIndexPath = self?.model?.adapter.indexPath(for: message) {
                        self?.tableView.scrollToRow(at: newIndexPath, at: .top, animated: false)
                    }
                })
            }
        }
    }
    
    public func setModel(model: MessagesModel) {
        
        self.model = model
        model.view = self
        
        lazyReloadManager = LazyReloadManager(model, messageAdder: { messages -> Completable? in
            return model.addMessages(toStart: messages, updateView: true, animated: false)
        })

        datasource = UITableViewDiffableDataSource<Section, Message>(tableView: tableView) { tableView, indexPath, message in
            let registration = model.cellRegistration(message.messageType())!
            let identifier = registration.identifier(direction: message.messageDirection())
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MessageCell
            cell.setContent(content: registration.content(direction: message.messageDirection()))
            cell.bind(message, model: model)
            return cell
        }
        datasource?.defaultRowAnimation = .fade

        for registration in model.messageCellRegistrations() {
            tableView.register(registration.nib(direction: .incoming), forCellReuseIdentifier: registration.identifier(direction: .incoming))
            tableView.register(registration.nib(direction: .outgoing), forCellReuseIdentifier: registration.identifier(direction: .outgoing))
        }
        tableView.register(model.sectionNib, forCellReuseIdentifier: model.sectionIdentifier())
        
        // Add the cell cache
        messageCellSizeCache = ChatKit.provider().messageCellSizeCache(model)

        tableView.dataSource = datasource!

//        tableView.estimatedRowHeight = model.estimatedRowHeight()
//        tableView.estimatedSectionHeaderHeight = ChatKit.config().messagesViewSectionHeight

        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0

    }
        
    public func willSetBottomInset() {
        // Save the scroll percentage
        let tableViewHeight = tableView.frame.height - tableView.contentInset.bottom - tableView.contentInset.top
        let contentHeight = tableView.contentSize.height
        bottomYClearance = contentHeight - (tableView.contentOffset.y + tableViewHeight)
    }
    
    public func setBottomInset(height: CGFloat) {

        var insets = tableView.contentInset
        insets.bottom = height
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets

        let tableViewHeight = tableView.frame.height - tableView.contentInset.bottom - tableView.contentInset.top
        let contentHeight = tableView.contentSize.height
        
//        _bottomYClearance = 0
        // Apply the bottom clearance
        tableView.contentOffset.y = contentHeight - bottomYClearance - tableViewHeight

    }
        
    @objc public func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && !isSelectionModeEnabled() {
            let point = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                if let message = datasource?.itemIdentifier(for: indexPath) {
                    model?.toggleSelection(message)
                    _ = reload(messages: [message], animated: true).subscribe()
                }
            }
        }
    }

    @objc public func onTap(_ sender: UITapGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && isSelectionModeEnabled() {
            let point = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                if let message = datasource?.itemIdentifier(for: indexPath) {
                    model?.toggleSelection(message)
                    _ = reload(messages: [message], animated: true).subscribe()
                }
            }
        } else {
            hideKeyboardListener?()
        }
    }
    
    public func isSelectionModeEnabled() -> Bool {
        return !(model?.selectedMessages().isEmpty ?? false)
    }
        
}

extension MessagesView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = model?.section(for: section) {
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
        if let message = datasource?.itemIdentifier(for: indexPath), let heightCache = messageCellSizeCache, let model = model {
            height = heightCache.heightForIndexPath(message, model: model, width: frame.width)
        }
        return height ?? ChatKit.config().estimatedMessageCellHeight
    }

}

extension MessagesView: PMessagesView {
    
    public func scrollToBottom(animated: Bool = true, force: Bool = false) {
        if tableView.numberOfSections > 0 {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section) - 1
            if row < 0 {
                return
            }
            let scroll = tableView.contentSize.height - tableView.frame.height - tableView.contentOffset.y <= ChatKit.config().messagesViewRefreshHeight
            
            if scroll || force {
                print("Scroll to bottom", row, section)
                let indexPath = IndexPath(row: row, section: section)
//                tableView.setContentOffset(CGPoint(0, 1000), animated: false)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }

    public func apply(snapshot: NSDiffableDataSourceSnapshot<Section, Message>, animated: Bool) -> Completable {
        return Completable.create { [weak self] completable in
            self?.datasource?.apply(snapshot, animatingDifferences: animated, completion: {
                completable(.completed)
            })
            return Disposables.create {}
        }
    }
    
    public func reload(messages: [Message], animated: Bool) -> Completable {
        return Completable.create { [weak self] completable in
            if var snapshot = self?.datasource?.snapshot() {
                snapshot.reloadItems(messages)
                self?.datasource?.apply(snapshot, animatingDifferences: animated, completion: {
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
        lazyReloadManager?.tableViewDidScroll(tableView)
        
        let offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        if abs(offset) < 5 && offset != 0 && refreshState == .willLoad {
            loadMoreMessages()
        }
        if abs(offset) < 1 && offset != 0 && refreshState == .loaded  {
            addLoadedMessages()
        }
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lazyReloadManager?.scrollViewWillBeginDragging(scrollView: scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lazyReloadManager?.scrollViewDidEndDecelerating(scrollView: scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        lazyReloadManager?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
        
}
