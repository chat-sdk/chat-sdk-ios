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
    case error(String)
}

public class SinchModule: NSObject, PModule, SINManagedPushDelegate, CallKitMediatorDelegate {
    
    static let instance = SinchModule()
    
    @objc public var client: SinchClient?
    var push: SINManagedPush?
    var callkitMediator: CallKitMediator?
    
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
        
        push = Sinch.managedPush(with: .development)
        push?.delegate = self
        push?.setDesiredPushType(SINPushTypeVoIP)
        
        callkitMediator = CallKitMediator(delegate: self)
        
        // Setup the client when we authenticate
        BChatSDK.hook().add(BHook({ [unowned self] data in
            if let id = BChatSDK.currentUserID() {
                client?.start(id)
            }
        }), withName: bHookDidAuthenticate)
        
    }
    
    public func managedPush(_ managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]!, forType pushType: String!) {
        print("Ok")
    }
    
    func handleIncomingCall(_ call: SinchCall) {
        
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
            
            print("Start Sinch Client", id)
            client!.enableManagedPushNotifications()
            client!.delegate = self
            
//            client!.setSupportPushNotifications(false)
                        
            client!.start()
        } catch {
            print(error.localizedDescription)
        }
    }

    public func client(_ client: SINClient!, requiresRegistrationCredentials registrationCallback: SINClientRegistration!) {
        if let id = self.id {
            if let secret = self.secret, let secretData = Data(base64Encoded: secret) {

                let exp = Int(Date(timeIntervalSinceNow: 3600).timeIntervalSince1970)
                let iatDate = Date()
                let iat = Int(iatDate.timeIntervalSince1970)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                
                let dateString = dateFormatter.string(from: iatDate)
                
                if let signed = HMAC(using: .sha256, key: secretData).update(data: Data(dateString.utf8))?.final() {

                    let signedKey = Data(signed)
                    let signedKeyString = signedKey.base64EncodedString()

                    let nonce = BCoreUtilities.getUUID().lowercased()

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
        print("Sinch Client Did Start", client.userId)
        client.call().delegate = self
//        DispatchQueue.main.async {
//        }
    }
    
    @objc public func clientDidFail(_ client: SINClient!, error: Error!) {
        print("Sinch Client Did Fail", error.localizedDescription)
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

        
    @objc public func callUser(with id: String) -> RXPromise? {
        
        if let client = client {
            call?.hangup()
            
            return requestRecordPermission().then({ [unowned self] result in
                if let result = result as? NSNumber, result == true {
                    return requestCameraPermission().thenOnMain({ result in
                        if let result = result as? NSNumber, result == true {
                            
                            print("Sinch User id", id)
                            call = client.call().callUser(withId: id)

//                          call = client.call().callUserVideo(withId: id)
                            call?.delegate = self
//                          call?.pauseVideo()

                        }
                        return result
                    }, nil)
                }
                
                return result
            }, nil)
        } else {
            return RXPromise.reject(withReason: SinchError.error("Client not available"))
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
        print("Sinch answer")
        call?.answer()
    }
    
    @objc public func hangup() {
        print("Sinch hangup")
        call?.hangup()
    }
}

extension SinchClient: SINCallClientDelegate {
    
    public func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        print("Sinch didReceiveIncomingCall")

        if self.call != nil {
            return
        }
        self.call = call
        self.call?.delegate = self

        var topController = UIApplication.shared.keyWindow?.rootViewController
        while(topController?.presentedViewController != nil) {
            topController = topController?.presentedViewController
        }

        let incomingCallVC = IncomingCallViewController()
        topController?.present(incomingCallVC, animated: true, completion: nil)

    }
    
}

extension SinchClient: SINCallDelegate {
    
    public func callDidEnd(_ call: SINCall!) {
        print("Sinch callDidEnd", call.details.endCause.rawValue)
        callStatus = .callDidEnd
        DispatchQueue.main.async { [unowned self] in
            delegate?.callDidEnd?(call)
        }
    }
    
    public func callDidProgress(_ call: SINCall!) {
        print("Sinch callDidProgress")
        callStatus = .callDidProgress
        DispatchQueue.main.async { [unowned self] in
            delegate?.callDidProgress?(call)
        }
    }
    
    public func callDidEstablish(_ call: SINCall!) {
        print("Sinch callDidEstablish")
        callStatus = .callDidEstablish
        DispatchQueue.main.async { [unowned self] in
            delegate?.callDidEstablish?(call)
        }
    }
    
    public func callDidAddVideoTrack(_ call: SINCall!) {
        print("Sinch callDidAddVideoTrack")
        callStatus = .callDidAddVideoTrack
        DispatchQueue.main.async { [unowned self] in
            delegate?.callDidAddVideoTrack?(call)
        }
    }
    
    public func callDidResumeVideoTrack(_ call: SINCall!) {
        print("Sinch callDidResumeVideoTrack")
        callStatus = .callDidResumeVideoTrack
        DispatchQueue.main.async { [unowned self] in
            delegate?.callDidResumeVideoTrack?(call)
        }
    }
    
    public func callDidPauseVideoTrack(_ call: SINCall!) {
        print("Sinch callDidPauseVideoTrack")
        callStatus = .callDidPauseVideoTrack
        DispatchQueue.main.async { [unowned self] in
            delegate?.callDidPauseVideoTrack?(call)
        }
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
