//
//  BPhonebookManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 23/05/2016.
//
//


@class RXPromise;
@class BPhoneBookUser;
@protocol PUser;

@interface BPhonebookManager : NSObject {
}

+(BPhonebookManager *) sharedManager;

//- (RXPromise *) getAddressBookContacts: (void(^)(id<PUser> user)) userAdded  phoneBookUserAdded: (void(^)(BPhoneBookUser * user)) phoneBookUser;
//- (RXPromise *)automaticallyAddContactsFromAddressBook: (void(^)(id<PUser> user)) userAdded;

//- (RXPromise *) getAddressBookContacts;
- (RXPromise *) getUsersFromAddressBook;

@end
