//
//  Licensing.swift
//  ChatSDKModules
//
//  Created by ben3 on 23/07/2021.
//

import Foundation
import ChatSDK

@objc public class Licensing: NSObject {
    
    static let instance = Licensing()
    @objc public static func shared() -> Licensing {
        return instance
    }
    
    var modules = [String]()
    var timer: Timer?
    
    @objc public func add(item: String) {
        modules.append(item)
        resetTimer()
    }

    public func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { [weak self] timer in
            timer.invalidate()
            self?.report()
        })
    }

    public func report() {
//        let manager = AFHTTPSessionManager()
//        manager.responseSerializer = AFHTTPResponseSerializer()
//        
//        if let id = Bundle.main.bundleIdentifier, let modulesJSON = json(from: modules) {
//            
//            let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]", options: NSRegularExpression.Options.caseInsensitive)
//            let range = NSMakeRange(0, id.count)
//            let path = regex.stringByReplacingMatches(in: id, options: [], range: range, withTemplate: "_")
//            
//            let identifier = BChatSDK.shared().identifier
//            
//            var params: [String: Any] = [
//                "path": path,
//                "id": id,
//                "modules": modulesJSON
//            ]
//            
//            if let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] {
//                params["name"] = name
//            }
//            
//            if let key = identifier?.first as? String, let value = identifier?.last {
//                params[key] = value
//            }
//            
//            manager.post("https://api.sdk.guru/log.php", parameters: params, progress: nil, success: { task, response in
//                print("Success")
//            }, failure: { task, error  in
//                print("Failure")
//            })
//
//        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}
