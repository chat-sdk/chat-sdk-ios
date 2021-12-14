/*
 * Copyright © Sinch AB. All rights reserved.
 *
 * See LICENSE file for license terms and information.
 */

import Foundation
import Sinch

extension CallKitMediator: SinchClientDelegate {
  func clientRequiresRegistrationCredentials(_ client: SinchClient, withCallback callback: SinchClientRegistration) {
    // WARNING: Embedding the Application Secret and use of the class SINJWT as shown here
    // should NOT be done for an application deployed to production.
    // The class SINJWT is only here to show how to construct and sign a registration token.

    do {
      let jwt = try sinchJWTForUserRegistration(withApplicationKey: APPLICATION_KEY,
                                                applicationSecret: APPLICATION_SECRET,
                                                userId: client.userId)
      callback.register(withJWT: jwt)

    } catch {
      callback.registerDidFail(error: error)
    }
  }

  func clientDidStart(_ client: SinchClient) {
    UserDefaults.standard.set(client.userId, forKey: CallKitMediator.userIDKey)
    UserDefaults.standard.synchronize()

    guard let callback = self.createCallback else { return }
    callback(nil)
    self.createCallback = nil
  }

  func clientDidFail(_ client: SinchClient, error: Error) {
    defer { self.client = nil }
    guard let callback = self.createCallback else { return }
    callback(error)
    self.createCallback = nil
  }
}
