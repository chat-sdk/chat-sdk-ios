//
//  BMentionViewManager.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 14/09/2017.
//
//

#import "BMentionViewManager.h"
#import "BMentionTextInputView.h"

@implementation BMentionViewManager

static BMentionViewManager * manager;

+(BMentionViewManager *) sharedManager {
    
    @synchronized(self) {
        // If the sharedSoundManager var is nil then we need to allocate it.
        if(manager == nil) {
            // Allocate and initialize an instance of this class
            manager = [[self alloc] init];
        }
    }
    return manager;
}

- (void)createChooserViewWithFrame: (CGRect)frame {
    
    UIView * item = [[NSBundle chatUIBundle] loadNibNamed:@"BMentionTextInputView" owner:nil options:nil][0];
    
    item.frame = frame;
    _chooserView = item;
}

- (UIView *)getChooserView {
    return _chooserView;
}

@end




