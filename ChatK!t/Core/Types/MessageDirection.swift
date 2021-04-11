//
//  MessageDirection.swift
//  AFNetworking
//
//  Created by ben3 on 20/07/2020.
//

import Foundation

public enum MessageDirection: Int {
    case incoming
    case outgoing
//    case none
    
    public func get() -> String {
        switch self {
        case .incoming:
            return "Incoming"
        case .outgoing:
            return "Outgoing"
//            case .none return "None"
        }
    }
}
