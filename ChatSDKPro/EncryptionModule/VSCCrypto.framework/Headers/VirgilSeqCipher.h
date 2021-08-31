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

#ifndef VIRGIL_SEQ_CIPHER_H
#define VIRGIL_SEQ_CIPHER_H

#include <vector>

#include "VirgilCipherBase.h"
#include "VirgilByteArray.h"

namespace virgil { namespace crypto {

/**
 * @brief This class provides high-level interface to sequenctially encrypt / decrypt data using Virgil Security keys.
 */
class VirgilSeqCipher : public VirgilCipherBase {
public:
    /**
     * @brief Start sequential encryption process.
     * @note Store content info to use it for decryption process, or use it as beginning of encrypted data (embedding).
     * @return Content info.
     */
    VirgilByteArray startEncryption();

    /**
     * @brief Start sequential decryption for recipient defined by id and private key.
     * @note Content info MUST be defined, if it was not embedded to the encrypted data.
     * @see method setContentInfo().
     */
    void startDecryptionWithKey(
            const VirgilByteArray& recipientId, const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());
    /**
     * @brief Start sequential decryption for recipient defined by id and private key.
     * @note Content info MUST be defined, if it was not embedded to the encrypted data.
     * @see method setContentInfo().
     */
    void startDecryptionWithPassword(const VirgilByteArray& pwd);

    /**
     * Encrypt or decrypt given data depends on the current sequential mode.
     * @param  data - plain text, if cipher in the encryption mode, encrypted data, if cipher in the decryption mode.
     * @return plain text, if cipher in the decryption mode, encrypted data, if cipher in the encryption mode.
     */
    VirgilByteArray process(const VirgilByteArray& data);

    /**
     * Accomplish sequential encryption or decryption depends on the mode.
     * @return plain text, if cipher in the decryption mode, encrypted data, if cipher in the encryption mode.
     */
    VirgilByteArray finish();

private:
    /**
     * @brief Decrypt given data.
     * @return Decrypted data.
     */
    VirgilByteArray decrypt(const VirgilByteArray& encryptedData);
};

}}

#endif /* VIRGIL_SEQ_CIPHER_H */
