//
//  PMessagesView.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation
import RxSwift

public protocol PMessagesView: AnyObject {
    func scrollToBottom(animated: Bool, force: Bool)
    func apply(snapshot: NSDiffableDataSourceSnapshot<Section, AbstractMessage>, animated: Bool) -> Completable
    func reload(messages: [AbstractMessage], animated: Bool) -> Completable
    func offsetFromBottom() -> CGFloat
}
