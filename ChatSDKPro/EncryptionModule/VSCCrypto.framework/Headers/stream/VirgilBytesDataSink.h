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

#ifndef VIRGIL_CRYPTO_VIRGIL_BYTES_DATA_SINK_H
#define VIRGIL_CRYPTO_VIRGIL_BYTES_DATA_SINK_H

#include "../VirgilDataSink.h"

namespace virgil { namespace crypto { namespace stream {

/**
 * @brief C++ Byte Array implementation of the VirgilDataSink class.
 *
 * @note This class CAN not be used in wrappers.
 */
class VirgilBytesDataSink : public virgil::crypto::VirgilDataSink {
public:
    /**
     * @brief Creates data sink based on byte array.
     */
    explicit VirgilBytesDataSink(virgil::crypto::VirgilByteArray& out);

    /**
     * @brief Polymorphic destructor.
     */
    virtual ~VirgilBytesDataSink() noexcept;

    /**
     * @brief Overriding of @link VirgilDataSink::isGood() @endlink method.
     */
    virtual bool isGood();

    /**
     * @brief Overriding of @link VirgilDataSink::write() @endlink method.
     */
    virtual void write(const virgil::crypto::VirgilByteArray& data);

    /**
     * @brief Reset internal state to initial.
     *
     * Erase all data from the output byte array.
     */
    virtual void reset();

private:
    virgil::crypto::VirgilByteArray& out_;
};

}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_BYTES_DATA_SINK_H */
