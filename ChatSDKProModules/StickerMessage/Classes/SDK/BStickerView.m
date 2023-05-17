//
//  BStickerView.m
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 07/11/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BStickerView.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "StickerMessage.h"
#import <MessageModules/MessageModules-Swift.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

//#import "Headers.h"

#define bCellIdentifier @"CellIdentifier"

#define bImageViewTag 1


@implementation BStickerView {
    StickerManager * manager;
}

@synthesize stickerCollectionView;
@synthesize iconCollectionView;
@synthesize stickerPageControl;
@synthesize topLineView;
@synthesize enableBackButton;

-(instancetype) initWithPacksAtTop: (BOOL) atTop {
    _packsAtTop = atTop;
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        manager = StickerMessageModule.shared.manager;

//        self.backgroundColor = self.defaultBackgroundColor;
        
//        _itemsPerPage = bRows * bColumns;
       
        [manager getStickerPacks].thenOnMain(^id(id success) {
            [self reloadStickerData];
            return success;
        }, ^id(NSError * error) {
            [self showToast:error.localizedDescription];
            return error;
        });
        
        [self loadView];
    }
    return self;
}

-(int) rows {
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 1;
    } else {
        return 2;
    }
}

-(int) columns {
    if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return 8;
    } else {
        return 4;
    }
}

-(int) itemsPerPage {
    return self.rows * self.columns;
}

- (void)loadView {
    
    // Create a flow layout for the collection view that scrolls horizontally and has no space between items
    enableBackButton = true;
    
    _stickerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    _stickerFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _stickerFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _stickerFlowLayout.minimumLineSpacing = 1;
    _stickerFlowLayout.minimumInteritemSpacing = 1;
    
    UICollectionViewFlowLayout * iconFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    iconFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    iconFlowLayout.minimumLineSpacing = 0;
    iconFlowLayout.minimumInteritemSpacing = 0;
    iconFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    iconCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:iconFlowLayout];
    iconCollectionView.delegate = self;
    iconCollectionView.dataSource = self;
    iconCollectionView.backgroundColor = self.defaultBackgroundColor;
    
    iconCollectionView.showsHorizontalScrollIndicator = NO;
    iconCollectionView.pagingEnabled = YES;
    
    [self addSubview:iconCollectionView];
    
    // Move the text input up to avoid the bottom area
    if (_packsAtTop) {
        iconCollectionView.keepTopInset.equal = 0;
    } else {
        if (@available(iOS 11, *)) {
            iconCollectionView.keepBottomInset.equal = 20;
        } else {
            iconCollectionView.keepBottomInset.equal = 0;
        }
    }

    iconCollectionView.keepLeftInset.equal = 0;
    iconCollectionView.keepRightInset.equal = 0;
    iconCollectionView.keepHeight.equal = 50;
    
    [iconCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bCellIdentifier];
    
    // Set up the page control
    stickerPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    
    if (@available(iOS 14, *)) {
        stickerPageControl.backgroundStyle = UIPageControlBackgroundStyleProminent;
    }

    // Add a target that will be invoked when the page control is changed by tapping on it
    [stickerPageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        
    [self addSubview:stickerPageControl];
    
    if (_packsAtTop) {
        stickerPageControl.keepBottomInset.equal = 20;
    } else {
        stickerPageControl.keepBottomOffsetTo(iconCollectionView).equal = 5;
    }
    stickerPageControl.keepHeight.equal = 20;
    [stickerPageControl keepHorizontallyCentered];
        
    topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
//    topLineView.backgroundColor = self.defaultSelectedColor;
    [self addSubview:topLineView];
    
    stickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_stickerFlowLayout];
    stickerCollectionView.delegate = self;
    stickerCollectionView.dataSource = self;
    stickerCollectionView.backgroundColor = self.defaultBackgroundColor;
    
    stickerCollectionView.showsHorizontalScrollIndicator = NO;
    stickerCollectionView.pagingEnabled = YES;
    
    [self addSubview:stickerCollectionView];
    
    if (_packsAtTop) {
        stickerCollectionView.keepTopOffsetTo(iconCollectionView).equal = 1;
    } else {
        stickerCollectionView.keepTopInset.equal = 1;
    }
    stickerCollectionView.keepRightInset.equal = 0;
    stickerCollectionView.keepLeftInset.equal = 0;
    stickerCollectionView.keepBottomOffsetTo(stickerPageControl).equal = 5;
    
    [stickerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bCellIdentifier];

    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView isEqual:stickerCollectionView]) {
        
        float width = collectionView.fw  - _stickerFlowLayout.sectionInset.left - _stickerFlowLayout.sectionInset.right - _stickerFlowLayout.minimumInteritemSpacing * (self.columns - 1) ;
        float height = collectionView.fh  - _stickerFlowLayout.sectionInset.top - _stickerFlowLayout.sectionInset.bottom - _stickerFlowLayout.minimumLineSpacing * (self.rows - 1);
        
        return CGSizeMake(width / self.columns, height / self.rows);
    }
    else {
        return CGSizeMake(50, 50);
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([collectionView isEqual:iconCollectionView]) {
        return 1;
    }
    if ([collectionView isEqual:stickerCollectionView]) {
        // Refresh the number of pages to be the same as the number of sections
        // Uses (a + n - 1)/n to get the integer value of how many pages there should be
        int pages = ceil((float)([manager packAt: _packIndex].stickers.count) / (float)self.itemsPerPage);
        stickerPageControl.numberOfPages = pages;
        return pages;
    }
    return 0;
    
//    NSInteger stickerPages = stickerPageControl.numberOfPages = ([_stickersData[_packIndex][bStickers] count] + (_itemsPerPage - 1))/_itemsPerPage;
//
//    return [collectionView isEqual:stickerCollectionView] ? stickerPages : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:iconCollectionView]) {
        if (enableBackButton) {
            return manager.packs.count + 1;
        } else {
            return manager.packs.count;
        }
    }
    if ([collectionView isEqual:stickerCollectionView]) {
        return self.itemsPerPage;
    }
    return 0;
//    return [collectionView isEqual:stickerCollectionView] ? _itemsPerPage : _stickersData.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:bCellIdentifier forIndexPath:indexPath];
    
    // Add the images to the collectionViewCells
    FLAnimatedImageView * imageView = (FLAnimatedImageView *) [cell.contentView viewWithTag:bImageViewTag];
    
    if (!imageView) {
        imageView = [[FLAnimatedImageView alloc] init];
        imageView.tag = bImageViewTag;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        [cell.contentView addSubview:imageView];
        
        imageView.keepTopInset.equal = 1;
        imageView.keepLeftInset.equal = 1;
        imageView.keepBottomInset.equal = 0;
        imageView.keepRightInset.equal = 0;

//        imageView.keepInsets.equal = 1;
    }
    imageView.image = Nil;
    imageView.backgroundColor = self.defaultBackgroundColor;


    if ([collectionView isEqual:stickerCollectionView]) {
        
        // Calculates the cell number with regards to the array of images
        NSInteger index = indexPath.row + self.itemsPerPage * indexPath.section;

        //        NSDictionary * stickerData = _stickersData[_packIndex];
        
        StickerPack * pack = [manager packAt:_packIndex];
        
        if (pack.stickers.count > index) {
            
            imageView.animatedImage = nil;
            imageView.image = nil;

            Sticker * sticker = [pack stickerAt: index];
            
            if(sticker.url && sticker.url.length) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:sticker.url]];
            } else {
                if (sticker.isAnimated) {
                    imageView.animatedImage = sticker.animatedImage;
                } else {
                    imageView.image = sticker.image;
                }
            }
            if (sticker.isAnimated) {
                imageView.contentMode = UIViewContentModeScaleAspectFill;
            } else {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
            }

        }
        cell.layer.cornerRadius = 10;
        
    }
    else {
        cell.backgroundColor = self.defaultBackgroundColor;
        
        if(indexPath.row == 0 && enableBackButton) {
            imageView.image = [NSBundle uiImageNamed:@"icn_140_back"];
        }
        else {
            int index = enableBackButton ? indexPath.row - 1 : indexPath.row;
            
            StickerPack * pack = [manager packAt:index];
            
            if (pack.url && pack.url.length) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:pack.url]];
            } else {
                imageView.image = pack.icon;
            }
            
            // Initially set the first cell as highlighted - as soon as we click a cell previous will stop being -1
            if (index == _packIndex) {
                cell.backgroundColor = self.defaultSelectedColor;
            }
            
        }
        cell.layer.cornerRadius = 0;
    }
    
    return cell;
}

-(UIColor *) defaultBackgroundColor {
    return [UIColor clearColor];
//    if (@available(iOS 13, *)) {
//        return [UIColor systemBackgroundColor];
//    } else {
//        return [UIColor whiteColor];
//    }
}

-(UIColor *) defaultSelectedColor {
    if (@available(iOS 13, *)) {
        return UIColor.systemGray3Color;
    } else {
        return [BCoreUtilities colorWithHexString:@"#64bcff"];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Call this if you click a sticker
    if ([collectionView isEqual:stickerCollectionView]) {
        
        // This means we have bought it so can use it
        NSInteger index = indexPath.row + self.itemsPerPage * indexPath.section;
        StickerPack * pack = [manager packAt:_packIndex];
        
        if (pack.stickers.count > index) {
            
            // Get a pointer to the current and previously clicked cells
            UICollectionViewCell * currentCell = [stickerCollectionView cellForItemAtIndexPath:indexPath];
            
            // Quickly highlight and fade the cell to show that it has been clicked to the user
            currentCell.backgroundColor = self.defaultSelectedColor;
            
            [UIView animateWithDuration:0.5 animations:^{
                currentCell.backgroundColor = self.defaultBackgroundColor;
            }];
            
            Sticker * sticker = [pack stickerAt: index];
                        
            if(self.playSound && sticker.sound) {
                self.playSound(sticker.sound);
            }

            if(self.sendSticker != Nil) {
                self.sendSticker(sticker.imageName, sticker.url);
            }
            
        }
    }
    else {
        
        if(indexPath.row == 0 && enableBackButton) {
            if(self.back != Nil) {
                self.back();
            }
        }
        else {
            _packIndex = enableBackButton ? indexPath.row - 1 : indexPath.row;
            [self reloadStickerData];
        }
    }
}


- (void)pageControlChanged:(id)sender {
    UIPageControl * pageControl = sender;
    CGFloat pageWidth = stickerCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [stickerCollectionView setContentOffset:scrollTo animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = stickerCollectionView.frame.size.width;
    stickerPageControl.currentPage = round(stickerCollectionView.contentOffset.x / pageWidth);
}

- (void)reloadStickerData {
    [stickerCollectionView reloadData];
    [iconCollectionView reloadData];
}

@end

