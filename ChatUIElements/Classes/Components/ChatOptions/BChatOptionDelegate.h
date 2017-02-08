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
@protocol PThread;

@protocol BChatOptionDelegate <NSObject>

-(id<PThread>) currentThread;
-(UIViewController *) currentViewController;
-(void) chatOptionActionExecuted: (RXPromise *) promise;
-(void) reloadData;

@end

#endif /* BChatOptionsDelegate_h */
