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

#ifndef VIRGIL_CRYPTO_VIRGIL_DH_H
#define VIRGIL_CRYPTO_VIRGIL_DH_H

#include "../VirgilByteArray.h"

#include <memory>

namespace virgil { namespace crypto { inline namespace primitive {

/**
 * @brief Define proxy interface for the Diffie-Hellman functionality.
 *
 * @note This is experimental feature.
 */
class VirgilOperationDH {
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
    VirgilOperationDH(Impl impl) : self_(std::make_shared<Model<Impl>>(std::move(impl))) {}

    /**
     * @brief Compute shared key by using Diffie-Hellman algorithm.
     *
     * @param publicKey - public key of the side 1.
     * @param privateKey - private key of the side 2.
     * @param privateKeyPassword - private key password of the side 2.
     * @return Shared key.
     */
    VirgilByteArray calculate(
            const VirgilByteArray& publicKey, const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray()) const {
        return self_->doCalculate(publicKey, privateKey, privateKeyPassword);
    }

    /**
     * @brief Return default implementation.
     */
    static VirgilOperationDH getDefault();

private:
    struct Concept {

        virtual VirgilByteArray doCalculate(
                const VirgilByteArray& publicKey, const VirgilByteArray& privateKey,
                const VirgilByteArray& privateKeyPassword) const = 0;

        virtual ~Concept() noexcept = default;
    };

    template<class Impl>
    struct Model : Concept {

        explicit Model(Impl impl) : impl_(std::move(impl)) {}

        VirgilByteArray doCalculate(
                const VirgilByteArray& publicKey, const VirgilByteArray& privateKey,
                const VirgilByteArray& privateKeyPassword) const override {

            return impl_.calculate(publicKey, privateKey, privateKeyPassword);
        }

    private:
        Impl impl_;
    };

private:
    std::shared_ptr<const Concept> self_;
};

}}}

#endif //VIRGIL_CRYPTO_VIRGIL_DH_H
