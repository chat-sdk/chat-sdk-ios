//
//  BMentionViewManager.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 14/09/2017.
//
//

#import <Foundation/Foundation.h>
#import <Hakawai/HKWMentionsPlugin.h>

@interface BMentionViewManager : NSObject

+(BMentionViewManager *) sharedManager;

- (UIView *)getChooserView;
- (void)createChooserViewWithFrame: (CGRect)frame;

@property (nonatomic, strong) UIView * chooserView;

@end


