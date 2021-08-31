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

#ifndef VIRGIL_CRYPTO_SIGNER_BASE_H
#define VIRGIL_CRYPTO_SIGNER_BASE_H

#include "VirgilByteArray.h"
#include "foundation/VirgilHash.h"
#include "foundation/VirgilAsymmetricCipher.h"

namespace virgil { namespace crypto {

/**
 * @brief This class provides common functionality to sign and verify data using Virgil Security keys.
 */
class VirgilSignerBase {
public:
    /**
     * @brief Create signer with predefined hash function.
     * @note Specified hash function algorithm is used only during signing.
     */
    explicit VirgilSignerBase(
            foundation::VirgilHash::Algorithm hashAlgorithm = foundation::VirgilHash::Algorithm::SHA384);

    /**
     * @brief Return hash algorithm that SHOULD be used to calculate digest of the data to be signed.
     * @return Hash Algorithm.
     */
    foundation::VirgilHash::Algorithm getHashAlgorithm() const;

    /**
     * @brief Create signature over pre-calculated hash.
     *
     * @param digest - hash digest of the data.
     * @param privateKey - private key to be used for signature operation.
     * @param privateKeyPassword - private key password.
     * @return Signature.
     */
    VirgilByteArray signHash(
            const VirgilByteArray& digest, const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());

    /**
     * @brief Verify signature over pre-calculated hash.
     *
     * @param digest - hash digest of the data.
     * @param signature - signature.
     * @param publicKey - public key to be used for signature verification.
     * @return true if signature verification was successful, false - otherwise.
     */
    bool verifyHash(
            const VirgilByteArray& digest, const VirgilByteArray& signature,
            const VirgilByteArray& publicKey);

protected:
    /**
     * @brief Pack given signature to the ASN.1 structure.
     *
     * @code
     *     VirgilSignature ::= SEQUENCE {
     *         digestAlgorithm ::= AlgorithmIdentifier,
     *         signature ::= OCTET STRING
     *     }
     * @endcode
     *
     * @param signature - signature to be wrapped
     * @return Packed signature.
     * @note This function use value returned by function getHashAlgorithm().
     */
    VirgilByteArray packSignature(const VirgilByteArray& signature) const;

    /**
     * @brief Unpack signature and correspond hash algorithm from the ASN.1 structure.
     *
     * @code
     *     VirgilSignature ::= SEQUENCE {
     *         digestAlgorithm ::= AlgorithmIdentifier,
     *         signature ::= OCTET STRING
     *     }
     * @endcode
     *
     * @param packedSignature - signature packed within ASN.1 structure.
     * @return Signature.
     * @note This function has side-effect it changes object field VirgilSignerBase::hashAlgorithm_,
     *     that can be accessed via function getHashAlgorithm().
     */
    VirgilByteArray unpackSignature(const VirgilByteArray& packedSignature);

private:
    /**
     * @see signHash()
     */
    virtual VirgilByteArray doSignHash(
            const VirgilByteArray& digest, const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword);

    /**
     * @see verifyHash()
     */
    virtual bool doVerifyHash(
            const VirgilByteArray& digest, const VirgilByteArray& signature, const VirgilByteArray& publicKey);

private:
    foundation::VirgilHash hash_;
    foundation::VirgilAsymmetricCipher pk_;
};

}}

#endif /* VIRGIL_CRYPTO_SIGNER_BASE_H */
