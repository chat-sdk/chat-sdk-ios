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

#ifndef VIRGIL_CRYPTO_FOUNDATION_VIRGIL_HASH_H
#define VIRGIL_CRYPTO_FOUNDATION_VIRGIL_HASH_H

#include <string>
#include <memory>

#include "../VirgilByteArray.h"
#include "asn1/VirgilAsn1Compatible.h"

namespace virgil { namespace crypto { namespace foundation {

/**
 * @brief Provides hashing (message digest) algorithms.
 * @ingroup hash
 */
class VirgilHash : public virgil::crypto::foundation::asn1::VirgilAsn1Compatible {
public:
    /**
     * @brief Enumerates possible Hash algorithms.
     */
    enum class Algorithm {
        MD5,    ///< Hash Algorithm: MD5
        SHA1,   ///< Hash Algorithm: SHA1
        SHA224, ///< Hash Algorithm: SHA224
        SHA256, ///< Hash Algorithm: SHA256
        SHA384, ///< Hash Algorithm: SHA384
        SHA512  ///< Hash Algorithm: SHA512
    };

    /**
     * @name Constructor / Destructor
     */
    ///@{
    /**
     * @brief Create object with undefined algorithm.
     * @warning SHOULD be used in conjunction with VirgilAsn1Compatible interface,
     *     i.e. VirgilHash hash; hash.fromAsn1(asn1);
     */
    VirgilHash();

    /**
     * @brief Create object with specific algorithm type.
     */
    explicit VirgilHash(Algorithm alg);

    /**
     * @brief Create object with given algorithm name.
     * @note Names SHOULD be the identical to the VirgilHash::Algorithm enumeration.
     */
    explicit VirgilHash(const std::string& name);

    /**
     * @brief Create object with given algorithm name.
     * @note Names SHOULD be the identical to the VirgilHash::Algorithm enumeration.
     */
    explicit VirgilHash(const char* name);
    ///@}
    /**
     * @name Info
     * Provide detail information about object.
     */
    ///@{
    /**
     * @brief Returns name of the hash function.
     * @return Name of the hash function.
     */
    std::string name() const;

    /**
     * @brief Returns algorithm of the hash function.
     * @return Algorithm of the hash function.
     */
    Algorithm algorithm() const;

    /**
     * @brief Return underlying hash type
     * @note Used for internal purposes only
     */
    int type() const;

    /**
     * @brief Return size of the message digest output.
     * @return Size in octets.
     */
    size_t size() const;
    ///@}

    /**
     * @name Immediate Hashing
     * This methods can be used to get the message hash immediately.
     */
    ///@{
    /**
     * @brief Produce hash.
     *
     * Process the given message immediately and return it's hash.
     *
     * @param data - message to be hashed.
     * @return Hash of the given message.
     */
    virgil::crypto::VirgilByteArray hash(const virgil::crypto::VirgilByteArray& data) const;
    ///@}

    /**
     * @name Chain Hashing
     *
     * This methods provide mechanism to hash long message,
     *     that can be splitted to a shorter chunks and be processed separately.
     */
    ///@{
    /**
     * @brief Initialize hashing for the new message hash.
     */
    void start();

    /**
     * @brief Update / process message hash.
     *
     * This method MUST be used after @link start() @endlink method only.
     * This method MAY be called multiple times to process long message splitted to a shorter chunks.
     *
     * @param data - message to be hashed.
     * @see start()
     */
    void update(const virgil::crypto::VirgilByteArray& data);

    /**
     * @brief Return final message hash.
     * @return Message hash processed by series of @link update() @endlink method.
     * @see start()
     * @see update()
     */
    virgil::crypto::VirgilByteArray finish();
    ///@}

    /**
     * @name HMAC Immediate Hashing
     * This methods can be used to get the message HMAC hash immediately.
     */
    ///@{
    /**
     * @brief Produce HMAC hash.
     *
     * Process the given message immediately and return it's HMAC hash.
     *
     * @param key - secret key.
     * @param data - message to be hashed.
     * @return HMAC hash of the given message.
     */
    virgil::crypto::VirgilByteArray hmac(
            const virgil::crypto::VirgilByteArray& key,
            const virgil::crypto::VirgilByteArray& data) const;
    ///@}

    /**
     * @name HMAC Chain Hashing
     *
     * This methods provide mechanism to get HMAC hash of the long message,
     *     that can be splitted to a shorter chunks and be processed separately.
     */
    ///@{
    /**
     * @brief Initialize HMAC hashing for the new message hash.
     * @param key - secret key.
     */
    void hmacStart(const virgil::crypto::VirgilByteArray& key);

    /**
     * @brief Reset HMAC hashing for the new message hash.
     */
    void hmacReset();

    /**
     * @brief Update / process message HMAC hash.
     *
     * This method MUST be used after @link hmacStart() @endlink or @link hmacReset() @endlink methods only.
     * This method MAY be called multiple times to process long message splitted to a shorter chunks.
     *
     * @param data - message to be hashed.
     * @see @link hmacStart() @endlink
     * @see @link hmacReset() @endlink
     */
    void hmacUpdate(const virgil::crypto::VirgilByteArray& data);

    /**
     * @brief Return final message HMAC hash.
     * @return Message HMAC hash processed by series of @link hmacUpdate() @endlink method.
     * @see @link hmacStart() @endlink
     * @see @link hmacReset() @endlink
     * @see @link hmacUpdate() @endlink
     */
    virgil::crypto::VirgilByteArray hmacFinish();
    ///@}
    /**
     * @name VirgilAsn1Compatible implementation
     */
    ///@{
    size_t asn1Write(
            virgil::crypto::foundation::asn1::VirgilAsn1Writer& asn1Writer,
            size_t childWrittenBytes = 0) const override;

    void asn1Read(virgil::crypto::foundation::asn1::VirgilAsn1Reader& asn1Reader) override;
    ///@}

public:
    //! @cond Doxygen_Suppress
    VirgilHash(VirgilHash&& rhs) noexcept;

    VirgilHash& operator=(VirgilHash&& rhs) noexcept;

    virtual ~VirgilHash() noexcept;

    VirgilHash(const VirgilHash& rhs);

    VirgilHash& operator=(const VirgilHash& rhs);
    //! @endcond

private:
    void checkState() const;

private:
    class Impl;

    std::unique_ptr<Impl> impl_;
};

}}}

namespace std {
/**
 * @brief Returns string representation of the Hash algorithm.
 * @return Hash algorithm as string.
 * @ingroup hash
 */
string to_string(virgil::crypto::foundation::VirgilHash::Algorithm alg);
}

#endif /* VIRGIL_CRYPTO_FOUNDATION_VIRGIL_HASH_H */
