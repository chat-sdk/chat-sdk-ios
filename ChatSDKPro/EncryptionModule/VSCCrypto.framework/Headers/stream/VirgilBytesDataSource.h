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

#ifndef VIRGIL_CRYPTO_VIRGIL_BYTES_DATA_SOURCE_H
#define VIRGIL_CRYPTO_VIRGIL_BYTES_DATA_SOURCE_H

#include "../VirgilByteArray.h"
#include "../VirgilDataSource.h"

namespace virgil { namespace crypto { namespace stream {

/**
 * @brief C++ Byte Array implementation of the VirgilDataSource class.
 *
 * @note This class CAN not be used in wrappers.
 */
class VirgilBytesDataSource : public virgil::crypto::VirgilDataSource {
public:
    /**
     * @brief Creates data sink based on byte array.
     * @param in - byte array.
     * @param chunkSize - size of the data that will be returned by @link read() @endlink method.
     *                    Note, the real value may be different from the given value, it is only recommendation.
     */
    explicit VirgilBytesDataSource(const virgil::crypto::VirgilByteArray& in, size_t chunkSize = 1);

    /**
     * @brief Polymorphic destructor.
     */
    virtual ~VirgilBytesDataSource() noexcept;

    /**
     * @brief Overriding of @link VirgilDataSource::hasData() @endlink method.
     */
    virtual bool hasData();

    /**
     * @brief Overriding of @link VirgilDataSource::read() @endlink method.
     */
    virtual virgil::crypto::VirgilByteArray read();

    /**
     * @brief Reset internal state to initial.
     *
     * This method can used for secondary data reading.
     */
    virtual void reset();

private:
    const virgil::crypto::VirgilByteArray& in_;
    const size_t chunkSize_;
    size_t leftBytes_;
};

}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_BYTES_DATA_SOURCE_H */
