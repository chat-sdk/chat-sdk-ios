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
    
    var _messagesToAdd = [Message]()
    
    public init(_ messagesModel: MessagesModel, messageAdder: @escaping ([Message]) -> Completable?) {
        _messagesModel = messagesModel
        _messageAdder = messageAdder
    }
    
    public func tableViewDidScroll(_ tableView: UITableView) {
        loadMessages(tableView)
    }

//    public func loadMessages(_ tableView: UITableView) {
//        let offset = tableView.contentOffset.y + tableView.adjustedContentInset.top
//        let percentage = offset / tableView.frame.height
//
//        if _active && !_loadingMoreMesssages && percentage < 0.7, let model = _messagesModel {
//            _loadingMoreMesssages = true
//            _ = model.loadMessages().subscribe(onSuccess: { [weak self] messages in
//                if !messages.isEmpty {
//
//                    let h1 = tableView.contentSize.height
//                    let y = tableView.contentOffset.y
//
//                    _ = self?._messageAdder(messages)?.subscribe(onCompleted: {
//
//                        let h2 = tableView.contentSize.height
//
//                        tableView.setContentOffset(CGPoint(x: 0, y: y + h2 - h1), animated: false)
//
//                        self?._loadingMoreMesssages = false
//                    })
//                }
//            }, onFailure: { [weak self] error in
//                self?._loadingMoreMesssages = false
//            })
//        }
//    }
    
    public func loadMessages(_ tableView: UITableView) {
        let offset = tableView.contentOffset.y + tableView.adjustedContentInset.top
        let percentage = offset / tableView.frame.height

        if _active && _messagesToAdd.isEmpty && !_loadingMoreMesssages && percentage < 0.7, let model = _messagesModel {
            _loadingMoreMesssages = true
            _ = model.loadMessages().subscribe(onSuccess: { [weak self] messages in
                if !messages.isEmpty {
                    self?._messagesToAdd.append(contentsOf: messages)
                                        
                    self?._loadingMoreMesssages = false
                }
            }, onFailure: { [weak self] error in
                self?._loadingMoreMesssages = false
            })
        }
    }
    
    public func addMessages(_ scrollView: UIScrollView) {
        let h1 = scrollView.contentSize.height
        let y = scrollView.contentOffset.y
        _ = _messageAdder(_messagesToAdd)?.subscribe(onCompleted: { [weak self] in
            let h2 = scrollView.contentSize.height
            scrollView.setContentOffset(CGPoint(x: 0, y: y + h2 - h1), animated: false)
            self?._messagesToAdd.removeAll()
        })
    }
        
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollView.layer.removeAllAnimations()
        _active = true
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if !_messagesToAdd.isEmpty {
            addMessages(scrollView)
        }
        _active = false
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("Velocity ", velocity)
//        let value = targetContentOffset.pointee
//        self.targetContentOffset = targetContentOffset
    }
    
}
