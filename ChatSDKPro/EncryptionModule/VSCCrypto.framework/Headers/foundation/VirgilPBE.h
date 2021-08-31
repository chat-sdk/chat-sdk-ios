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

#ifndef VIRGIL_CRYPTO_VIRGIL_PBE_H
#define VIRGIL_CRYPTO_VIRGIL_PBE_H

#include <cstdlib>
#include <memory>

#include "../VirgilByteArray.h"
#include "asn1/VirgilAsn1Compatible.h"

namespace virgil { namespace crypto { namespace foundation {

/**
 * @brief Provides Password-Based Cryptography. Now PKCS#5 and PKCS#12 are partially supported.
 * @ingroup cipher
 */
class VirgilPBE : public asn1::VirgilAsn1Compatible {
public:
    /**
     * @brief Enumerates possible Password Based Encryption algorithms.
     */
    enum class Algorithm {
        PKCS5, ///< PBE Algorithm: from the standard PKCS#5
        PKCS12 ///< PBE Algorithm: from the standard PKCS#12
    };

    /**
     * @name Constants
     */
    ///@{
    /**
     * @property kIterationCountMin
     * @brief Recommended iteration count that is used for key derivation.
     */
    static constexpr size_t kIterationCountMin = 1024;
    ///@}
public:
    /**
     * @name Constructor / Destructor
     */
    ///@{
    /**
     * @brief Create object with undefined algorithm.
     * @warning SHOULD be used in conjunction with VirgilAsn1Compatible interface,
     *     i.e. VirgilPBE pbe; pbe.fromAsn1(asn1);
     */
    VirgilPBE();

    /**
     * @brief reate object with specific algorithm type.
     * @param alg Specific PBE algorithm.
     * @param salt Salt, it is recommended to use random value for security reasons.
     * @param iterationCount Iteration count for the key derivation,
     *     it is recommended to use random value for security reasons.
     */
    VirgilPBE(Algorithm alg, const VirgilByteArray& salt, size_t iterationCount = kIterationCountMin);

    ///@}
    /**
     * @name Encryption / Decryption
     */
    ///@{
    /**
     * @brief Encrypt data with given password.
     * @param data - data to encrypt.
     * @param pwd - password to use for encryption (max length is 31 byte).
     * @return Encrypted data.
     */
    virgil::crypto::VirgilByteArray encrypt(
            const virgil::crypto::VirgilByteArray& data,
            const virgil::crypto::VirgilByteArray& pwd) const;

    /**
     * @brief Decrypt data with given password.
     * @param data - data to decrypt.
     * @param pwd - password to use for decryption (max length is 31 byte).
     * @return Decrypted data.
     */
    virgil::crypto::VirgilByteArray decrypt(
            const virgil::crypto::VirgilByteArray& data,
            const virgil::crypto::VirgilByteArray& pwd) const;
    ///@}
    /**
     * @name VirgilAsn1Compatible implementation
     * @code
     * Marshalling format:
     *     PBE ::= AlgorithmIdentifier {{ PBEAlgorithms }}
     *     PBEAlgorithms AlgorithmIdentifier ::= {
     *         { OID id-PBES2 PARMS PBES2-params }  |
     *         { OID pkcs-12PbeId PARMS pkcs-12PbeParams }
     *     }
     * @endcode
     */
    ///@{
    size_t asn1Write(asn1::VirgilAsn1Writer& asn1Writer, size_t childWrittenBytes = 0) const override;

    void asn1Read(asn1::VirgilAsn1Reader& asn1Reader) override;
    ///@}
public:
    //! @cond Doxygen_Suppress
    VirgilPBE(VirgilPBE&& rhs) noexcept;

    VirgilPBE& operator=(VirgilPBE&& rhs) noexcept;

    virtual ~VirgilPBE() noexcept;
    //! @endcond

private:
    /**
     * @brief If internal state is not initialized with specific algorithm exception will be thrown.
     */
    void checkState() const;

    /**
     * @brief Encrypt or decrypt data depend on the mode.
     */
    virgil::crypto::VirgilByteArray process(
            const virgil::crypto::VirgilByteArray& data,
            const virgil::crypto::VirgilByteArray& pwd, int mode) const;

private:
    class Impl;

    std::unique_ptr<Impl> impl_;
};

}}}

#endif /* VIRGIL_CRYPTO_VIRGIL_PBE_H */
