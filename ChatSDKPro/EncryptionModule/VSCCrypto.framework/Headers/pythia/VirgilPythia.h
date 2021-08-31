/**
 * Copyright (C) 2015-2018 Virgil Security Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     (1) Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *     (2) Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *     (3) Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
 */

#ifndef virgilPythiaH
#define virgilPythiaH

#include "../VirgilByteArray.h"
#include "VirgilPythiaBlindResult.h"
#include "VirgilPythiaContext.h"
#include "VirgilPythiaTransformationKeyPair.h"
#include "VirgilPythiaProveResult.h"
#include "VirgilPythiaTransformResult.h"

namespace virgil {
namespace crypto {
namespace pythia {

/**
 * @brief This class provides PYTHIA cryptographic functions and primitives.
 *
 * PYTHIA is a verifiable, cryptographic protocol that hardens passwords
 * with the help of a remote service.
 *
 * @ingroup pythia
 */
class VirgilPythia {
public:

    /**
     * @brief Blinds password.
     *
     * Turns password into a pseudo-random string.
     * This step is necessary to prevent 3rd-parties from knowledge of end user's password.
     *
     * @param password - end user's password.
     * @return VirgilPythiaBlindResult
     */
    VirgilPythiaBlindResult blind(const VirgilByteArray& password);

    /**
     * @brief Deblinds transformedPassword value with previously returned blindingSecret from blind().
     *
     * @param transformedPassword - GT transformed password from transform().
     * @param blindingSecret - BN value that was generated in blind().
     *
     * @return Deblinded transformedPassword value.
     *         This value is not equal to password and is zero-knowledge protected.
     */
    VirgilByteArray
    deblind(const VirgilByteArray& transformedPassword, const VirgilByteArray& blindingSecret);

    /**
     * @brief Computes transformation private and public key.
     *
     * @param transformationKeyID - ensemble key ID used to enclose operations in subsets.
     * @param pythiaSecret - global common for all secret random Key.
     * @param pythiaScopeSecret - ensemble secret generated and versioned transparently.
     *
     * @return VirgilPythiaTransformationKeyPair
     */
    VirgilPythiaTransformationKeyPair
    computeTransformationKeyPair(const VirgilByteArray& transformationKeyID, const VirgilByteArray& pythiaSecret,
                                 const VirgilByteArray& pythiaScopeSecret);

    /**
     * @brief Transforms blinded password using the private key, generated from pythiaSecret + pythiaScopeSecret.
     *
     * @param blindedPassword - G1 password obfuscated into a pseudo-random string.
     * @param tweak - some random value used to identify user
     * @param transformationPrivateKey - BN transformation private key.
     *
     * @return VirgilPythiaTransformResult
     */
    VirgilPythiaTransformResult transform(
            const VirgilByteArray& blindedPassword, const VirgilByteArray& tweak,
            const VirgilByteArray& transformationPrivateKey);

    /**
     * @brief Generates proof that server possesses secret values that were used to transform password.
     *
     * @param transformedPassword - GT transformed password from transform()
     * @param blindedPassword - G1 blinded password from blind().
     * @param transformedTweak - G2 transformed tweak from transform().
     * @param transformationKeyPair - transformation key pair.
     *
     * @return VirgilPythiaProveResult
     */
    VirgilPythiaProveResult
    prove(const VirgilByteArray& transformedPassword, const VirgilByteArray& blindedPassword,
          const VirgilByteArray& transformedTweak, const VirgilPythiaTransformationKeyPair& transformationKeyPair);

    /**
     * @brief Verifies the output of transform().
     *
     * This operation allows client to verify that the output of transform() is correct,
     * assuming that client has previously stored tweak.
     *
     * @param transformedPassword - GT transformed password from transform()
     * @param blindedPassword - G1 blinded password from blind().
     * @param tweak - tweak from transform()
     * @param transformationPublicKey - G1 transformation public key
     * @param proofValueC - BN proof value C from prove()
     * @param proofValueU - BN proof value U from prove()
     *
     * @return true if output of transform() is correct, false - otherwise.
     */
    bool
    verify(const VirgilByteArray& transformedPassword, const VirgilByteArray& blindedPassword,
           const VirgilByteArray& tweak, const VirgilByteArray& transformationPublicKey,
           const VirgilByteArray& proofValueC, const VirgilByteArray& proofValueU);

    /**
     * @brief Computes update token.
     *
     * Computes update token which allows update deblindedPassword when rotating transformation private key
     * This action should increment version of pythiaScopeSecret.
     *
     * @param previousTransformationPrivateKey - transformation private key
     * @param newTransformationPrivateKey - new transformation private key
     *
     * @return VirgilBteArray
     */
    VirgilByteArray getPasswordUpdateToken(
            const VirgilByteArray& previousTransformationPrivateKey,
            const VirgilByteArray& newTransformationPrivateKey);

    /**
     * @brief Updates previously stored deblindedPassword with passwordUpdateToken.
     *
     * After this call, transform() called with new arguments will return corresponding values.
     *
     * @param deblindedPassword - GT previous deblinded password from deblind().
     * @param passwordUpdateToken - BN password update token from getPasswordUpdateToken().
     *
     * @return New deblinded password.
     */
    VirgilByteArray updateDeblindedWithToken(
            const VirgilByteArray& deblindedPassword, const VirgilByteArray& passwordUpdateToken);

private:
    VirgilPythiaContext pythiaContext;
};

} // namespace pythia
} // namespace crypto
} // namespace virgil

#endif /* virgilPythiaH */
