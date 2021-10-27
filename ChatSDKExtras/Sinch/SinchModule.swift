//
//  SinchModule.swift
//  AFNetworking
//
//  Created by ben3 on 20/10/2021.
//

import Foundation
import ChatSDK
import Sinch
import SwiftJWT
import RXPromise
import Cryptor


struct SinchClaims: Claims {
    let iss: String
    let sub: String
    let exp: Int
    let iat: Int
    let nonce: String
}

enum SinchError: Error {
    case jwtNotAvailable(String)
    case userIdNotAvailable(String)
}

public class SinchModule: NSObject, PModule {
    
    static let instance = SinchModule()
    
    @objc public var client: SinchClient?
    
    @objc public static func shared() -> SinchModule {
        return instance
    }
        
    public func setup(key: String, secret: String) -> SinchModule {
        client = SinchClient(key: key, secret: secret)
        return self
    }

    public func setup(key: String, jwtProvider: @escaping (() -> String?)) -> SinchModule {
        client = SinchClient(key: key, jwtProvider: jwtProvider)
        return self
    }

    public func activate() {
        
        // Setup the client when we authenticate
        BChatSDK.hook().add(BHook({ [unowned self] data in
            if let id = BChatSDK.currentUserID() {
                client?.start(id)
            }
        }), withName: bHookDidAuthenticate)
        
    }
    

    
}

@objc public enum SinchCallStatus: Int32 {
    case none = -1
    case callDidEnd = 0
    case callDidProgress = 1
    case callDidEstablish = 2
    case callDidAddVideoTrack = 3
    case callDidResumeVideoTrack = 4
    case callDidPauseVideoTrack = 5
}

public class SinchClient: NSObject, SINClientDelegate {

    @objc public var client: SINClient?
    
    let key: String
    var secret: String?
    var jwtProvider: (() -> String?)?
    
    var id: String?
    @objc public var delegate: SINCallDelegate?
    
    @objc public var call: SINCall?
    @objc public var callStatus: SinchCallStatus = .none
    
    public init(key: String, secret: String) {
        self.key = key
        self.secret = secret
        super.init()
    }

    public init(key: String, jwtProvider: @escaping (() -> String?)) {
        self.key = key
        self.jwtProvider = jwtProvider
        super.init()
    }
        
    public func start(_ id: String) {
        self.id = id
        do {
            client = try Sinch.client(withApplicationKey: key,
                                  environmentHost: "ocra.api.sinch.com",
                                  userId: id)
            client!.enableManagedPushNotifications()
            client!.delegate = self
            client!.start()
        } catch {
            print(error.localizedDescription)
        }
    }

    public func client(_ client: SINClient!, requiresRegistrationCredentials registrationCallback: SINClientRegistration!) {
//        self.id = "foo"
        if let id = self.id {
            if let secret = self.secret, let secretData = Data(base64Encoded: secret) {

                let exp = Int(Date(timeIntervalSinceNow: 3600).timeIntervalSince1970)
                let iatDate = Date()
                let iat = Int(iatDate.timeIntervalSince1970)
//                let iat = 1514862245
//                let iatDate = Date(timeIntervalSince1970: Double(iat))
//                let exp = 1514862845
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                
                let dateString = dateFormatter.string(from: iatDate)
                
                // vnVhH+HeHF2SSvlwd75BTlnFXH6Ws3OM2iEHk4xfH7M=

                if let signed = HMAC(using: .sha256, key: secretData).update(data: Data(dateString.utf8))?.final() {

                    let signedKey = Data(signed)
                    let signedKeyString = signedKey.base64EncodedString()

                    let nonce = BCoreUtilities.getUUID().lowercased()
//                    let nonce = "6b438bda-2d5c-4e8c-92b0-39f20a94b34e"

                    let claims = SinchClaims(iss: "//rtc.sinch.com/applications/" + key,
                                             sub: "//rtc.sinch.com/applications/" + key + "/users/" + id,
                                             exp: exp, iat: iat, nonce: nonce)


                    let header = Header(typ: nil, kid: "hkdfv1-" + dateString)

                    var jwt = JWT(header: header,claims: claims)

                        let jwtSigner = JWTSigner.hs256(key: signedKey)
                        do {
                            let signedJWT = try jwt.sign(using: jwtSigner)
                            print("JWT", signedJWT)
                            registrationCallback.register(withJWT:signedJWT)
                        } catch {
                            registrationCallback.registerDidFail(error)
                        }
                    }

            } else if let jwt = jwtProvider?() {
                registrationCallback.register(withJWT: jwt)
            } else {
                registrationCallback.registerDidFail(SinchError.jwtNotAvailable("JWT not available"))
            }
        }
        
        //1634813187.098522
    }

    @objc public func clientDidStart(_ client: SINClient!) {
        print("DidStart")
    }
    
    @objc public func clientDidFail(_ client: SINClient!, error: Error!) {
        print("DidFail", error.localizedDescription)
    }

        
    @objc public func requestRecordPermission() -> RXPromise {
        let promise = RXPromise()
        AVAudioSession.sharedInstance().requestRecordPermission({ result in
            promise.resolve(withResult: NSNumber(booleanLiteral: result))
        })
        return promise
    }

    @objc public func requestCameraPermission() -> RXPromise {
        let promise = RXPromise()
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { result in
            promise.resolve(withResult: NSNumber(booleanLiteral: result))
        })
        return promise
    }

    
//    @objc public func startWithUserId(_ id: String) {
//        _ = requestRecordPermission().then({ [unowned self] result in
//            if let result = result as? NSNumber, result == true {
//                return requestCameraPermission().then({ result in
//                    if let result = result as? NSNumber, result == true, let client = client {
//
//                    }
//                    return result
//                }, nil)
//            }
//            return result
//        }, nil)
//    }
    
    @objc public func callUser(with id: String) {
        if let client = client {
            call?.hangup()
            
            _ = requestRecordPermission().then({ [unowned self] result in
                if let result = result as? NSNumber, result == true {
                    return requestCameraPermission().then({ result in
                        if let result = result as? NSNumber, result == true {

                            call = client.call().callUserVideo(withId: id)
                            call?.delegate = self
                            call?.pauseVideo()

                        }
                        return result
                    }, nil)
                }
                
                return result
            }, nil)
        }
    }
    
    @objc public func resumeVideo() {
        call?.resumeVideo()
    }
    
    @objc public func pauseVideo() {
        call?.pauseVideo()
    }
    
    @objc public func enableSpeaker() throws {
        try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
    }
    
    @objc public func disableSpeaker() throws {
        try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
    }
    
    @objc public func getRemoteUserId() -> String? {
        return call?.remoteUserId
    }
    
    @objc public func getLocalView() -> UIView? {
        return client?.videoController().localView()
    }
    
    @objc public func getRemoteView() -> UIView? {
        return client?.videoController().remoteView()
    }
    
    @objc public func answer() {
        call?.answer()
    }
    
    @objc public func hangup() {
        call?.hangup()
    }
}

extension SinchClient: SINCallDelegate {
    
    public func callDidEnd(_ call: SINCall!) {
        callStatus = .callDidEnd
        delegate?.callDidEnd?(call)
    }
    
    public func callDidProgress(_ call: SINCall!) {
        callStatus = .callDidProgress
        delegate?.callDidProgress?(call)
    }
    
    public func callDidEstablish(_ call: SINCall!) {
        callStatus = .callDidEstablish
        delegate?.callDidEstablish?(call)
    }
    
    public func callDidAddVideoTrack(_ call: SINCall!) {
        callStatus = .callDidAddVideoTrack
        delegate?.callDidAddVideoTrack?(call)
    }
    
    public func callDidResumeVideoTrack(_ call: SINCall!) {
        callStatus = .callDidResumeVideoTrack
        delegate?.callDidResumeVideoTrack?(call)
    }
    
    public func callDidPauseVideoTrack(_ call: SINCall!) {
        callStatus = .callDidPauseVideoTrack
        delegate?.callDidPauseVideoTrack?(call)
    }

}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(decoding: data, as: UTF8.self)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

}
