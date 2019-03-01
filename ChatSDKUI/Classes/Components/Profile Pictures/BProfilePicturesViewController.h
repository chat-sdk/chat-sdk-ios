//
//  BProfilePicturesViewController.h
//  ChatSDK
//
//  Created by Pepe Becker on 08/02/2019.
//  Copyright © 2019 Pepe Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PUser.h>
#import <TOCropViewController/TOCropViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface BProfilePicturesViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, TOCropViewControllerDelegate>

@property (nonatomic, strong) id<PUser> user;

@end

NS_ASSUME_NONNULL_END
