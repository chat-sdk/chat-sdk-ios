//
//  PMessagesView.swift
//  ChatK!t
//
//  Created by ben3 on 21/04/2021.
//

import Foundation
import RxSwift

public protocol PMessagesView {
    func scrollToBottom(animated: Bool, force: Bool)
    func apply(snapshot: NSDiffableDataSourceSnapshot<Section, Message>, animated: Bool) -> Completable
    func reload(messages: [Message], animated: Bool) -> Completable
//    func layout()
}
