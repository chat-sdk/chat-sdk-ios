//
// Copyright (C) 2015-2019 Virgil Security Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     (1) Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//
//     (2) Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the
//     distribution.
//
//     (3) Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
// IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
//

#import <Foundation/Foundation.h>

#import "VSCPfsSession.h"
#import "VSCPfsEncryptedMessage.h"
#import "VSCPfsInitiatorPrivateInfo.h"
#import "VSCPfsResponderPublicInfo.h"
#import "VSCPfsResponderPrivateInfo.h"
#import "VSCPfsInitiatorPublicInfo.h"

/**
 Class for main PFS operations
 */
NS_SWIFT_NAME(Pfs)
@interface VSCPfs : NSObject

/**
 Starts initiator session.

 @param initiatorPrivateInfo Initiator Private Info
 @param respondrerPublicInfo Responder Public Info
 @param additionalData Additional data for authentication
 @return initialized Pfs Session
 */
- (VSCPfsSession * __nullable)startInitiatorSessionWithInitiatorPrivateInfo:(VSCPfsInitiatorPrivateInfo * __nonnull)initiatorPrivateInfo respondrerPublicInfo:(VSCPfsResponderPublicInfo * __nonnull)respondrerPublicInfo additionalData:(NSData * __nullable)additionalData;

/**
 Starts responder session.

 @param responderPrivateInfo Responder Private Info
 @param initiatorPublicInfo Initiator Public Info
 @param additionalData Additional data for authentication
 @return Pfs Session
 */
- (VSCPfsSession * __nullable)startResponderSessionWithResponderPrivateInfo:(VSCPfsResponderPrivateInfo * __nonnull)responderPrivateInfo initiatorPublicInfo:(VSCPfsInitiatorPublicInfo * __nonnull)initiatorPublicInfo additionalData:(NSData * __nullable)additionalData;

/**
 Encrypts data

 @param data Data to encrypt
 @return Encrypted message
 */
- (VSCPfsEncryptedMessage * __nullable)encryptData:(NSData * __nonnull)data;

/**
 Decrypts data

 @param message message to decrypt
 @return Decrypted
 */
- (NSData * __nullable)decryptMessage:(VSCPfsEncryptedMessage * __nonnull)message;

/**
 Underlying PFS session
 */
@property (nonatomic) VSCPfsSession * __nullable session;

@end
