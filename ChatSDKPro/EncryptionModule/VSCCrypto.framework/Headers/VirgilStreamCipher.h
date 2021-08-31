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

#ifndef VIRGIL_STREAM_CIPHER_H
#define VIRGIL_STREAM_CIPHER_H

#include "VirgilCipherBase.h"

#include "VirgilByteArray.h"
#include "VirgilDataSource.h"
#include "VirgilDataSink.h"

namespace virgil { namespace crypto {

/**
 * @brief This class provides high-level interface to encrypt / decrypt streaming data using Virgil Security keys.
 */
class VirgilStreamCipher : public VirgilCipherBase {
public:
    /**
     * @brief Encrypt data read from given source and write it the sink.
     * @param source - source of the data to be encrypted.
     * @param sink - target sink for encrypted data.
     * @param embedContentInfo - determines whether to embed content info the the encrypted data, or not.
     * @note Store content info to use it for decription process, if embedContentInfo parameter is false.
     * @see getContentInfo()
     */
    void encrypt(VirgilDataSource& source, VirgilDataSink& sink, bool embedContentInfo = true);

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
     * @brief Attempt to read content info from the data source.
     * @return Data that was read from the source and is not content info.
     */
    VirgilByteArray tryReadContentInfo(VirgilDataSource& source);

    /**
     * @brief Decrypt data read from given source, and write it to the sink.
     */
    void decrypt(VirgilDataSource& source, VirgilDataSink& sink);
};

}}

#endif /* VIRGIL_STREAM_CIPHER_H */
