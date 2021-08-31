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

#ifndef VIRGIL_PYTHIA_TRANSFORMATION_KEY_PAIR_H
#define VIRGIL_PYTHIA_TRANSFORMATION_KEY_PAIR_H

#include "../VirgilByteArray.h"

namespace virgil {
namespace crypto {
namespace pythia {

/**
 * @brief Handles result of the method VirgilPythia::computeTransformationKeyPair().
 * @ingroup pythia
 */
class VirgilPythiaTransformationKeyPair {
public:
    /**
     * @brief Encapsulate given data.
     *
     * @param privateKey - BN transformation private key.
     * @param publicKey - G1 Transformation public key.
     */
    explicit VirgilPythiaTransformationKeyPair(
            VirgilByteArray privateKey, VirgilByteArray publicKey)
            : privateKey_(std::move(privateKey)),
              publicKey_(std::move(publicKey)) {
    }

    /**
     * @return G1 Transformation public key.
     */
    const VirgilByteArray& publicKey() const {
        return publicKey_;
    }

    /**
     * @return BN transformation private key.
     */
    const VirgilByteArray& privateKey() const {
        return privateKey_;
    }

private:
    const VirgilByteArray privateKey_;
    const VirgilByteArray publicKey_;
};

} // namespace pythia
} // namespace crypto
} // namespace virgil

#endif /* VIRGIL_PYTHIA_TRANSFORMATION_KEY_PAIR_H */
