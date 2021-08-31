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

#ifndef VIRGIL_CRYPTO_FOUNDATION_VIRGIL_HKDF_H
#define VIRGIL_CRYPTO_FOUNDATION_VIRGIL_HKDF_H

#include "../VirgilByteArray.h"
#include "VirgilHash.h"

namespace virgil { namespace crypto { namespace foundation {

/**
 * @brief Implements HMAC-based Extract-and-Expand Key Derivation Function (RFC 5869)
 * @see https://tools.ietf.org/html/rfc5869
 * @ingroup kdf
 */
class VirgilHKDF {
public:
    /**
     * @brief Define parameters for HKDF algorithm.
     * @param hashAlgorithm - underlying hash algorithm.
     */
    VirgilHKDF(VirgilHash::Algorithm hashAlgorithm);

    /**
     * @brief Derive key from the given key material and additional options.
     *
     * @param in - input sequence (key material).
     * @param salt - optional salt value (a non-secret random value).
     * @param info - optional context and application specific information.
     * @param outSize - size of the output sequence.
     * @return Output sequence.
     *
     * @note This function make sense only for HKDF algorithm.
     */
    virgil::crypto::VirgilByteArray derive(
            const virgil::crypto::VirgilByteArray& in, const virgil::crypto::VirgilByteArray& salt,
            const virgil::crypto::VirgilByteArray& info, size_t outSize) const;

private:
    virgil::crypto::VirgilByteArray extract(
            const virgil::crypto::VirgilByteArray& keyMaterial, const virgil::crypto::VirgilByteArray& salt) const;

    virgil::crypto::VirgilByteArray expand(
            const virgil::crypto::VirgilByteArray& pseudoRandomKey, const virgil::crypto::VirgilByteArray& info,
            size_t outSize) const;

private:
    const VirgilHash::Algorithm hashAlgorithm_;
};

}}}

#endif //VIRGIL_CRYPTO_FOUNDATION_VIRGIL_HKDF_H
