//
//  BPhonebookManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 23/05/2016.
//
//

#import "BPhonebookManager.h"
#import <AddressBook/AddressBook.h>

#import <ChatSDK/UI.h>
#import <Contacts/Contacts.h>
#import "BPhoneBookUser.h"

#define bErrorDomain @"ContactBookModule"

@implementation BPhonebookManager

static BPhonebookManager * manager;

+(BPhonebookManager *) sharedManager {
    
    @synchronized(self) {
        
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(manager == nil) {
            // Allocate and initialize an instance of this class
            manager = [[self alloc] init];
        }
    }
    return manager;
}

-(id) init {
    if ((self = [super init])) {
        
    }
    return self;
}


- (RXPromise *) batchedSearchWithUsers: (NSArray *)users added: (void(^)(id<PUser> user)) userAdded phoneBookUserAdded: (void(^)(BPhoneBookUser * user)) phoneBookUserAdded {
    
    NSMutableArray * promises = [NSMutableArray new];
    
    for (BPhoneBookUser * phoneBookUser in users) {
        for (NSDictionary * dict in phoneBookUser.getSearchIndexes) {
            [promises addObject:[BChatSDK.search usersForIndexes:@[dict[bIndexKey]] withValue:dict[bValueKey] limit:1 userAdded:^(id<PUser> user) {
                if(userAdded != Nil) {
                    userAdded(user);
                }
//                phoneBookUser.entityID = user.entityID;
            }]];
        }
        if(phoneBookUserAdded != Nil) {
            phoneBookUserAdded(phoneBookUser);
        }
    }
    
    return [RXPromise all: promises].thenOnMain(^id(id success) {
        return Nil;
    }, ^id(NSError * error) {
        NSLog(@"");
        return error;
    });
}

//// TODO: Localize
//- (RXPromise *) requestPermissionAndGetUsersFromAddressBook {
//
//    RXPromise * promise = [RXPromise new];
//
//    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
//
//    // If user has previously denied/revoked permission for your app to access the contacts
//    if (status == kABAuthorizationStatusDenied) {
//        [promise rejectWithReason:[NSError errorWithDomain:bErrorDomain
//                                                      code:0
//                                                  userInfo:@{NSLocalizedDescriptionKey: @"This app requires access to your contacts to add users from your phone book, edit your privacy settings to allow this"}]];
//    }
//    else {
//        // Try to get the address book object
//            CFErrorRef error = NULL;
//            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
//
//            if (error) {
//                NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
//                if (addressBook) CFRelease(addressBook);
//                [promise rejectWithReason:[NSError errorWithDomain:bErrorDomain
//                                                              code:0
//                                                          userInfo:@{NSLocalizedDescriptionKey: @"Could not access address book"}]];
//            }
//            else {
//                if (status == kABAuthorizationStatusAuthorized) {
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                        [promise resolveWithResult:[self getUsersFromAddressBook: addressBook]];
//                    });
//                }
//                else if (status == kABAuthorizationStatusNotDetermined) {
//                    // present the user the UI that requests permission to contacts ...
//                    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//                        if (error) {
//                            NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
//                            if (addressBook) CFRelease(addressBook);
//                            [promise rejectWithReason:[NSError errorWithDomain:bErrorDomain
//                                                                          code:0
//                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error while trying to accesss address book"}]];
//                        }
//                        else {
//                            if (granted) {
//                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                    [promise resolveWithResult:[self getUsersFromAddressBook: addressBook]];
//                                });
//                            }
//                            else {
//                                [promise rejectWithReason:[NSError errorWithDomain:bErrorDomain
//                                                                              code:0
//                                                                          userInfo:@{NSLocalizedDescriptionKey: @"This app requires access to your contacts to add users from your phone book, edit your privacy settings to allow this"}]];
//                            }
//                        }
//                    });
//            }
//        }
//    }
//
//    return promise;
//}

- (RXPromise *) getUsersFromAddressBook {
    
    RXPromise * promise = [RXPromise new];
    
    NSMutableArray * users = [NSMutableArray new];

    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    
                    BPhoneBookUser * user = [BPhoneBookUser new];
                    user.firstName = contact.givenName;
                    user.lastName = contact.familyName;
                    user.image = [UIImage imageWithData:contact.imageData];
                    
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        NSString *phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [user.phoneNumbers addObject:phone];
                        }
                    }

                    for (CNLabeledValue *label in contact.emailAddresses) {
                        NSString *email = [label.value stringValue];
                        if ([email length] > 0) {
                            [user.emailAddresses addObject:email];
                        }
                    }
                    
                    [users addObject:user];

                }
            }
            [promise resolveWithResult:users];
        } else {
            [promise rejectWithReason:error];
        }
    }];
    
    return promise;
}


@end;
