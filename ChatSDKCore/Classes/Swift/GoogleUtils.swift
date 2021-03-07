//
//  GoogleUtils.swift
//  AFNetworking
//
//  Created by ben3 on 02/07/2020.
//

import Foundation

@objc public class GoogleUtils: NSObject {
    
    @objc public static func getMapImageURL(latitude: Double, longitude: Double, width: Int, height: Int) -> String? {
        if let googleMapsApiKey = BChatSDK.config().googleMapsApiKey {
            let api = "https://maps.googleapis.com/maps/api/staticmap"
            let markers = String(format: "markers=%f,%f", latitude, longitude)
            let size = String(format: "zoom=18&size=%ix%i", width, height)
            let key = String(format: "key=%@", googleMapsApiKey)
            return String(format: "%@?%@&%@&%@", api, markers, size, key)
        }
        return nil
    }

    @objc public static func getMapImageWebLink(latitude: Double, longitude: Double) -> String {
        return String(format: "http://maps.google.com/maps?z=12&t=m&q=loc:%f+%f", latitude, longitude)
    }

}
