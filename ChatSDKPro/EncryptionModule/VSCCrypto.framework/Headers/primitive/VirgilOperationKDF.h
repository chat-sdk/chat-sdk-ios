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

#ifndef VIRGIL_CRYPTO_VIRGIL_KDF_H
#define VIRGIL_CRYPTO_VIRGIL_KDF_H

#include "../VirgilByteArray.h"

#include <memory>

namespace virgil { namespace crypto { inline namespace primitive {

/**
 * @brief Define proxy interface for the Key Derivation Function functionality.
 *
 * @note This is experimental feature.
 */
class VirgilOperationKDF {
private:
    template<class Impl>
    struct Model;

public:
    /**
     * @brief Captures implementation object.
     * @tparam Impl - class that contains functions that has identical signature to this class functions.
     * @param impl - object that implements interface.
     */
    template<class Impl>
    VirgilOperationKDF(Impl impl):self_(std::make_shared<Model<Impl>>(std::move(impl))) {}

    /**
     * @brief Derive key from the given key material and additional options.
     *
     * @param keyMaterial - input sequence (key material).
     * @param salt - optional salt value (a non-secret random value).
     * @param info - optional context and application specific information.
     * @param size - size of the output sequence.
     * @return Output sequence.
     */
    VirgilByteArray derive(
        const VirgilByteArray& keyMaterial, const VirgilByteArray& salt,
        const VirgilByteArray& info, size_t size) const {
        return self_->doDerive(keyMaterial, salt, info, size);
    }

    /**
     * @brief Return default implementation.
     */
    static VirgilOperationKDF getDefault();

private:
    struct Concept {
        virtual VirgilByteArray doDerive(
            const VirgilByteArray& keyMaterial, const VirgilByteArray& salt,
            const VirgilByteArray& info, size_t size) const = 0;

        virtual ~Concept() noexcept = default;
    };

    template<class Impl>
    struct Model : Concept {

        explicit Model(Impl impl) : impl_(std::move(impl)) {}

        VirgilByteArray doDerive(
            const VirgilByteArray& keyMaterial, const VirgilByteArray& salt,
            const VirgilByteArray& info, size_t size) const override {

            return impl_.derive(keyMaterial, salt, info, size);
        }

    private:
        Impl impl_;
    };

private:
    std::shared_ptr<const Concept> self_;
};

}}}

#endif //VIRGIL_CRYPTO_VIRGIL_KDF_H
