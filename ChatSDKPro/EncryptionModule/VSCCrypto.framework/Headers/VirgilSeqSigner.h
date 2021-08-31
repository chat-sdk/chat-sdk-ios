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

#ifndef VIRGIL_SEQ_SIGNER_H
#define VIRGIL_SEQ_SIGNER_H

#include "VirgilSignerBase.h"

#include "VirgilByteArray.h"
#include "foundation/VirgilHash.h"

#include <memory>

namespace virgil { namespace crypto {

/**
 * @brief This class provides high-level interface to sign and verify data using Virgil Security keys.
 *
 * This module can sign / verify data that is fed to the signer sequentially.
 */
class VirgilSeqSigner : public VirgilSignerBase {
public:
    /**
     * @brief Create signer with predefined hash function.
     * @note Specified hash function algorithm is used only during signing.
     */
    explicit VirgilSeqSigner (
            foundation::VirgilHash::Algorithm hashAlgorithm = foundation::VirgilHash::Algorithm::SHA384);

    /**
     * Start new data signing.
     */
    void startSigning();

    /**
     * Start new data verifying.
     * @param signature -
     */
    void startVerifying(const VirgilByteArray& signature);

    /**
     * Append new data chunk to be signed or verified.
     * @param data - next data chunk.
     */
    void update(const VirgilByteArray& data);

    /**
     * @brief Sign data that was collected by update() function.
     * @return Virgil Security sign.
     */
    VirgilByteArray sign(const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());

    /**
     * @brief Verify sign and data that was collected by update() function to be conformed to the given public key.
     * @return true if sign is valid and data was not malformed.
     */
    bool verify(const VirgilByteArray& publicKey);

private:
    VirgilByteArray unpackedSignature_;
    foundation::VirgilHash hash_;
};

}}

#endif /* VIRGIL_SEQ_SIGNER_H */
