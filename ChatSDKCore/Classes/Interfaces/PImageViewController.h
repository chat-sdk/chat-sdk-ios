//
//  PImageViewController.h
//  Pods
//
//  Created by Ben on 8/7/18.
//

#ifndef PImageViewController_h
#define PImageViewController_h

@protocol PImageViewController

-(void) setImage: (UIImage *) image;
-(void) setImageURL: (NSURL *) imageURL;
-(void) setHideSaveButton: (BOOL) hide;

@end

#endif /* PImageViewController_h */
