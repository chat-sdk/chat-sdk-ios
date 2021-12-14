/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import OSLog
import Sinch
import UIKit

extension CallKitMediator: SinchCallClientDelegate {
  func client(_ client: SinchCallClient, didReceiveIncomingCall call: SinchCall) {
    os_log("didReceiveIncomingCall with callId: %{public}@, from:%{public}@, app state:%{public}d",
           log: self.customLog, call.callId, call.remoteUserId, UIApplication.shared.applicationState.rawValue)

    // NOTE: Mediator is the only delegate of the call and will do the fanout of events
    call.delegate = self
    // We save the call object so we can either accept or deny it later when user interacts with CallKit UI
    self.callRegistry.addSinchCall(call)

    if UIApplication.shared.applicationState != .background {
      // Delegate presentation work to presenter
      self.delegate.handleIncomingCall(call)
    }
  }
}
