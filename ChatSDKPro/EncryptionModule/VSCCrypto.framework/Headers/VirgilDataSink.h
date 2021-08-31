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

#ifndef VIRGIL_CRYPTO_VIRGIL_DATA_SINK_H
#define VIRGIL_CRYPTO_VIRGIL_DATA_SINK_H

#include "VirgilByteArray.h"

namespace virgil { namespace crypto {

/**
 * @brief This is base class for output streams.
 *
 * Defines interface that allows write data to the output stream.
 */
class VirgilDataSink {
public:
    /**
     * @brief Return true if target object is able to write data.
     */
    virtual bool isGood() = 0;

    /**
     * @brief Write data to the target object.
     * @param data data to be written, SHOULD NOT be empty.
     */
    virtual void write(const VirgilByteArray& data) = 0;

    /**
     * @brief Write data to the sink in a safe way.
     *
     * Write only if data is not empty and sink is good, otherwise - do nothing
     *
     * @param sink sink to be written to.
     * @param data data to be written.
     */
    static void safeWrite(VirgilDataSink& sink, const VirgilByteArray& data);

    virtual ~VirgilDataSink() noexcept = default;
};

}}

#endif /* VIRGIL_CRYPTO_VIRGIL_DATA_SINK_H */
