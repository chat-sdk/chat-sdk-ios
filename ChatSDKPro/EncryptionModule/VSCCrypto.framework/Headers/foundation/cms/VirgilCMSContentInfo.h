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

#ifndef VIRGIL_CRYPTO_VIRGIL_CMS_CONTENT_INFO_H
#define VIRGIL_CRYPTO_VIRGIL_CMS_CONTENT_INFO_H

#include <map>
#include <string>

#include "VirgilCMSContent.h"

#include "../asn1/VirgilAsn1Compatible.h"

#include "../../VirgilCustomParams.h"
#include "../../VirgilByteArray.h"

namespace virgil { namespace crypto { namespace foundation { namespace cms {

/**
 * @brief Data object that represent ASN.1 structure: VirgilCMSContentInfo.
 */
class VirgilCMSContentInfo : public asn1::VirgilAsn1Compatible {
public:
    /**
     * @property cmsContent
     * @brief CMS content.
     */
    VirgilCMSContent cmsContent;
    /**
     * @property customParams
     * @brief User defiend custom parameters.
     */
    virgil::crypto::VirgilCustomParams customParams;
public:
    /**
     * @brief Read content info size as part of the data.
     * @return Size of the content info if it is exist as part of the data, 0 - otherwise.
     */
    static size_t defineSize(const virgil::crypto::VirgilByteArray& data);
    /**
     * @name VirgilAsn1Compatible implementation
     * @code
     * Marshalling format:
     *     VirgilCMSContentInfo ::= SEQUENCE {
     *         version ::= INTEGER { v0(0) },
     *         cmsContent ContentInfo, -- Imports from RFC 5652
     *         customParams [0] IMPLICIT VirgilCustomParams OPTIONAL
     *     }
     * @endcode
     */
    ///@{
    size_t asn1Write(asn1::VirgilAsn1Writer& asn1Writer, size_t childWrittenBytes = 0) const override;

    void asn1Read(asn1::VirgilAsn1Reader& asn1Reader) override;
    ///@}
};

}}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_CMS_CONTENT_INFO_H */
