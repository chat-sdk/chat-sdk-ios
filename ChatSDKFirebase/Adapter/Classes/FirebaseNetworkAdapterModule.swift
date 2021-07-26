//
//  FirebaseNetworkAdapterModule.swift
//  ChatSDKFirebase
//
//  Created by ben3 on 13/01/2021.
//

import Foundation
import FirebaseDatabase
import ChatSDK

@objc public class FirebaseNetworkAdapterModule: NSObject, PModule, PNetworkAdapterProvider {

    var networkAdapter: BFirebaseNetworkAdapter?
    
    public func getNetworkAdapter() -> PNetworkAdapter! {
        if networkAdapter == nil {
            networkAdapter = BFirebaseNetworkAdapter()
        }
        return networkAdapter
    }
    
    static let instance = FirebaseNetworkAdapterModule()
    @objc public static func shared() -> FirebaseNetworkAdapterModule {
        return instance
    }
    
    @objc public func withNetworkAdapter(_ adapter: BFirebaseNetworkAdapter) -> FirebaseNetworkAdapterModule {
        networkAdapter = adapter
        return self
    }
    
    @objc public var firebaseApp: FirebaseApp?
    @objc public var firebaseDatabase: Database?
    @objc public var firebaseAuth: Auth?

    override init() {
        super.init()
        configure()
    }
    
    @objc public func configure() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    @objc public func activate() {

//        let networkAdapter = BFirebaseNetworkAdapter.init()
//        BChatSDK.shared().networkAdapter = BFirebaseNetworkAdapter.init()
        networkAdapter?.activate()
    }
  
    @objc public func app() -> FirebaseApp? {
        return firebaseApp ?? FirebaseApp.app()
    }
    
    @objc public func database() -> Database {
        return firebaseDatabase ?? Database.database()
    }

    @objc public func auth() -> Auth {
        return firebaseAuth ?? Auth.auth()
    }

}
