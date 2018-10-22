//
//  PEncryptionHandler.h
//  Pods
//
//  Created by Ben on 10/17/18.
//

#ifndef PEncryptionHandler_h
#define PEncryptionHandler_h

@protocol PEncryptionHandler <NSObject>

-(void) encryptMessage: (id<PMessage>) message;
-(void) decryptMessage: (id<PMessage>) message;

@end

#endif /* PEncryptionHandler_h */
