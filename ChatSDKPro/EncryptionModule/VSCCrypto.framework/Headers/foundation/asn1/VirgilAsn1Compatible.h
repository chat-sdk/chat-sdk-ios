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

#ifndef VIRGIL_CRYPTO_VIRGIL_ASN1_COMPATIBLE_H
#define VIRGIL_CRYPTO_VIRGIL_ASN1_COMPATIBLE_H

#include "../../VirgilByteArray.h"

/**
 * @name Forward declaration
 */
/// @{
namespace virgil { namespace crypto { namespace foundation { namespace asn1 {
class VirgilAsn1Reader;

class VirgilAsn1Writer;
}}}}
/// @}


namespace virgil { namespace crypto { namespace foundation { namespace asn1 {

/**
 * @brief This class provides interface that allow to save and restore object state in the ASN.1 structure.
 */
class VirgilAsn1Compatible {
public:
    /**
     * @brief Save object state to the ASN.1 structure.
     */
    virgil::crypto::VirgilByteArray toAsn1() const;

    /**
     * @brief Restore object state from the ASN.1 structure.
     */
    void fromAsn1(const virgil::crypto::VirgilByteArray& asn1);

    /**
     * @brief Polymorphic destructor.
     */
    virtual ~VirgilAsn1Compatible() noexcept { }

    /**
     * @brief Write object state to the writer.
     * @param asn1Writer writer that should be payloaded by subclasses.
     * @param childWrittenBytes count of bytes that was written by subclasses.
     * @return Writen bytes count.
     */
    virtual size_t asn1Write(VirgilAsn1Writer& asn1Writer, size_t childWrittenBytes = 0) const = 0;

    /**
     * @brief Read object state from the reader.
     * @param asn1Reader reader payloaded with ASN.1 to be read.
     */
    virtual void asn1Read(VirgilAsn1Reader& asn1Reader) = 0;

protected:
    /**
     * @brief If given parameter is empty exception will be thrown.
     * @throw virgil::crypto::VirgilCryptoException.
     */
    virtual void checkRequiredField(const VirgilByteArray& param) const;
};

}}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_ASN1_COMPATIBLE_H */
