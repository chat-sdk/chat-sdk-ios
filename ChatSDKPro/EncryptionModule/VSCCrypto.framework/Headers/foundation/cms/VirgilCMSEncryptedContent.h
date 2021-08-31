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

#ifndef VIRGIL_CRYPTO_VIRGIL_CMS_ENCRYPTED_CONTENT_H
#define VIRGIL_CRYPTO_VIRGIL_CMS_ENCRYPTED_CONTENT_H

#include "../asn1/VirgilAsn1Compatible.h"
#include "../../VirgilByteArray.h"

namespace virgil { namespace crypto { namespace foundation { namespace cms {

/**
 * @brief Data object that represent CMS structure: EncryptedContentInfo.
 * @see RFC 5652 section 6.1.
 */
class VirgilCMSEncryptedContent : public virgil::crypto::foundation::asn1::VirgilAsn1Compatible {
public:
    /**
     * @property contentEncryptionAlgorithm
     * @brief Content encryption algorithm identifier (ASN.1 AlgorithmIdentifier structure).
     */
    virgil::crypto::VirgilByteArray contentEncryptionAlgorithm;
    /**
     * @property encryptedContent
     * @brief Content encrypted by algorithm defined in property @link contentEncryptionAlgorithm @endlink.
     */
    virgil::crypto::VirgilByteArray encryptedContent;
public:
    /**
     * @name VirgilAsn1Compatible implementation
     * @code
     * Marshalling format:
     *     EncryptedContentInfo ::= SEQUENCE {
     *         contentType ContentType, -- always PKCS#7 data format with OID: 1.2.840.113549.1.7.1
     *         contentEncryptionAlgorithm ContentEncryptionAlgorithmIdentifier,
     *         encryptedContent [0] IMPLICIT EncryptedContent OPTIONAL
     *     }
     *
     *     ContentType ::= OBJECT IDENTIFIER
     *
     *     ContentEncryptionAlgorithmIdentifier ::= AlgorithmIdentifier
     *
     *     EncryptedContent ::= OCTET STRING
     * @endcode
     */
    ///@{
    virtual size_t asn1Write(
            virgil::crypto::foundation::asn1::VirgilAsn1Writer& asn1Writer,
            size_t childWrittenBytes = 0) const;

    virtual void asn1Read(virgil::crypto::foundation::asn1::VirgilAsn1Reader& asn1Reader);
    ///@}
};

}}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_CMS_ENCRYPTED_CONTENT_H */
