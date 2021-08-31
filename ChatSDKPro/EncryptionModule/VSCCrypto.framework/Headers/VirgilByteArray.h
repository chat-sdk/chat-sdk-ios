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

#ifndef VIRGIL_BYTE_ARRAY_H
#define VIRGIL_BYTE_ARRAY_H

#include <string>
#include <vector>
#include <tuple>

namespace virgil { namespace crypto {

/**
 * @typedef VirgilByteArray
 * @brief This type represents a sequence of bytes.
 */
typedef std::vector<unsigned char> VirgilByteArray;

}}

/**
 * @name ByteArray conversation utilities
 */
/// @{
#define VIRGIL_BYTE_ARRAY_TO_PTR_AND_LEN(array) reinterpret_cast<const unsigned char *>(array.data()), array.size()

#define VIRGIL_BYTE_ARRAY_FROM_PTR_AND_LEN(ptr, len)\
        virgil::crypto::VirgilByteArray(reinterpret_cast<virgil::crypto::VirgilByteArray::const_pointer >(ptr), \
        reinterpret_cast<virgil::crypto::VirgilByteArray::const_pointer >((ptr) + (len)))
///@}

namespace virgil { namespace crypto {

/**
 * @brief Represents given string as byte array.
 */
VirgilByteArray str2bytes(const std::string& str);

/**
 * @brief Represent given byte array as string.
 */
std::string bytes2str(const VirgilByteArray& array);

/**
 * @brief Translate given HEX string to the byte array.
 * @param hexStr - HEX string.
 * @return Byte array.
 */
VirgilByteArray hex2bytes(const std::string hexStr);

/**
 * @brief Translate given byte array to the HEX string.
 * @param array - byte array.
 * @param formatted - if true, endline will be inserted every 16 bytes,
 *                    and all bytes will be separated with whitespaces.
 * @return HEX string.
 */
std::string bytes2hex(const VirgilByteArray& array, bool formatted = false) ;

/**
 * @name ByteArray security clear utilities
 */
///@{
/**
 * @brief Make all bytes zero.
 */
void bytes_zeroize(VirgilByteArray& array) ;

/**
 * @brief Make all chars zero.
 */
void string_zeroize(std::string& str);
///@}

/**
 * @brief Append given source bytes to the existing destination bytes.
 * @param dst - bytes append to.
 * @param src - bytes append from.
 * @return Reference to destination (dst).
 */
VirgilByteArray& bytes_append(VirgilByteArray& dst, const VirgilByteArray& src);

/**
 * @brief Split given bytes to two sequences.
 * @param src - bytes to be splitted.
 * @param pos - splitting position.
 * @return Two sequences: src[0, pos), src[pos, src.size()).
 */
std::tuple<VirgilByteArray, VirgilByteArray> bytes_split(const VirgilByteArray& src, size_t pos);

/**
 * @brief Split given bytes to two sequences of the same size.
 * @param src - bytes to be splitted.
 * @return Two sequences: src[0, src.size()/2), src[src.size()/2, src.size()).
 */
std::tuple<VirgilByteArray, VirgilByteArray> bytes_split_half(const VirgilByteArray& src);

/**
 * @brief Split given bytes to the chuns of the given size.
 * @param src - bytes to be splitted.
 * @param chunkSize - size of the chunk.
 * @return Chunks, each of the chunkSize.
 */
std::vector<VirgilByteArray> bytes_split_chunks(const VirgilByteArray& src, size_t chunkSize);

}}
#endif /* VIRGIL_BYTE_ARRAY_H */
