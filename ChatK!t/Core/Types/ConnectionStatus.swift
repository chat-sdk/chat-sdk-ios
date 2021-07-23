//
//  ConnectionStatus.swift
//  ChatK!t
//
//  Created by ben3 on 10/04/2021.
//

import Foundation

public enum ConnectionStatus: Int {
    case none = 0
    case connected = 1
    case connecting = 2
    case disconnected = 3
}
