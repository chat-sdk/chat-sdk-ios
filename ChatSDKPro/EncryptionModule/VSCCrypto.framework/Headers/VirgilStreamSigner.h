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

#ifndef VIRGIL_STREAM_SIGNER_H
#define VIRGIL_STREAM_SIGNER_H

#include "VirgilSignerBase.h"

#include "VirgilByteArray.h"
#include "VirgilDataSource.h"
#include "foundation/VirgilHash.h"

namespace virgil { namespace crypto {

/**
 * @brief This class provides high-level interface to sign and verify data using Virgil Security keys.
 *
 * This module can sign / verify data provided by stream.
 */
class VirgilStreamSigner : public VirgilSignerBase {
public:
    /**
     * @brief Create signer with predefined hash function.
     * @note Specified hash function algorithm is used only during signing.
     */
    explicit VirgilStreamSigner (
            foundation::VirgilHash::Algorithm hashAlgorithm =
            foundation::VirgilHash::Algorithm::SHA384) : VirgilSignerBase (hashAlgorithm) {};

    /**
     * @brief Sign data provided by the source with given private key.
     * @return Virgil Security sign.
     */
    VirgilByteArray sign(
            VirgilDataSource& source, const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());

    /**
     * @brief Verify sign and data provided by the source to be conformed to the given public key.
     * @return true if sign is valid and data was not malformed.
     */
    bool verify(VirgilDataSource& source, const VirgilByteArray& sign, const VirgilByteArray& publicKey);
};

}}

#endif /* VIRGIL_STREAM_SIGNER_H */
