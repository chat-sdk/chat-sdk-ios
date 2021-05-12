//
//  LazyReloadManager.swift
//  ChatK!t
//
//  Created by ben3 on 04/05/2021.
//

import Foundation
import RxSwift

public class LazyReloadManager {
    
    var _loadingMoreMesssages = false
    var _active = false
    
    weak var _messagesModel: MessagesModel?
    let _messageAdder: (([Message]) -> Completable?)
    
    public init(_ messagesModel: MessagesModel, messageAdder: @escaping ([Message]) -> Completable?) {
        _messagesModel = messagesModel
        _messageAdder = messageAdder
    }
    
    public func tableViewDidScroll(_ tableView: UITableView) {
        loadMessages(tableView)
    }
    
    public func loadMessages(_ tableView: UITableView) {
        let offset = tableView.contentOffset.y + tableView.adjustedContentInset.top
        if _active && !_loadingMoreMesssages && offset < 10, let model = _messagesModel, let indexPath = tableView.indexPathsForVisibleRows?.first, let message = model.adapter().message(for: indexPath) {
            _loadingMoreMesssages = true
            _ = model.loadMessages().subscribe(onSuccess: { [weak self] messages in
                if !messages.isEmpty {
                    _ = self?._messageAdder(messages)?.subscribe(onCompleted: {

                        if let newIndexPath = model.adapter().indexPath(for: message) {
                            tableView.scrollToRow(at: newIndexPath, at: .top, animated: false)
                        }
                        
                        self?._loadingMoreMesssages = false
                    })
                }
            }, onFailure: { [weak self] error in
                self?._loadingMoreMesssages = false
            })
        }
    }
        
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        _active = true
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        _active = false
    }
    
}
