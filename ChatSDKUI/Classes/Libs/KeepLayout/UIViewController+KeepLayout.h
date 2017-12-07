//
//  UIViewController+KeepLayout.h
//  Keep Layout
//
//  Created by Martin Kiss on 4.6.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIViewController (KeepLayout)


/// Lazy-loaded hidden view that can be used to align sibling views. This layoutView is aligned with view controller's safeAreaInsets on iOS 11 and topLayoutGuide and bottomLayoutGuide on older iOS versions. Don't add any subviews into this view, it's invisible.
@property (readonly) UIView *keepLayoutView API_DEPRECATED("Use .keepSafeInset and others", ios(7, 11));


@end


