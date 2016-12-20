//
//  NSObject+AssociatedObject.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 24/03/2016.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (AssociatedObject)

- (void)setAssociatedObject:(id)object key: (NSString *) key;
- (id)associatedObjectWithKey: (NSString *) key;

@end
