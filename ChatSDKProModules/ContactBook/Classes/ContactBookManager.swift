//
//  ContactBookManager.swift
//  ChatSDKModules
//
//  Created by ben3 on 30/08/2021.
//

import Foundation
import Contacts

@objc public class ContactBookManager: NSObject {
    
    @objc public static func getContacts() -> RXPromise {
        
        let promise = RXPromise()

        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts, completionHandler: { success, error in
            if let error = error {
                promise.reject(withReason: error)
            } else {

                var contacts = [BPhoneBookUser]()
                
                let keys: [CNKeyDescriptor] = [
                    CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                    CNContactEmailAddressesKey as CNKeyDescriptor,
                    CNContactImageDataKey as CNKeyDescriptor
                ]
                
                let request = CNContactFetchRequest(keysToFetch: keys)

                do {
                    try contactStore.enumerateContacts(with: request) { (contact, stop) in
                        let user = BPhoneBookUser()
                        user.firstName = contact.givenName;
                        user.lastName = contact.familyName;
                        if let data = contact.imageData {
                            user.image = UIImage(data: data)
                        }
                        
                        for label in contact.phoneNumbers {
                            let phone = label.value.stringValue
                            if phone.count > 0 {
                                user.phoneNumbers.add(phone)
                            }
                        }

                        for label in contact.emailAddresses {
                            let email = label.value
                            if email.length > 0 {
                                user.emailAddresses.add(email)
                            }
                        }
                        
                        if user.isContactable() {
                            contacts.append(user)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                promise.resolve(withResult: contacts)
                
            }
        })
        
        return promise
    }
    
    @objc public static func searchForUser(user: BPhoneBookUser) -> RXPromise {
        return search(for: user, index: 0)
    }
    
    @objc public static func search(for user: BPhoneBookUser, index: Int) -> RXPromise {
        let indexes = user.getSearchIndexes()
        
        if let indexes = indexes, indexes.count > index, let first = indexes[index].first, let last = indexes[index].last {
            let promise = RXPromise()
            
            _ = search(index: first, value: last).thenOnMain({ success in
                if let users = success as? [PUser], let user = users.first {
                    promise.resolve(withResult: user)
                } else {
                    promise.resolve(withResult: search(for: user, index: index + 1))
                }
                return success
            }, { error in
                promise.reject(withReason: error)
                return error
            })
            
            return promise
            
        } else {
            return RXPromise.reject(withReason: nil)
        }

    }
    
    @objc public static func search(index: String, value: String) -> RXPromise {
        var users = [PUser]()
        let promise = RXPromise()
        
        // For some reason, limit 1 doesn't work...
        _ = BChatSDK.search().users(forIndexes: [index], withValue: value, limit: 2, userAdded: { user in
            if let user = user {
                users.append(user)
            }
        }).thenOnMain({ result in
            promise.resolve(withResult: users)
            return result
        }, { error in
            promise.reject(withReason: error)
            return error
        })

        return promise
    }
}
