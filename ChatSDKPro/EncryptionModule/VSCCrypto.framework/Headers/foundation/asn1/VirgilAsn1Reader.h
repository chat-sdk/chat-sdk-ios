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

#ifndef VIRGIL_CRYPTO_VIRGIL_ASN1_READER_H
#define VIRGIL_CRYPTO_VIRGIL_ASN1_READER_H

#include <cstdlib>
#include <string>

#include "../../VirgilByteArray.h"

namespace virgil { namespace crypto { namespace foundation { namespace asn1 {

/**
 * @brief This class provides methods for reading ASN.1 data structure.
 *
 * @note All "read*" methods perform reading of ASN.1 structure sequentially.
 * @note Implementation is not complete yet, only minimum set of operations are supported.
 */
class VirgilAsn1Reader {
public:
    /**
     * @brief Initialize internal state.
     */
    VirgilAsn1Reader();

    /**
     * @brief Initialize internal state with given ASN.1 structure.
     * @note The same as sequence VirgilAsn1Reader() and reset().
     */
    explicit VirgilAsn1Reader(const virgil::crypto::VirgilByteArray& data);

    /**
     * @brief Dispose internal resources.
     */
    ~VirgilAsn1Reader() noexcept;
    /**
     * @name Configure reading
     */
    ///@{
    /**
     * @brief Reset all internal states and prepare to new ASN.1 reading operations.
     * @param data - ASN.1 structure to be read.
     */
    void reset(const virgil::crypto::VirgilByteArray& data);
    ///@}
    /**
     * @name Read Simple ASN.1 Types
     */
    ///@{
    /**
     * @brief Read ASN.1 type: INTEGER.
     */
    int readInteger();

    /**
     * @brief Read ASN.1 type: BOOLEAN.
     */
    bool readBool();

    /**
     * @brief Read ASN.1 type: NULL.
     */
    void readNull();

    /**
     * @brief Read ASN.1 type: OCTET STRING.
     */
    virgil::crypto::VirgilByteArray readOctetString();

    /**
     * @brief Read ASN.1 type: UTF8String.
     */
    virgil::crypto::VirgilByteArray readUTF8String();

    /**
     * @brief Read preformatted ASN.1 structure.
     */
    virgil::crypto::VirgilByteArray readData();

    /**
     * @brief Read ASN.1 type: TAG.
     * @return Tag length if given tag exist, 0 - otherwise.
     */
    size_t readContextTag(unsigned char tag);

    /**
     * @brief Read ASN.1 type: OID.
     * @return OID.
     * TODO: Change return type to VirgilByteArray
     */
    std::string readOID();
    ///@}
    /**
     * @name Read Structured ASN.1 Types
     */
    ///@{
    /**
     * @brief Read ASN.1 type: SEQUENCE.
     * @return Sequence size in bytes.
     */
    size_t readSequence();

    /**
     * @brief Read ASN.1 type: SET.
     * @return Set size in bytes.
     */
    size_t readSet();
    ///@}
public:
    /**
     * @brief Delete copy constructor
     */
    VirgilAsn1Reader(const VirgilAsn1Reader& other) = delete;

    /**
     * @brief Delete assignment operator
     */
    VirgilAsn1Reader& operator=(const VirgilAsn1Reader& rhs) = delete;

    /**
     * @brief Use default move constructor
     */
    VirgilAsn1Reader(VirgilAsn1Reader&& other) = default;

    /**
     * @brief Use default move operator
     */
    VirgilAsn1Reader& operator=(VirgilAsn1Reader&& rhs) = default;

private:
    /**
     * @brief Check internal state before methods call.
     * @throw VirgilCryptoException - if internal state is not consistent.
     */
    void checkState();

private:
    unsigned char* p_;
    const unsigned char* end_;
    virgil::crypto::VirgilByteArray data_;
};

}}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_ASN1_READER_H */
