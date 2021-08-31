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

#ifndef VIRGIL_CRYPTO_TINY_CIPHER_H
#define VIRGIL_CRYPTO_TINY_CIPHER_H

#include <memory>
#include <string>

#include "VirgilByteArray.h"

namespace virgil { namespace crypto {

/**
 * @brief Forward declaration of the implementation class.
 */
class VirgilTinyCipherImpl;

/**
 * @brief This class aim is to minimize encryption output.
 *
 * @par Motivation
 * If encrypted data is transmitted over GSM module, it very important that encryption output was as small as possible.
 *
 * @par Solution
 * Throw out crypto agility and transfer minimum public information required for decryption.
 *
 * @par Pros
 * * Tiny messages.
 *
 * @par Cons
 * * Crypto agility is not included in the message, so encrypted messages should not be stored for long term.
 *
 * @par Details
 * During encryption ciper packs encrypted message and service information to the set of packages,
 * which length is limited by maximim package length.
 *
 * @par Restrictions
 * Currently supported public/private keys:
 * * Curve25519
 * @par
 * Minimum package length:
 * * 113 bytes
 *
 * @see VirgilTinyCipher(size_t packageSize)
 * @see VirgilTinyCipher::PackageSize
 *
 * @par Example - Encrypt
 * @code
 * VirgilTinyCipher tinyCipher;
 * VirgilByteArray data = VirgilByteArrayUtils::stringToBytes("String to be encrypted");
 * tinyCipher.encrypt(data, recipientPublicKey);
 * for (size_t i = 0; i < tinyCipher.getPackageCount(); ++i) {
 *     VirgilByteArray package = tinyCipher.getPackage(i);
 *     // Send package to the recipient
 * }
 * @endcode
 *
 * @par Example - Encrypt and Sign
 * @code
 * VirgilTinyCipher tinyCipher;
 * VirgilByteArray data = VirgilByteArrayUtils::stringToBytes("String to be encrypted");
 * tinyCipher.encryptAndSign(data, recipientPublicKey, senderPrivateKey, senderPrivateKeyPassword);
 * for (size_t i = 0; i < tinyCipher.getPackageCount(); ++i) {
 *     VirgilByteArray package = tinyCipher.getPackage(i);
 *     // Send package to the recipient
 * }
 * @endcode
 *
 * @par Example - Decrypt
 * @code
 * tinyCipher.addPackage(receivedPackage);
 * if (tinyCipher.isPackagesAccumulated()) {
 *     decryptedData = tinyCipher.decrypt(recipientPrivateKey, recipientPrivateKeyPassword);
 * }
 * @endcode
 *
 * @par Example - Verify and Decrypt
 * @code
 * tinyCipher.addPackage(receivedPackage);
 * if (tinyCipher.isPackagesAccumulated()) {
 *     decryptedData = tinyCipher.verifyAndDecrypt(senderPublicKey, recipientPrivateKey, recipientPrivateKeyPassword);
 * }
 * @endcode
 */
class VirgilTinyCipher {
public:
    /**
     * @brief Constants that represents maximum number of bytes in one package.
     * @note Text representation is 4/3 bigger, i.e 120 * 4/3 = 160 - for short sms.
     */
    enum PackageSize {
        PackageSize_Min = 113,       ///< Min
        PackageSize_Short_SMS = 120, ///< Short SMS
        PackageSize_Long_SMS = 1200  ///< Long SMS
    };
public:
    /**
     * @name Configuration
     */
    /// @{
    /**
     * @brief Init cipher with given maximum package size.
     *
     * @param packageSize - maximum number of bytes in one package
     *
     * @throw std::logic_error - if given packageSize less then minimum value
     *
     * @see VirgilTinyCipher::PackageSize
     */
    explicit VirgilTinyCipher(size_t packageSize = PackageSize_Short_SMS);

    /**
     * @brief Prepare cipher for the next encryption.
     *
     * @note SHOULD be used before the next encryption.
     */
    void reset();
    /// @}
    /**
     * @name Encryption
     */
    /// @{
    /**
     * @brief Encrypt data with given public key
     *
     * @param data - data to be encrypted
     * @param recipientPublicKey - recipient public key
     *
     * @see getPackage()
     *
     * @throw VirgilCryptoException - if public key is not supported
     */
    void encrypt(const VirgilByteArray& data, const VirgilByteArray& recipientPublicKey);

    /**
     * @brief Encrypt data with given public key and sign package
     *
     * @param data - data to be encrypted
     * @param recipientPublicKey - recipient public key
     * @param senderPrivateKey - sender private key
     * @param senderPrivateKeyPassword - sender private key password (optional)
     *
     * @see Related links can be found in the encrypt() function description.
     *
     * @throw VirgilCryptoException - if public key is not supported
     * @throw VirgilCryptoException - if private key is not supported
     * @throw VirgilCryptoException - if private key password is wrong
     */
    void encryptAndSign(
            const VirgilByteArray& data, const VirgilByteArray& recipientPublicKey,
            const VirgilByteArray& senderPrivateKey,
            const VirgilByteArray& senderPrivateKeyPassword = VirgilByteArray());

    /**
     * @brief Return total package count.
     *
     * @note Package count is known when encryption process is completed.
     *
     * @see getPackage()
     */
    size_t getPackageCount() const;

    /**
     * @brief Return specific package.
     *
     * Return package with specific index.
     *
     * @param index - package index
     *
     * @note Packages are available when encryption process is completed.
     *
     * @throw std::out_of_range - if package with given index is not exists
     */
    VirgilByteArray getPackage(size_t index) const;
    /// @}
    /**
     * @name Decryption
     */
    /// @{
    /**
     * @brief Add package.
     *
     * Accumulate packages before decryption.
     *
     * @param package - package to be accumulated
     *
     * @see To determine that all packages are received call function isPackagesAccumulated().
     *
     * @throw VirgilCryptoException - if given package is malformed
     */
    void addPackage(const VirgilByteArray& package);

    /**
     * @brief Define whether all packages was accumulated or not.
     *
     * @return true - if all packages was successfully accumulated, false otherwise
     *
     * @see addPackage()
     */
    bool isPackagesAccumulated() const;

    /**
     * @brief Decrypt accumulated packages.
     *
     * @param recipientPrivateKey - recipient private key
     * @param recipientPrivateKeyPassword - recipient private key password (optional)
     *
     * @return Decrypted data.
     *
     * @throw VirgilCryptoException - if public key or private key are not supported
     * @throw VirgilCryptoException - if data is malformed
     */
    VirgilByteArray decrypt(
            const VirgilByteArray& recipientPrivateKey,
            const VirgilByteArray& recipientPrivateKeyPassword = VirgilByteArray());

    /**
     * @brief Verify accumulated packages and then decrypt it.
     *
     * @param senderPublicKey - sender public key
     * @param recipientPrivateKey - recipient private key
     * @param recipientPrivateKeyPassword - recipient private key password (optional)
     *
     * @throw VirgilCryptoException - if public key or private key are not supported
     * @throw VirgilCryptoException - if data is malformed
     */
    VirgilByteArray verifyAndDecrypt(
            const VirgilByteArray& senderPublicKey,
            const VirgilByteArray& recipientPrivateKey,
            const VirgilByteArray& recipientPrivateKeyPassword = VirgilByteArray());
    /// @}
public:
    //! @cond Doxygen_Suppress
    VirgilTinyCipher(VirgilTinyCipher&& rhs) noexcept;

    VirgilTinyCipher& operator=(VirgilTinyCipher&& rhs) noexcept;

    virtual ~VirgilTinyCipher() noexcept;
    //! @endcond

private:
    class Impl;

    std::unique_ptr<Impl> impl_;
};

}}

#endif // VIRGIL_CRYPTO_TINY_CIPHER_H
