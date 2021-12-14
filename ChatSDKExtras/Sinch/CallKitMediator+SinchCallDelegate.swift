/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import CallKit
import Foundation
import OSLog
import Sinch

let sinchCallDelegateLog = OSLog(subsystem: "com.sinch.sdk.app", category: "CallKitMediator.SinchCallDelegate")

extension CallKitMediator: SinchCallDelegate {
  private func fanoutDelegateCall(_ callback: (_ observer: CallKitMediatorObserver) -> Void) {
    // Remove dangling before calling
    self.observers.removeAll(where: { $0.observer == nil })
    self.observers.forEach { callback($0.observer!) }
  }

  func callDidProgress(_ call: SinchCall) {
    if let callKitId = self.callRegistry.callKitUUID(forSinchId: call.callId), call.direction == .outgoing {
      self.provider.reportOutgoingCall(with: callKitId, startedConnectingAt: call.details.startedTime)
    }

    self.fanoutDelegateCall { $0.callDidProgress(call) }
  }

  func callDidEstablish(_ call: SinchCall) {
    if let callKitId = self.callRegistry.callKitUUID(forSinchId: call.callId), call.direction == .outgoing {
      self.provider.reportOutgoingCall(with: callKitId, connectedAt: call.details.establishedTime)
    }
    self.fanoutDelegateCall { $0.callDidEstablish(call) }
  }

  func callDidEnd(_ call: SinchCall) {
    defer {
      call.delegate = nil
    }

    if let uuid = self.callRegistry.callKitUUID(forSinchId: call.callId) {
      // Report end of the call to CallKit
      self.provider.reportCall(with: uuid,
                               endedAt: call.details.endedTime,
                               reason: getCallKitCallEndedReason(forCause: call.details.endCause))
    }

    self.callRegistry.removeSinchCall(withId: call.callId)

    if call.details.endCause == .error {
      os_log("didEndCall with reason: %{public}@, error: %{public}@, Removing sinch call with ID: %{public}@",
             log: sinchCallDelegateLog, type: .error, call.details.endCause.rawValue,
             call.details.error?.localizedDescription ?? "?", call.callId)
    } else {
      os_log("didEndCall with reason: %{public}@, Removing sinch call with ID: %{public}@",
             log: sinchCallDelegateLog, call.details.endCause.rawValue, call.callId)
    }

    self.fanoutDelegateCall { $0.callDidEnd(call) }
  }

  func callDidAddVideoTrack(_ call: SinchCall) {
    self.fanoutDelegateCall { $0.callDidAddVideoTrack(call) }
  }

  func callDidPauseVideoTrack(_ call: SinchCall) {
    self.fanoutDelegateCall { $0.callDidPauseVideoTrack(call) }
  }

  func callDidResumeVideoTrack(_ call: SinchCall) {
    self.fanoutDelegateCall { $0.callDidResumeVideoTrack(call) }
  }
}

private func getCallKitCallEndedReason(forCause cause: SinchCallDetails.EndCause) -> CXCallEndedReason {
  switch cause {
  case .error:
    return CXCallEndedReason.failed
  case .denied:
    return .remoteEnded
  case .hungUp:
    // This mapping is not really correct, as SINCallEndCauseHungUp is the end case also when the local peer ended the
    // call.
    return .remoteEnded
  case .timeout:
    return .unanswered
  case .canceled:
    return .unanswered
  case .noAnswer:
    return .unanswered
  case .otherDeviceAnswered:
    return .unanswered
  default:
    break
  }
  return .failed
}
