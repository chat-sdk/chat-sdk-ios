//
//  UIViewController+Additions.h
//  ChatSDK
//
//  Created by ben3 on 23/11/2020.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController(Additions)

-(void) alertWithTitle: (NSString *) title withError: (NSError *) error;
-(void) alertWithTitle: (NSString *) title withMessage: (NSString *) message;
-(void) alertWithTitle: (NSString *) title withMessage: (NSString *) message actions: (NSArray<UIAlertAction *> *) actions;

@end

NS_ASSUME_NONNULL_END
