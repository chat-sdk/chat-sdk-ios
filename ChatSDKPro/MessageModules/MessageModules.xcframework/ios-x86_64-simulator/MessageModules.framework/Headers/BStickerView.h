//
//  BStickerView.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 07/11/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BStickerView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate> {
    
    NSArray * _identifiers;
    
    NSInteger _itemsPerPage;
    NSBundle * _bundle;
    NSBundle * _stickerBundle;
    
    UICollectionViewFlowLayout * _stickerFlowLayout;
    long _packIndex;
}

@property (strong, nonatomic) IBOutlet UICollectionView * stickerCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView * iconCollectionView;
@property (nonatomic, readwrite) UIView * topLineView;

@property (strong, nonatomic) UIPageControl * stickerPageControl;
@property (nonatomic, readwrite) BOOL enableBackButton;

@property (nonatomic, readwrite, copy) void(^sendSticker)(NSString * imageName);
@property (nonatomic, readwrite, copy) void(^playSound)(NSString * soundName);
@property (nonatomic, readwrite, copy) void(^back)(void);

@end
