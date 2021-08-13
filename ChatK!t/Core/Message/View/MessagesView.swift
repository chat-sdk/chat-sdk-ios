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

open class MessagesView: UIView {
    
    public enum RefreshState {
        case none
        case willLoad
        case loading
        case loaded
    }
    
    open var tableView = UITableView()
    open var model: MessagesModel?
    open var lazyReloadManager: LazyReloadManager?
    
    open var longPressRecognizer: UIGestureRecognizer?
    open var tapRecognizer: UIGestureRecognizer?
    open var refreshControl: UIRefreshControl?
    
    open var refreshState: RefreshState = .none
    open var loadedMessages: [AbstractMessage]?
    
    open var hideKeyboardListener: (() -> Void)?
    
    // This is used to preseve the Y position when we change the table insets
    open var bottomYClearance: CGFloat = 0
    
    open var datasource: UITableViewDiffableDataSource<Section, AbstractMessage>?
    
    open var messageCellSizeCache: MessageCellSizeCache?
            
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

    open func setup() {
        
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
    
    @objc open func startLoading() {
        refreshState = .willLoad
        tableView.isUserInteractionEnabled = false
    }
    
    @objc open func loadMoreMessages() {
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
    
    open func addLoadedMessages() {
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
    
    open func setModel(model: MessagesModel) {
        
        self.model = model
        model.view = self
        
        lazyReloadManager = LazyReloadManager(model, messageAdder: { messages -> Completable? in
            return model.addMessages(toStart: messages, updateView: true, animated: false)
        })

        datasource = UITableViewDiffableDataSource<Section, AbstractMessage>(tableView: tableView) { tableView, indexPath, message in
            let registration = model.cellRegistration(message.messageType())!
            let identifier = registration.identifier(direction: message.messageDirection())
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! AbstractMessageCell
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
        
    open func willSetBottomInset() {
        // Save the scroll percentage
        let tableViewHeight = tableView.frame.height - tableView.contentInset.bottom - tableView.contentInset.top
        let contentHeight = tableView.contentSize.height
        bottomYClearance = contentHeight - (tableView.contentOffset.y + tableViewHeight)
    }
    
    open func setBottomInset(height: CGFloat) {

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
        
    @objc open func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if ChatKit.config().messageSelectionEnabled && !isSelectionModeEnabled(), let message = messageForTap(sender) {
            model?.toggleSelection(message)
            _ = reload(messages: [message], animated: false).subscribe()
        }
    }

    @objc open func onTap(_ sender: UITapGestureRecognizer) {
        if let message = messageForTap(sender) {
            if ChatKit.config().messageSelectionEnabled && isSelectionModeEnabled() {
                model?.toggleSelection(message)
                _ = reload(messages: [message], animated: false).subscribe()
                return
            } else if contentTapped(sender) && (model?.onClick(message) ?? true) {
                return
            }
        }
        hideKeyboardListener?()
    }
    
    open func messageForTap(_ recognizer: UIGestureRecognizer) -> AbstractMessage? {
        let point = recognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if let message = datasource?.itemIdentifier(for: indexPath) {
                return message
            }
        }
        return nil
    }
    
    open func cellForTap(_ recognizer: UIGestureRecognizer) -> AbstractMessageCell? {
        let point = recognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if let cell = tableView.cellForRow(at: indexPath) as? AbstractMessageCell {
                return cell
            }
        }
        return nil
    }
    
    open func contentTapped(_ recognizer: UIGestureRecognizer) -> Bool {
        if let cell = cellForTap(recognizer) {
            let point = recognizer.location(in: tableView)
            let cellPoint = CGPoint(x: point.x - cell.frame.minX, y: point.y - cell.frame.minY)
            return cell.content?.view().frame.contains(cellPoint) ?? false
        }
        return false
    }
    
    open func isSelectionModeEnabled() -> Bool {
        return !(model?.selectedMessages().isEmpty ?? false)
    }
    
    deinit {
        messageCellSizeCache?.clear()
    }
        
}

extension MessagesView: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let section = model?.section(for: section) {
            return ChatKit.provider().sectionView(for: section)
        }
        return nil
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return ChatKit.config().messagesViewSectionHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForIndexPath(indexPath)
    }
    
    open func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat {
        var height: CGFloat?
        
        var width = UIScreen.main.bounds.width
//        if frame.width > 0 {
//            width = frame.width
//        }
        
        // This is called before the messages view has been layed out... so the frame is zero
        if let message = datasource?.itemIdentifier(for: indexPath), let heightCache = messageCellSizeCache, let model = model {
            height = heightCache.heightForIndexPath(message, model: model, width: width)
        }
        
//        print("Cell height", height)
        return height ?? ChatKit.config().estimatedMessageCellHeight
    }

}

extension MessagesView: PMessagesView {
    
    open func scrollToBottom(animated: Bool = true, force: Bool = false) {
        if tableView.numberOfSections > 0 {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section) - 1
            if row < 0 {
                return
            }
            let scroll = offsetFromBottom() <= ChatKit.config().messagesViewRefreshHeight
            
            if scroll || force {
//                print("Scroll to bottom", row, section)
                let indexPath = IndexPath(row: row, section: section)
//                tableView.setContentOffset(CGPoint(0, 1000), animated: false)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    open func offsetFromBottom() -> CGFloat {
        return tableView.contentSize.height - tableView.frame.height - tableView.contentOffset.y
    }

    open func apply(snapshot: NSDiffableDataSourceSnapshot<Section, AbstractMessage>, animated: Bool) -> Completable {
        return Completable.create { [weak self] completable in
            self?.datasource?.apply(snapshot, animatingDifferences: animated, completion: {
                completable(.completed)
            })
            return Disposables.create {}
        }
    }
    
    open func reload(messages: [AbstractMessage], animated: Bool) -> Completable {
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
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lazyReloadManager?.tableViewDidScroll(tableView)
        
        let offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
        if abs(offset) < 5 && offset != 0 && refreshState == .willLoad {
            loadMoreMessages()
        }
        if abs(offset) < 1 && offset != 0 && refreshState == .loaded  {
            addLoadedMessages()
        }
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lazyReloadManager?.scrollViewWillBeginDragging(scrollView: scrollView)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lazyReloadManager?.scrollViewDidEndDecelerating(scrollView: scrollView)
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        lazyReloadManager?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
        
}
