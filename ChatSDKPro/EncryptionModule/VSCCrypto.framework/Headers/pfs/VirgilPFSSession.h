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

#ifndef VIRGIL_CRYPTO_PFS_VIRGIL_PFS_SESSION_H
#define VIRGIL_CRYPTO_PFS_VIRGIL_PFS_SESSION_H

#include "../VirgilByteArray.h"

#include <string>

namespace virgil { namespace crypto { namespace pfs {

class VirgilPFS;

/**
 * @brief This is model object that represent session in PFS communication.
 *
 * Session is a set of parameters that is unique for each communication.
 *
 * @see VirgilPFS
 * @ingroup pfs
 */
class VirgilPFSSession {
public:
    /**
     * @brief Create empty session.
     */
    VirgilPFSSession();

    /**
     * @param identifier - session unique identifier.
     * @param encryptionSecretKey - key that is used for encryption.
     * @param decryptionSecretKey - key that is used for decryption.
     * @param additionalData - data that is associated with both sides that is used in communication.
     */
    VirgilPFSSession(
        VirgilByteArray identifier, VirgilByteArray encryptionSecretKey,
        VirgilByteArray decryptionSecretKey, VirgilByteArray additionalData);

    /**
     * @return True if session is not defined.
     */
    bool isEmpty() const;

    /**
     * @brief Getter.
     * @see VirgilPFSSession()
     */
    const VirgilByteArray& getIdentifier() const;

    /**
     * @brief Getter.
     * @see VirgilPFSSession()
     */
    const VirgilByteArray& getEncryptionSecretKey() const;

    /**
     * @brief Getter.
     * @see VirgilPFSSession()
     */
    const VirgilByteArray& getDecryptionSecretKey() const;

    /**
     * @brief Getter.
     * @see VirgilPFSSession()
     */
    const VirgilByteArray& getAdditionalData() const;

private:
    friend VirgilPFS;
    VirgilByteArray identifier_;
    VirgilByteArray encryptionSecretKey_;
    VirgilByteArray decryptionSecretKey_;
    VirgilByteArray additionalData_;
};

}}}

#endif //VIRGIL_CRYPTO_PFS_VIRGIL_PFS_SESSION_H
