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

#ifndef VIRGIL_CRYPTO_BYTE_ARRAY_UTILS_H
#define VIRGIL_CRYPTO_BYTE_ARRAY_UTILS_H

#include <string>

#include "VirgilByteArray.h"

namespace virgil { namespace crypto {

/**
 * @brief This class contains conversion utils for byte sequence.
 */
class VirgilByteArrayUtils {
public:
    /**
     * @brief Represents given JSON object as byte array in canonical form.
     *
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidFormat, if JSON is invalid.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidArgument,
     *     if JSON contains unsupported data types: i.e. double.
     *
     * @note Conversion it to canonical form, ensure the same digest of JSON object,
     *     that can be differently formatted.
     *
     * @note This method SHOULD be used before sign of JSON data object.
     *
     * @note Underlying canonical representation is ASN.1, but it can be changed in the future.
     */
    static VirgilByteArray jsonToBytes(const std::string& json);

    /**
     * @brief Represents given string as byte array.
     */
    static VirgilByteArray stringToBytes(const std::string& str);

    /**
     * @brief Represent given byte array as string.
     */
    static std::string bytesToString(const VirgilByteArray& array);

    /**
     * @brief Translate given HEX string to the byte array.
     * @param hexStr - HEX string.
     * @return Byte array.
     */
    static VirgilByteArray hexToBytes(const std::string& hexStr);

    /**
     * @brief Translate given byte array to the HEX string.
     * @param array - byte array.
     * @param formatted - if true, endline will be inserted every 16 bytes,
     *                    and all bytes will be separated with whitespaces.
     * @return HEX string.
     */
    static std::string bytesToHex(const VirgilByteArray& array, bool formatted = false);

    /**
     * @brief Make all bytes zero.
     *
     * This method SHOULD be used to securely delete sensitive data.
     */
    static void zeroize(VirgilByteArray& array);

    /**
     * @brief Append given bytes to the existing one.
     * @param dst - destination.
     * @param src - source.
     */
    static void append(VirgilByteArray& dst, const VirgilByteArray& src);

    /**
     * @brief Return first num bytes and remove it from the src
     */
    static VirgilByteArray popBytes(VirgilByteArray& src, size_t num);

private:
    /**
     * @brief Deny object creation.
     */
    VirgilByteArrayUtils();
};

}}

#endif /* VIRGIL_CRYPTO_BYTE_ARRAY_UTILS_H */
