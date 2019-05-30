//
//  BProfilePicturesViewController.m
//  ChatSDK
//
//  Created by Pepe Becker on 08/02/2019.
//  Copyright © 2019 Pepe Becker. All rights reserved.
//

#import "BProfilePicturesViewController.h"

#import <ChatSDK/UI.h>
#import "BProfilePicturesHelper.h"

#define pictureCellIdentifier @"PictureCell"

@implementation BProfilePicturesViewController {
    UIImagePickerController * _imagePicker;
    NSArray<NSString *> * _pictures;
    UIEdgeInsets _sectionInsets;
    CGFloat _itemsPerRow;
}

- (instancetype)init
{
    return [self initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSBundle t: NSLocalizedString(bProfilePictures, nil)];
    self.collectionView.backgroundColor = UIColor.whiteColor;

    if (!_user) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:pictureCellIdentifier];

    if (_user.isMe) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddPictureButton)];

        // attach long press gesture to collectionView
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.delegate = self;
        lpgr.delaysTouchesBegan = YES;
        [self.collectionView addGestureRecognizer:lpgr];
    }

    _itemsPerRow = 2;
    _sectionInsets = UIEdgeInsetsMake(8, 8, 8, 8);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadPictures];
}

- (void)updateAddPictureButton {
    if ([BProfilePicturesHelper nonnullPictures:_pictures].count < 5) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (NSArray<NSString *> *)picturesForUser:(id<PUser>)user {
    NSArray<NSString *> * pictures = [user.meta valueForKey:bUserPictures];
    if (pictures == nil || ![pictures isKindOfClass:NSArray.class]) {
        pictures = [NSArray new];
    }
    return [BProfilePicturesHelper setDefaultPicture:user.imageURL inPictures:pictures];
}

- (void)updateUI {
    [self updateAddPictureButton];
    [self.collectionView reloadData];
}

- (void)reloadPictures {
    _pictures = [self picturesForUser:_user];
    [self updateUI];
}

- (void)addPictureURL:(NSString *)url {
    _pictures = [BProfilePicturesHelper addPicture:url toPictures:_pictures];
    [self updateUI];
    [self savePictures];
}

- (void)removePictureURL:(NSString *)url {
    _pictures = [BProfilePicturesHelper removePicture:url fromPictures:_pictures];
    [self updateUI];
    [self savePictures];
}

- (void)setDefaultPictureURL:(NSString *)url {
    _pictures = [BProfilePicturesHelper setDefaultPicture:url inPictures:_pictures];
    [self updateUI];
    [BChatSDK.currentUser setImageURL:url];
    [self savePictures];
}

- (void)savePictures {
    if (!_user.isMe) return;

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSBundle t:bSaving];
    [BChatSDK.currentUser.meta setValue:_pictures forKey:bUserPictures];
    BChatSDK.core.pushUser.thenOnMain(^id(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self reloadPictures];
        return Nil;
    }, ^id(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self reloadPictures];
        return Nil;
    });
}

- (void)didPressAddPictureButton {
    if (!_user.isMe) return;

    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:Nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        TOCropViewController * cropViewController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:image];

        cropViewController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        cropViewController.resetAspectRatioEnabled = NO; // Clicking reset will keep the square aspect ration
        cropViewController.aspectRatioPickerButtonHidden = YES; // Disable users picking their own aspect ration
        cropViewController.delegate = self;

        [self presentViewController:cropViewController animated:YES completion:nil];
    }];
}

#pragma mark - <TOCropViewControllerDelegate>

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {

    image = [image resizedImage:bProfilePictureSize interpolationQuality:kCGInterpolationHigh];

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSBundle t:bSaving];
    [BChatSDK.upload uploadImage:image].thenOnMain(^id(NSDictionary * urls) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([BProfilePicturesHelper nonnullPictures:self->_pictures].count > 0) {
            [self addPictureURL:urls[bImagePath]];
        } else {
            [self setDefaultPictureURL:urls[bImagePath]];
        }
        [self savePictures];
        return Nil;
    }, ^id(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self reloadPictures];
        return Nil;
    });

    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:Nil];
}

#pragma mark <UIGestureRecognizerDelegate>

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (!_user.isMe) return;

    CGPoint p = [gestureRecognizer locationInView:self.collectionView];

    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil) return;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:[NSBundle t:bCancel] style:UIAlertActionStyleCancel handler:nil]];
    
    if ([BProfilePicturesHelper nonnullPictures:_pictures].count == 1) {
        alert.title = [NSBundle t:bDeleteLastPictureWarning];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    NSString * pictureURL = _pictures[indexPath.row];

    if (indexPath.row > 0) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSBundle t:bSetAsDefaultPicture] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self setDefaultPictureURL:pictureURL];
        }]];
    }

    __weak __typeof__(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:[NSBundle t:bDeletePicture] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __typeof__(self) strongSelf = weakSelf;
        if (indexPath.row == 0 && [BProfilePicturesHelper nonnullPictures:strongSelf->_pictures].count > 1) {
            NSString * secondPicture = [strongSelf->_pictures objectAtIndex:1];
            [self removePictureURL:pictureURL];
            [self setDefaultPictureURL:secondPicture];
        } else {
            [self removePictureURL:pictureURL];
        }
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [BProfilePicturesHelper nonnullPictures:_pictures].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:pictureCellIdentifier forIndexPath:indexPath];

    NSURL * imageURL = [NSURL URLWithString:[_pictures objectAtIndex:indexPath.row]];
    if (imageURL) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        [imageView sd_setImageWithURL:imageURL];
        [cell addSubview:imageView];
        imageView.keepInsets.equal = 0;
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fullWidth = self.view.bounds.size.width;
    CGFloat paddingSpace = _sectionInsets.left * (_itemsPerRow + 1);
    CGFloat availableWidth = fullWidth - paddingSpace;
    CGFloat sizePerItem = (availableWidth / _itemsPerRow) - 1;
    return CGSizeMake(sizePerItem, sizePerItem);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return _sectionInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return _sectionInsets.left;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
