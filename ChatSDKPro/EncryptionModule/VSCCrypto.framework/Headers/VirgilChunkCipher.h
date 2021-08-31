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

#ifndef VIRGIL_CHUNK_CIPHER_H
#define VIRGIL_CHUNK_CIPHER_H

#include <cstdlib>

#include "VirgilCipherBase.h"
#include "VirgilByteArray.h"
#include "VirgilDataSource.h"
#include "VirgilDataSink.h"

namespace virgil { namespace crypto {

/**
 * @brief This class provides high-level interface to encrypt / decrypt data splitted to chunks.
 * @note Virgil Security keys is used for encryption and decryption.
 * @note This class algorithms are not compatible with VirgilCipher and VirgilStreamCipher class algorithms.
 */
class VirgilChunkCipher : public VirgilCipherBase {
public:
    /**
     * @name Constants
     */
    ///@{
    /**
     * @property kPreferredChunkSize
     * @brief Recommended chunk size.
     */
    static constexpr size_t kPreferredChunkSize = 1024 * 1024;
    ///@}
public:
    /**
     * @brief Encrypt data read from given source and write it the sink.
     * @param source - source of the data to be encrypted.
     * @param sink - target sink for encrypted data.
     * @param preferredChunkSize - chunk size that will appropriate.
     * @param embedContentInfo - determines whether to embed content info the the encrypted data, or not.
     * @note Store content info to use it for before decription process in future,
     *     if embedContentInfo parameter is false @link getContentInfo() @endlink.
     */
    void encrypt(
            VirgilDataSource& source, VirgilDataSink& sink, bool embedContentInfo = true,
            size_t preferredChunkSize = kPreferredChunkSize);

    /**
     * @brief Decrypt data read from given source for recipient defined by id and private key,
     *     and write it to the sink.
     * @note Content info MUST be defined, if it was not embedded to the encrypted data.
     * @see method setContentInfo().
     */
    void decryptWithKey(
            VirgilDataSource& source, VirgilDataSink& sink, const VirgilByteArray& recipientId,
            const VirgilByteArray& privateKey, const VirgilByteArray& privateKeyPassword = VirgilByteArray());

    /**
     * @brief Decrypt data read from given source for recipient defined by password,
     *     and write it to the sink.
     * @note Content info MUST be defined, if it was not embedded to the encrypted data.
     * @see method setContentInfo().
     */
    void decryptWithPassword(VirgilDataSource& source, VirgilDataSink& sink, const VirgilByteArray& pwd);

private:
    /**
     * @brief Store actual chunk size in the custom parameters.
     */
    void storeChunkSize(size_t chunkSize);

    /**
     * @brief Retrieve actual chunk size from the custom parameters.
     */
    size_t retrieveChunkSize() const;

    /**
     * @brief Do encryption / decryption depends on the configured mode.
     */
    void process(VirgilDataSource& source, VirgilDataSink& sink, size_t actualChunkSize);
};

}}

#endif /* VIRGIL_CHUNK_CIPHER_H */
