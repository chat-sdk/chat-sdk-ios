/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import AVFoundation
import CallKit
import Foundation
import OSLog
import Sinch

let providerDelegateLog = OSLog(subsystem: "com.sinch.sdk.app", category: "CallKitMediator.CXProviderDelegate")

extension CallKitMediator: CXProviderDelegate {
  func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
    guard self.client != nil else {
      os_log("SinchClient not assigned when audio session is activating (provider:didActivate audioSession)",
             log: providerDelegateLog, type: .error)
      return
    }

    self.client!.callClient.provider(provider: provider, didActivateAudioSession: audioSession)
  }

  func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
    guard self.client != nil else {
      os_log("SinchClient not assigned when audio session is activating (provider:didDeactivate audioSession)",
             log: providerDelegateLog, type: .error)
      return
    }

    self.client!.callClient.provider(provider: provider, didDeactivateAudioSession: audioSession)
  }

  func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
    defer {
      self.callStarted = nil
    }

    guard self.client != nil else {
      os_log("SinchClient not assigned when CXStartCallAction. Failing action", log: providerDelegateLog, type: .error)
      action.fail()
      self.callStarted?(.failure(Errors.clientNotStarted("SinchClient not assigned when CXStartCallAction.")))
      return
    }

    os_log("provider perform action: CXStartCallAction", log: providerDelegateLog)

    let callResult = self.client!.callClient.videoCallToUser(withId: action.handle.value)
    switch callResult {
    case let .success(call):
      self.callRegistry.addSinchCall(call)
      self.callRegistry.map(callKitId: action.callUUID, toSinchCallId: call.callId)

      action.fulfill()

      // NOTE: Mediator is the only delegate of the call and will do the fanout of events
      call.delegate = self

    case let .failure(error):
      os_log("Unable to make a call: %s", log: providerDelegateLog, type: .error, error.localizedDescription)
      action.fail()
    }
    self.callStarted?(callResult)
  }

  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    guard self.client != nil else {
      os_log("SinchClient not assigned when CXAnswerCallAction. Failing action", log: providerDelegateLog, type: .error)
      action.fail()
      return
    }

    guard let call = self.callRegistry.sinchCall(forCallKitUUID: action.callUUID) else {
      action.fail()
      return
    }

    os_log("provider perform action: CXAnswerCallAction: %{public}@", log: providerDelegateLog, call.callId)

    self.client!.audioController.configureAudioSessionForCallKitCall()

    call.answer()

    action.fulfill()
  }

  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    guard self.client != nil else {
      os_log("SinchClient not assigned when CXEndCallAction. Failing action", log: providerDelegateLog, type: .error)
      action.fail()
      return
    }

    guard let call = self.callRegistry.sinchCall(forCallKitUUID: action.callUUID) else {
      action.fail()
      return
    }

    os_log("provider perform action: CXEndCallAction: %{public}@", log: providerDelegateLog, call.callId)

    call.hangup()

    action.fulfill()
  }

  func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
    guard self.client != nil else {
      os_log("SinchClient not assigned when CXSetMutedCallAction", log: providerDelegateLog, type: .error)
      action.fail()
      return
    }

    os_log("provider perform action: CXSetMutedCallAction, uuid: %{public}@",
           log: providerDelegateLog, action.callUUID.description)

    if self.muted {
      self.client!.audioController.unmute()
    } else {
      self.client!.audioController.mute()
    }

    action.fulfill()
  }

  func providerDidReset(_ provider: CXProvider) {
    os_log("CXProviderDelegate.providerDidReset()", log: providerDelegateLog)

    /*
     End any ongoing calls if the provider resets, and remove them from the app's list of calls
     because they are no longer valid.
     */
    for call in self.callRegistry.activeSinchCalls() {
      call.hangup()
    }

    // Remove all calls from the app's list of calls.
    self.callRegistry.reset()
  }
}
