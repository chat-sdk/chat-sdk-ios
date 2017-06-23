//
//  TWTRMultipartFormDocument.h
//  TwitterCore
//
//  Created by Chase Latta on 8/19/15.
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TWTRMultipartFormDocumentLoadDataCallback)(NSData *data);

@interface TWTRMultipartFormElement : NSObject

/**
 * The name of the form element.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * The content type of the form element.
 */
@property (nonatomic, copy, readonly) NSString *contentType;

/**
 * An optional filename for this element.
 */
@property (nonatomic, copy, readonly, nullable) NSString *fileName;

/**
 * The content's data.
 */
@property (nonatomic, copy, readonly) NSData *content;

/**
 * Returns a fully initialized form element to be used in a multipart for document.
 *
 * @param name the name of the element
 * @param contentType the elements content type
 * @param fileName an optional file name
 * @param content the data associated with this item
 */
- (instancetype)initWithName:(NSString *)name contentType:(NSString *)contentType fileName:(nullable NSString *)fileName content:(NSData *)content NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

/**
 * A class representing a multipart form document.
 */
@interface TWTRMultipartFormDocument : NSObject

/**
 * The forms boundary
 */
@property (nonatomic, copy, readonly) NSString *boundary;

/**
 * Returns a value appropriate for the Content-Type header field
 */
@property (nonatomic, copy, readonly) NSString *contentTypeHeaderField;

/**
 * Instantiates the document with the given elements.
 *
 * @param formElements the elements to append to this document
 */
- (instancetype)initWithFormElements:(NSArray *)formElements NS_DESIGNATED_INITIALIZER;

/**
 * Asynchrounously loads the body data.
 *
 * @param callbackQueue the queue to invoke the handler on
 * @param completion the completion block to call with the loaded data.
 */
- (void)loadBodyDataWithCallbackQueue:(dispatch_queue_t)callbackQueue completion:(TWTRMultipartFormDocumentLoadDataCallback)completion;

@end

NS_ASSUME_NONNULL_END
