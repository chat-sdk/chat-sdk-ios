//
//  BStickerView.m
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 07/11/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BChatOptionsCollectionView.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bCellIdentifier @"CellIdentifier"
#define bImageNames @"stickerImageNames"

#define bImageViewTag 1
#define bLabelTag 2

#define bRows 2
#define bColumns 4

@implementation BChatOptionsCollectionView

@synthesize collectionView;
@synthesize pageControl;

-(instancetype) init {
    if((self = [super init])) {
        
        _itemsPerPage = bRows * bColumns;
        
        _options = BChatSDK.ui.chatOptions;
        
//        for(BChatOption * o in _options) {
//            o.parent = self;
//        }
        
        [self loadView];
    }
    return self;
}

- (void)loadView {
    
    // Create a flow layout for the collection view that scrolls horizontally and has no space between items
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // Device is an iPad
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    }
    // Device is an iPhone
    else {
        // We add the 10 to take care of the page control below
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.minimumLineSpacing = 1;
        _flowLayout.minimumInteritemSpacing = 1;
        
    }
    
    // Set up the page control
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    
    // Add a target that will be invoked when the page control is changed by tapping on it
    [pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Set the number of pages to the number of pages in the paged interface and let the height flex so that it sits nicely in its frame
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    
    [self addSubview:pageControl];
    
    pageControl.keepBottomInset.equal = 0;
    pageControl.keepHeight.equal = 30;
    pageControl.keepWidth.equal = 80;
    [pageControl keepHorizontallyCentered];
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    if (@available(iOS 13.0, *)) {
        collectionView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    
    [self addSubview:collectionView];
    
    collectionView.keepTopInset.equal = 10;
    collectionView.keepRightInset.equal = 10;
    collectionView.keepLeftInset.equal = 10;
    collectionView.keepBottomOffsetTo(pageControl).equal = 0;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:bCellIdentifier];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    // Refresh the number of pages to be the same as the number of sections
    // Uses (a + n - 1)/n to get the integer value of how many pages there should be
    return pageControl.numberOfPages = (_options.count + (_itemsPerPage - 1))/_itemsPerPage;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemsPerPage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell * cell = [collectionView_ dequeueReusableCellWithReuseIdentifier:bCellIdentifier forIndexPath:indexPath];
    
    // Add the images to the collectionViewCells
    UIImageView * imageView = (UIImageView *) [cell.contentView viewWithTag:bImageViewTag];

    UILabel * label = (UILabel *) [cell.contentView viewWithTag:bLabelTag];
    
    if (!label) {
        label = [[UILabel alloc] init];
        label.tag = bLabelTag;
        
        [cell.contentView addSubview:label];
        
        label.keepHeight.equal = 30;
        label.keepHorizontalInsets.equal = 0;
        label.keepBottomInset.equal = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
    }
    
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.tag = bImageViewTag;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell.contentView addSubview:imageView];
        
        imageView.keepTopInset.equal = 10;
        imageView.keepHorizontalInsets.equal = 10;
        imageView.keepBottomOffsetTo(label).equal = 0;
    }
    
    cell.layer.cornerRadius = 10;
    
    // Calculates the cell number with regards to the array of images
    NSInteger value = indexPath.row + _itemsPerPage * indexPath.section;
    
    if (_options.count > value) {
        imageView.image = [((BChatOption *)_options[value]) icon];
        label.text = [((BChatOption *)_options[value]) title];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // This means we have bought it so can use it
    NSInteger value = indexPath.row + _itemsPerPage * indexPath.section;
    
    if (_options.count > value) {
        
        BChatOption * option = _options[value];
        [option execute:_delegate.currentViewController threadEntityID:_delegate.threadEntityID handler:self];
        
        // Get a pointer to the current and previously clicked cells
        UICollectionViewCell * currentCell = [collectionView cellForItemAtIndexPath:indexPath];
        

        if (@available(iOS 13.0, *)) {
            // Quickly highlight and fade the cell to show that it has been clicked to the user
            currentCell.backgroundColor = UIColor.systemGray3Color;
            [UIView animateWithDuration:0.5 animations:^{
                currentCell.backgroundColor = [UIColor systemBackgroundColor];
            }];
        } else {
            // Quickly highlight and fade the cell to show that it has been clicked to the user
            currentCell.backgroundColor = [BCoreUtilities colorWithHexString:@"#64bcff"];
            [UIView animateWithDuration:0.5 animations:^{
                currentCell.backgroundColor = [UIColor whiteColor];
            }];
        }

    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = collectionView.fw  - _flowLayout.sectionInset.left - _flowLayout.sectionInset.right - _flowLayout.minimumInteritemSpacing * (bColumns - 1) ;
    float height = collectionView.fh  - _flowLayout.sectionInset.top - _flowLayout.sectionInset.bottom - _flowLayout.minimumLineSpacing * (bRows - 1);
    
    return CGSizeMake(width / bColumns, height / bRows);
}

- (void)pageControlChanged:(UIPageControl *)pageControl {
    
    CGFloat pageWidth = collectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [collectionView setContentOffset:scrollTo animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = collectionView.frame.size.width;
    pageControl.currentPage = collectionView.contentOffset.x / pageWidth;
}

-(BOOL) show {
    return YES;
}

-(BOOL) hide {
    return YES;
}

-(UIView *) keyboardView {
    return self;
}

-(void) presentView: (UIView *) view {
    [self dismissView];
    _modalView = view;
    [self.keyboardView addSubview:_modalView];
    _modalView.keepInsets.equal = 0;
}

-(void) dismissView {
    if(_modalView) {
        [_modalView removeFromSuperview];
        _modalView = Nil;
    }
}

-(void) setOptionsDelegate: (id<BChatOptionDelegate>) delegate {
    self.delegate = delegate;
}


@end
