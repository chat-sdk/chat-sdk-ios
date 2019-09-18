//
//  UIScrollView+KeepLayout.h
//  Keep Layout
//
//  Created by Martin Kiss on 13.11.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIScrollView (KeepLayout)


//! When set to YES, a view with special constraints is installed in the receiver to prevent expanding content width.
@property (setter=keepHorizontalScrollDisabled:) BOOL keepHorizontalScrollDisabled;
//! When set to YES, a view with special constraints is installed in the receiver to prevent expanding content height.
@property (setter=keepVerticalScrollDisabled:) BOOL keepVerticalScrollDisabled;


@end


