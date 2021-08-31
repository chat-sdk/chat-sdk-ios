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

#ifndef VIRGIL_CRYPTO_VIRGIL_HASH_H
#define VIRGIL_CRYPTO_VIRGIL_HASH_H

#include "../VirgilByteArray.h"

#include <memory>

namespace virgil { namespace crypto { inline namespace primitive {

/**
 * @brief Define proxy interface for the Hash (Message Digest) functionality.
 *
 * @note This is experimental feature.
 */
class VirgilOperationHash {
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
    VirgilOperationHash(Impl impl) : self_(new Model<Impl>(std::move(impl))) {}

    /**
     * @brief Calculate digest for given data.
     * @param data - data to be hashed.
     * @return Data's hash (message digest).
     */
    VirgilByteArray hash(const VirgilByteArray& data) {
        self_->doStart();
        self_->doUpdate(data);
        return self_->doFinish();
    }

    /**
     * @brief Prepare internal state for the new hashing.
     */
    void start() {
        self_->doStart();
    }

    /**
     * @brief Hash new portion of the data.
     * @param data - next portion of data to be hashed.
     */
    void update(const VirgilByteArray& data) {
        self_->doUpdate(data);
    }

    /**
     * @brief Finalize hashing.
     * @return Data's hash (message digest).
     */
    VirgilByteArray finish() {
        return self_->doFinish();
    }

    /**
     * @brief Return default implementation.
     */
    static VirgilOperationHash getDefault();

    //! @cond Doxygen_Suppress
    VirgilOperationHash(const VirgilOperationHash& other) : self_(other.self_->doCopy()) {}

    VirgilOperationHash(VirgilOperationHash&& other)noexcept = default;

    VirgilOperationHash& operator=(const VirgilOperationHash& other) {
        VirgilOperationHash tmp(other);
        *this = std::move(tmp);
        return *this;
    }

    VirgilOperationHash& operator=(VirgilOperationHash&& other) noexcept= default;

    ~VirgilOperationHash() noexcept = default;
    //! @endcond

private:
    struct Concept {
        virtual Concept* doCopy() const = 0;

        virtual void doStart() = 0;

        virtual void doUpdate(const VirgilByteArray& data) = 0;

        virtual VirgilByteArray doFinish() = 0;

        virtual ~Concept() noexcept = default;
};

    template<class Impl>
    struct Model : Concept {

        explicit Model(Impl impl) : impl_(std::move(impl)) {}

        Concept* doCopy() const override {
            return new Model(*this);
        }

        void doStart() override {
            return impl_.start();
        }

        void doUpdate(const VirgilByteArray& data) override {
            impl_.update(data);
        }

        VirgilByteArray doFinish() override {
            return impl_.finish();
        }

    private:
        Impl impl_;
    };

private:
    std::unique_ptr<Concept> self_;
};

}}}

#endif //VIRGIL_CRYPTO_VIRGIL_HASH_H
