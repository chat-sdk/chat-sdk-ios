//
//  BAccountTypes.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#ifndef BAccountTypes_h
#define BAccountTypes_h

typedef enum {
    bAccountTypeUsername = 1,
    bAccountTypeFacebook = 2,
    bAccountTypeTwitter = 3,
    //    bAccountTypeGithub = -1,
    bAccountTypeAnonymous = 4,
    bAccountTypeGoogle = 5,
    bAccountTypeCustom = 6,
    bAccountTypeRegister = 99,
} bAccountType;

#endif /* BAccountTypes_h */
