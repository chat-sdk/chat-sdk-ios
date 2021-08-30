//
//  BStickerView.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 07/11/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ChatSDK/PChatOptionsHandler.h>

@class BChatViewController;
@protocol BChatOptionDelegate;

@interface BChatOptionsCollectionView : UIView <PChatOptionsHandler, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate> {
    NSMutableArray * _options;
    NSInteger _itemsPerPage;
    UICollectionViewFlowLayout * _flowLayout;
    UIView * _modalView;
}

@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) UIPageControl * pageControl;
@property (nonatomic, readwrite, weak) id<BChatOptionDelegate> delegate;


@end
