//
//  TWTRGenericKeychainItem.h
//  TwitterCore
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const TWTRGenericKeychainItemErrorDomain;

/**
 * The TWTRGenericKeychainQuery provides an simple model object
 * that can be used in conjuction with TWTRGenericKeychainItem to
 * retrieve items in the keychain.
 */
@interface TWTRGenericKeychainQuery : NSObject

/**
 * The name of the service corresponding with kSecAttrService.
 * If this value is specified the genericValue and accessGroup values are ignored.
 */
@property (nonatomic, copy, readonly, nullable) NSString *service;

/**
 * The name of the account corresponding with kSecAttrAccount.
 * If this value is specified the genericValue and accessGroup values are ignored.
 */
@property (nonatomic, copy, readonly, nullable) NSString *account;

/**
 * A generic value corresponding with kSecAttrGeneric.
 */
@property (nonatomic, copy, readonly, nullable) NSString *genericValue;

/**
 * The access group corresponding with kSecAttrAccessGroup.
 * This value is not used in equality checks.
 * Note: This value is ignored in the simulator.
 */
@property (nonatomic, copy, readonly, nullable) NSString *accessGroup;

/**
 * A query that will return all the items in the keychain.
 */
+ (instancetype)queryForAllItems;

/**
 * A query that will return all items with the given service.
 */
+ (instancetype)queryForService:(NSString *)service;

/**
 * A query that will return all items with the given account.
 */
+ (instancetype)queryForAccount:(NSString *)account;

/**
 * A query that will match all items that contain both the service and account.
 */
+ (instancetype)queryForService:(NSString *)service account:(NSString *)account;

/**
 * A query that will return all items with the given generic value.
 */
+ (instancetype)queryForGenericValue:(NSString *)genericValue;

/**
 * A query that will return all items with the given access group.
 */
+ (instancetype)queryForAccessGroup:(NSString *)accessGroup;

@end

/**
 * The TWTRGenericKeychainItem provides a convenience wrapper
 * around the security framework's keychain access.  All of
 * the items stored using this class will be stored as
 * kSecClassGenericPassword objects.
 */
@interface TWTRGenericKeychainItem : NSObject

/**
 * A value which specifies the item's service attribute. This
 * value represents the service associated with this item.
 */
@property (nonatomic, copy, readonly) NSString *service;

/**
 * A value which represents the items account name.
 */
@property (nonatomic, copy, readonly) NSString *account;

/**
 * The item that is intended to be kept secret. This may be
 * something like a password for an account or an oauth token.
 *
 * @warning If this data is too large it will fail to save. The size
 * should be smaller than ~2mb but can change from device to device.
 */
@property (nonatomic, copy, readonly) NSData *secret;

/**
 * An optional value that can be set on the item.
 */
@property (nonatomic, copy, readonly, nullable) NSString *genericValue;

/**
 * Returns the date that the item was last saved to the store. This value
 * is nil until the item is actually saved.
 */
@property (nonatomic, copy, readonly, nullable) NSDate *lastSavedDate;

/**
 * An optional value that can be used to specify the items accesss group.
 * If this value is not set the default access group which is only
 * accessible from the calling application will be used.
 *
 * Refer to 'Keychain Services Programming Guide' for more information
 * regarding access groups. Most of the time you will
 * want to leave this value empty.
 *
 * This value may not be empty upon fetch even if it is empty when it is saved. This
 * is because the security framework will fill it with the default value which
 * is not specified.
 */
@property (nonatomic, copy, readonly, nullable) NSString *accessGroup;

/**
 * Fetches all of the stored items for the given query.
 * If the returned array is nil it indicates that an error
 * has occurred and the error parameter will be set. If no
 * items are found an empty array will be returned.
 *
 * The query results will depend on the specificity of the query
 * object as described in its documetation.
 */
+ (NSArray *)storedItemsMatchingQuery:(TWTRGenericKeychainQuery *)query error:(NSError **)error;

/**
 * Removes all the items matching the given query.
 */
+ (BOOL)removeAllItemsForQuery:(TWTRGenericKeychainQuery *)query error:(NSError **)error;

/**
 * Initializes a TWTRGenericKeychainItem object with the given values.
 * This does not automatically save the object, you must call -[TWTRGenericKeychainItem storeInKeychain:]
 to actually save the object.
 *
 * A keychain item is uniquely constrained by the service/account combination. Any action performed
 * with the keychain item will override any existing keychain items with the given service/account
 * combination.
 *
 * @param service the service for this item.
 * @param account the account associated with this item.
 * @param secret the secret value to store.
 * @param genericValue an additional value to associate with this item.
 * @param accessGroup the access group for this item. If empty uses the default access group. *
 */
- (instancetype)initWithService:(NSString *)service account:(NSString *)account secret:(NSData *)secret;
- (instancetype)initWithService:(NSString *)service account:(NSString *)account secret:(NSData *)secret genericValue:(nullable NSString *)genericValue;
- (instancetype)initWithService:(NSString *)service account:(NSString *)account secret:(NSData *)secret genericValue:(nullable NSString *)genericValue accessGroup:(nullable NSString *)accessGroup;

/**
 * Call this method to store the keychain item in the store.
 *
 * A TWTRGenericKeychainItem is only unique based on the account
 * and the service specified. If the item exists and the replaceExisting parameter
 * is YES the value will be replaced. If this parameter is NO the operation will
 * fail.
 *
 * @param replacesExisting whether an existing value should be replaced, Default = YES
 * @param error an optional error that will be set if the operation fails.
 * @return a value representing if the operation was successful
 */
- (BOOL)storeInKeychain:(NSError **)error;
- (BOOL)storeInKeychainReplacingExisting:(BOOL)replaceExisting error:(NSError **)error;

/**
 * Attempts to remove the wrapper from the keychain.
 *
 * The keychain item is only unique based on the service/account
 * pair. So a value that is created with the same service/account
 * but different secret will remove the existing value.
 *
 * @return a value representing if the operation was successful
 */
- (BOOL)removeFromKeychain:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
