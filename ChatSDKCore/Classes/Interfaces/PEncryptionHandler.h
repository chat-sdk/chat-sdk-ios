//
//  PEncryptionHandler.h
//  Pods
//
//  Created by Ben on 10/17/18.
//

#ifndef PEncryptionHandler_h
#define PEncryptionHandler_h

@protocol PEncryptionHandler <NSObject>

-(nullable NSDictionary<NSString *, id> *) encryptMessage: (nonnull id<PMessage>) message;
-(nullable NSDictionary<NSString *, id> *) decryptMessage: (nonnull NSString *) message;

-(nullable NSString *) publicKey;
-(nullable NSString *) privateKeyId;
-(nonnull RXPromise *) publishKey;
-(void) addPublicKey: (nonnull NSString *) userId identifier: (nullable NSString *) identifier key: (nonnull NSString *) key;

@end

#endif /* PEncryptionHandler_h */
