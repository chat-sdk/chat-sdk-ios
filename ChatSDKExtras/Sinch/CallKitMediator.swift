/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import CallKit
import Foundation
import OSLog
import Sinch
import UIKit

protocol CallKitMediatorDelegate: AnyObject {
  func handleIncomingCall(_ call: SINCa)
}

protocol CallKitMediatorObserver: SinchCallDelegate {}

final class CallKitMediator: NSObject { // Inherit NSObject because we need conformance to CXProviderDelegate
  static let userIDKey: String = "com.sinch.userId"
  let customLog = OSLog(subsystem: "com.sinch.sdk.app", category: "CallKitMediator")

  var client: SinchClient?

  weak var delegate: CallKitMediatorDelegate!
  var provider: CXProvider!
  var callController: CXCallController!
  var muted: Bool = false
  let callRegistry = CallRegistry()

  init(delegate: CallKitMediatorDelegate) {
    super.init()
    self.delegate = delegate
    let config = CXProviderConfiguration(localizedName: "Sinch")
    config.maximumCallGroups = 1
    config.maximumCallsPerCallGroup = 1
    config.supportedHandleTypes = [.generic]
    config.supportsVideo = true
    config.ringtoneSound = "incoming.wav"

    self.provider = CXProvider(configuration: config)
    self.provider.setDelegate(self, queue: nil)
    self.callController = CXCallController()
  }

  typealias CreateCallback = (_ error: Error?) -> Void
  var createCallback: CreateCallback!

  func createClient(withUserId userId: String, andCallback callback: @escaping CreateCallback) {
    guard self.client == nil else {
      if self.client!.isStarted {
        callback(nil)
      }
      return
    }

    do {
      self.client = try SinchRTC.client(withApplicationKey: APPLICATION_KEY,
                                        environmentHost: ENVIRONMENT_HOST,
                                        userId: userId)
    } catch let error as NSError {
      callback(error)
    }

    self.client?.delegate = self
    self.client!.callClient.delegate = self
    self.client!.audioController.delegate = self

    self.createCallback = callback
    self.client!.start()
  }

  func createClientIfNeeded() {
    if let userId = UserDefaults.standard.string(forKey: CallKitMediator.userIDKey) {
      // We are sure userId is downcastable to String
      self.createClient(withUserId: userId) { error in
        if let err = error {
          os_log("SinchClient started with error: %{public}@", log: self.customLog, type: .error, err.localizedDescription)
        } else {
          os_log("SinchClient started successfully: (version:%{public}@)", log: self.customLog, SinchRTC.version())
        }
      }

    } else {
      os_log("No saved userId to create SinchClient", log: self.customLog)
    }
  }

  func logout(withCompletion completion: () -> Void) {
    defer {
      completion()
    }

    guard let client = self.client else { return }

    if client.isStarted {
      // Remove push registration from Sinch backend
      client.unregisterPushNotificationDeviceToken()
      client.terminateGracefully()
    }

    self.client = nil
  }

  /**
   * No dispatching here. Must be called on the same thread as PushKit called us
   */
  func reportIncomingCall(withPushPayload payload: [AnyHashable: Any], withCompletion completion: @escaping (Error?) -> Void) {
    let notification = queryPushNotificationPayload(payload)

    if notification.isCall {
      let callNotification = notification.callResult

      // We use our internal callId (which is UUID using RFC-4122)
      guard self.callRegistry.callKitUUID(forSinchId: callNotification.callId) == nil else { return }
      self.reportNewIncomingCallToCallKit(withNotification: callNotification, withCompletion: completion)
    }
  }

  /**
   * Use this to start a call while in foreground
   */
  typealias CallStartedCallback = (Result<SinchCall, Error>) -> Void
  var callStarted: CallStartedCallback!

  func startOutgoingVideoCall(to destination: String,
                              withCompletion completion: @escaping CallStartedCallback) {
    let handle = CXHandle(type: .generic, value: destination)
    let initiateCallAction = CXStartCallAction(call: UUID(), handle: handle)
    initiateCallAction.isVideo = true
    let initOutgoingCall = CXTransaction(action: initiateCallAction)

    self.callStarted = completion

    self.callController.request(initOutgoingCall, completion: { error in
      if let err = error {
        os_log("Error requesting start call transaction: %{public}@",
               log: self.customLog, type: .error, err.localizedDescription)
        DispatchQueue.main.async {
          completion(.failure(err))
          self.callStarted = nil
        }
      }
    })
  }

  /// Use this to end call in the foreground
  /// - Parameter call: SinchCall object
  func end(call: SinchCall) {
    guard let uuid = self.callRegistry.callKitUUID(forSinchId: call.callId) else {
      return
    }

    let endCallAction = CXEndCallAction(call: uuid)
    let transaction = CXTransaction()
    transaction.addAction(endCallAction)

    self.callController.request(transaction, completion: { error in
      if let err = error {
        os_log("Error requesting end call transaction: %{public}@", log: self.customLog, type: .error, err.localizedDescription)
      }
      self.callStarted = nil
    })
  }

  func callExists(withId callId: String) -> Bool {
    return self.callRegistry.sinchCall(forCallId: callId) != nil
  }

  /**
   * Returns currect active call if htere is one
   */
  func currentCall() -> SinchCall? {
    let calls = self.callRegistry.activeSinchCalls()
    if !calls.isEmpty {
      let call = calls[0]
      if call.state == .initiating || call.state == .established {
        return call
      }
    }
    return nil
  }

  class Observation {
    init(_ observer: CallKitMediatorObserver) {
      self.observer = observer
    }

    weak var observer: CallKitMediatorObserver?
  }

  var observers: [Observation] = []

  func addObserver(_ observer: CallKitMediatorObserver) {
    guard self.observers.firstIndex(where: { $0.observer === observer }) != nil else {
      self.observers.append(Observation(observer))
      return
    }
  }

  func removeObserver(_ observer: CallKitMediatorObserver) {
    if let idx = self.observers.firstIndex(where: { $0.observer === observer }) {
      self.observers.remove(at: idx)
    }
  }

  // MARK: Implementation

  private func reportNewIncomingCallToCallKit(withNotification notification: SinchCallNotificationResult,
                                              withCompletion completion: @escaping (Error?) -> Void) {
    let cxCallId = UUID()
    self.callRegistry.map(callKitId: cxCallId, toSinchCallId: notification.callId)

    os_log("reportNewIncomingCallToCallKit: ckid:%{public}@ callId:%{public}@",
           log: self.customLog, cxCallId.description, notification.callId)

    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .generic, value: notification.remoteUserId)
    update.hasVideo = notification.isVideoOffered

    self.provider.reportNewIncomingCall(with: cxCallId, update: update) { (error: Error?) in
      if error != nil {
        // If we get an error here from the OS, it is possibly the callee's phone has "Do
        // Not Disturb" turned on, check CXErrorCodeIncomingCallError in CXError.h
        self.hangupCallOnError(withId: notification.callId)
      }
      completion(error)
    }
  }

  private func hangupCallOnError(withId callId: String) {
    guard let call = self.callRegistry.sinchCall(forCallId: callId) else {
      os_log("Unable to find sinch call for callId: %{public}@", log: self.customLog, type: .error, callId)
      return
    }
    call.hangup()

    self.callRegistry.removeSinchCall(withId: callId)
  }
}
