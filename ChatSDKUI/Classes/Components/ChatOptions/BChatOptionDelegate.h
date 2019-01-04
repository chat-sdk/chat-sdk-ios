//
//  BChatOptionsDelegate.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#ifndef BChatOptionDelegate_h
#define BChatOptionDelegate_h

@class RXPromise;
@class CLLocation;

@protocol PThread;

@protocol BChatOptionDelegate <NSObject>

-(UIViewController *) currentViewController;
-(NSString *) threadEntityID;
-(void) reloadData;
-(void) hideKeyboard;

@end

#endif /* BChatOptionsDelegate_h */
