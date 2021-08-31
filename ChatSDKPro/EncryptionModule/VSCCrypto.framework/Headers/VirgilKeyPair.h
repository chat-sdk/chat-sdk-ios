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

#ifndef VIRGIL_KEY_PAIR_H
#define VIRGIL_KEY_PAIR_H

#include "VirgilByteArray.h"

namespace virgil { namespace crypto {

/**
 * @brief This class handles information about Virgil Security key pair.
 */
class VirgilKeyPair {
public:
    /**
     * @brief Specific key algorithm type.
     * @note This type is deprecated. Use Algorithm instead.
     *
     * | Key Algorithm   | Description                    | Notes                  |
     * |-----------------|--------------------------------|------------------------|
     * | RSA_256         | RSA 1024 bit                   | weak, not recommended  |
     * | RSA_512         | RSA 1024 bit                   | weak, not recommended  |
     * | RSA_1024        | RSA 1024 bit                   | weak, not recommended  |
     * | RSA_2048        | RSA 2048 bit                   | weak, not recommended  |
     * | RSA_3072        | RSA 3072 bit                   |                        |
     * | RSA_4096        | RSA 4096 bit                   |                        |
     * | RSA_8192        | RSA 8192 bit                   |                        |
     * | EC_SECP192R1    | 192-bits NIST curve            |                        |
     * | EC_SECP224R1    | 224-bits NIST curve            |                        |
     * | EC_SECP256R1    | 256-bits NIST curve            |                        |
     * | EC_SECP384R1    | 384-bits NIST curve            |                        |
     * | EC_SECP521R1    | 521-bits NIST curve            |                        |
     * | EC_BP256R1      | 256-bits Brainpool curve       |                        |
     * | EC_BP384R1      | 384-bits Brainpool curve       |                        |
     * | EC_BP512R1      | 512-bits Brainpool curve       |                        |
     * | EC_SECP192K1    | 192-bits "Koblitz" curve       |                        |
     * | EC_SECP224K1    | 224-bits "Koblitz" curve       |                        |
     * | EC_SECP256K1    | 256-bits "Koblitz" curve       |                        |
     * | EC_CURVE25519   | Curve25519 (deprecated format) | deprecated             |
     * | FAST_EC_X25519  | Curve25519                     | only encrypt / decrypt |
     * | FAST_EC_ED25519 | Ed25519                        | recommended, default   |
     *
     */
    enum class Type {
        RSA_256, ///< RSA 1024 bit
        RSA_512, ///< RSA 1024 bit
        RSA_1024, ///< RSA 1024 bit
        RSA_2048, ///< RSA 2048 bit
        RSA_3072, ///< RSA 3072 bit
        RSA_4096, ///< RSA 4096 bit
        RSA_8192, ///< RSA 8192 bit
        EC_SECP192R1, ///< 192-bits NIST curve
        EC_SECP224R1, ///< 224-bits NIST curve
        EC_SECP256R1, ///< 256-bits NIST curve
        EC_SECP384R1, ///< 384-bits NIST curve
        EC_SECP521R1, ///< 521-bits NIST curve
        EC_BP256R1, ///< 256-bits Brainpool curve
        EC_BP384R1, ///< 384-bits Brainpool curve
        EC_BP512R1, ///< 512-bits Brainpool curve
        EC_SECP192K1, ///< 192-bits "Koblitz" curve
        EC_SECP224K1, ///< 224-bits "Koblitz" curve
        EC_SECP256K1, ///< 256-bits "Koblitz" curve
        EC_CURVE25519, ///< Curve25519 as ECP deprecated format
        FAST_EC_X25519, ///< Curve25519
        FAST_EC_ED25519, ///< Ed25519
    };
    /**
     * @brief Key algorithm
     */
    using Algorithm = Type;
public:
    /**
     * @brief Generate new key pair given type.
     * @param type - private key type to be generated.
     * @param pwd - private key password.
     */
    static VirgilKeyPair generate(
            VirgilKeyPair::Type type,
            const VirgilByteArray& pwd = VirgilByteArray());

    /**
     * @brief Generate new key pair with recommended most safe type.
     * @param pwd - private key password.
     */
    static VirgilKeyPair generateRecommended(
            const VirgilByteArray& pwd = VirgilByteArray());

    /**
     * @brief Generate new key pair of the same type based on the donor key pair.
     * @param donorKeyPair - public key or private key is used to determine the new key pair type.
     * @param donorPrivateKeyPassword - donor private key password, optional if public key is defined.
     * @param newKeyPairPassword - private key password of the new key pair.
     */
    static VirgilKeyPair generateFrom(
            const VirgilKeyPair& donorKeyPair,
            const VirgilByteArray& donorPrivateKeyPassword = VirgilByteArray(),
            const VirgilByteArray& newKeyPairPassword = VirgilByteArray());

    /**
     * @brief Generates private and public keys from the given key material.
     *
     * This is a deterministic key generation algorithm that allows create private key
     * from any secret data, i.e. password.
     *
     * @param type - private key type to be generated.
     * @param keyMaterial - the only data to be used for key generation, must be strong enough.
     * @param pwd - private key password.
     */
    static VirgilKeyPair generateFromKeyMaterial(
            VirgilKeyPair::Type type,
            const VirgilByteArray& keyMaterial,
            const VirgilByteArray& pwd = VirgilByteArray());
    /**
     * @brief Generates recommended private and public keys from the given key material.
     *
     * This is a deterministic key generation algorithm that allows create private key
     * from any secret data, i.e. password.
     *
     * @param keyMaterial - the only data to be used for key generation, must be strong enough.
     * @param pwd - private key password.
     *
     * @throw VirgilCryptoException with VirgilCryptoError::NotSecure,
     *     if Key Material is weak.
     */
    static VirgilKeyPair generateRecommendedFromKeyMaterial(
            const VirgilByteArray& keyMaterial,
            const VirgilByteArray& pwd = VirgilByteArray());

    /**
     * @name Keys validation
     */
    ///@{
    /**
     * @brief Check if a public-private pair of keys matches.
     *
     * @param publicKey - public key in DER or PEM format.
     * @param privateKey - private key in DER or PEM format.
     * @param privateKeyPassword - private key password if exists.
     *
     * @return true - if public-private pair of keys matches.
     */
    static bool isKeyPairMatch(
            const VirgilByteArray& publicKey,
            const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());

    /**
     * @brief Check if given private key and it's password matches.
     *
     * @param key - private key in DER or PEM format.
     * @param pwd - private key password.
     *
     * @return true - if private key and it's password matches.
     */
    static bool checkPrivateKeyPassword(
            const VirgilByteArray& key,
            const VirgilByteArray& pwd);

    /**
     * @brief Check if given private key is encrypted.
     *
     * @param privateKey - private key in DER or PEM format.
     *
     * @return true - if private key is encrypted.
     */
    static bool isPrivateKeyEncrypted(const VirgilByteArray& privateKey);
    ///@}
    /**
     * @name Keys
     */
    ///@{
    /**
     * @brief Reset password for the given private key.
     *
     * Re-encrypt given Private Key with a new password.
     *
     * @param privateKey - Private Key that is encrypted with old password.
     * @param oldPassword - current Private Key password.
     * @param newPassword - new Private Key password.
     *
     * @return Private Key that is encrypted with the new password.
     */
    static VirgilByteArray resetPrivateKeyPassword(
            const VirgilByteArray& privateKey,
            const VirgilByteArray& oldPassword, const VirgilByteArray& newPassword);

    /**
     * @brief Return encrypted private key in PKCS#8 format.
     *
     * Encrypt the given private key and return result.
     *
     * @param privateKey - Private Key in the plain text.
     * @param privateKeyPassword - new Private Key password.
     *
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidArgument if key is empty.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidPrivateKeyPassword if key is already encrypted.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidFormat if key has invalid format.
     *
     * @return Encrypted Private Key.
     */
    static VirgilByteArray encryptPrivateKey(
            const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword);

    /**
     * @brief Return plain (non encrypted) private key.
     *
     * Decrypt the given private key and return result.
     *
     * @param privateKey - Encrypted Private Key.
     * @param privateKeyPassword - current Private Key password.
     *
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidPrivateKeyPassword if password is wrong.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidFormat if key has invalid format.
     *
     * @note It is unsafe to store Private Key in the plain text.
     *
     * @return Plain Private Key.
     */
    static VirgilByteArray decryptPrivateKey(
            const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword);

    /**
     * @brief Extract public key from the private key.
     *
     * @param privateKey - Private Key.
     * @param privateKeyPassword - Private Key password.
     *
     * @return Public Key.
     */
    static VirgilByteArray extractPublicKey(
            const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword);

    /**
     * @brief Convert given public key to the PEM format.
     *
     * @param publicKey - Public Key to be converted.
     * @return Public Key in the PEM fromat.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidFormat if key has invalid format.
     */
    static VirgilByteArray publicKeyToPEM(const VirgilByteArray& publicKey);

    /**
     * @brief Convert given public key to the DER format.
     *
     * @param publicKey - Public Key to be converted.
     * @return Public Key in the DER fromat.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidFormat if key has invalid format.
     */
    static VirgilByteArray publicKeyToDER(const VirgilByteArray& publicKey);

    /**
     * @brief Convert given private key to the PEM format.
     *
     * @param privateKey - Private Key to be converted.
     * @param privateKeyPassword - password for the Private Key.
     * @return Private Key in the PEM fromat.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidPrivateKeyPassword if password is wrong.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidFormat if key has invalid format.
     */
    static VirgilByteArray privateKeyToPEM(
            const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());
    /**
     * @brief Convert given private key to the DER format.
     *
     * @param privateKey - Private Key to be converted.
     * @param privateKeyPassword - password for the Private Key.
     * @return Private Key in the DER fromat.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidPrivateKeyPassword if password is wrong.
     * @throw VirgilCryptoException, with VirgilCryptoError::InvalidFormat if key has invalid format.
     */
    static VirgilByteArray privateKeyToDER(
            const VirgilByteArray& privateKey,
            const VirgilByteArray& privateKeyPassword = VirgilByteArray());
    ///@}

    /**
     * @brief Initialize key pair with given public and private key.
     */
    VirgilKeyPair(const VirgilByteArray& publicKey, const VirgilByteArray& privateKey);

    /**
     * @brief Provide access to the public key.
     */
    VirgilByteArray publicKey() const;

    /**
     * @brief Provide access to the private key.
     */
    VirgilByteArray privateKey() const;

private:
    VirgilByteArray publicKey_;
    VirgilByteArray privateKey_;
};

}}

#endif /* VIRGIL_KEY_PAIR_H */
