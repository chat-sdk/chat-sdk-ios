//
//  User.swift
//  AFNetworking
//
//  Created by ben3 on 18/07/2020.
//

import Foundation

@objc public protocol User {
    
    @objc func userId() -> String
    @objc func userName() -> String
    @objc func userImageUrl() -> URL?

}
