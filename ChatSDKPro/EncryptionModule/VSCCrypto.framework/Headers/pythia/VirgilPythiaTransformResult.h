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

#ifndef VIRGIL_PYTHIA_TRANSFORM_RESULT_H
#define VIRGIL_PYTHIA_TRANSFORM_RESULT_H

#include "../VirgilByteArray.h"

namespace virgil {
namespace crypto {
namespace pythia {

/**
 * @brief Handles result of the method VirgilPythia::transform().
 * @ingroup pythia
 */
class VirgilPythiaTransformResult {
public:
    /**
     * @brief Encapsulate given data.
     *
     * @param transformedPassword - GT blinded password, protected using server secret
     *        (pythia_secret + pythia_scope_secret + tweak).
     * @param transformedTweak - G2 tweak value turned into an elliptic curve point.
     *        This value is used by Prove() operation.
     */
    explicit VirgilPythiaTransformResult(
            VirgilByteArray transformedPassword, VirgilByteArray transformedTweak)
            : transformedPassword_(std::move(transformedPassword)),
              transformedTweak_(std::move(transformedTweak)) {
    }

    /**
     * @return GT blinded password, protected using server secret
     *        (pythia_secret + pythia_scope_secret + tweak).
     */
    const VirgilByteArray& transformedPassword() const {
        return transformedPassword_;
    }

    /**
     * @return G2 tweak value turned into an elliptic curve point.
     *         This value is used by VirgilPythia::prove() operation.
     */
    const VirgilByteArray& transformedTweak() const {
        return transformedTweak_;
    }

private:
    const VirgilByteArray transformedPassword_;
    const VirgilByteArray transformedTweak_;
};

} // namespace pythia
} // namespace crypto
} // namespace virgil

#endif /* VIRGIL_PYTHIA_TRANSFORM_RESULT_H */
