//
//  UIImage+ImageEffects.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

@interface UIImage(ImageEffects)

-(UIImage *) applyLightEffect;
-(UIImage *) applyExtraLightEffect;
-(UIImage *) applyDarkEffect;
-(UIImage *) applyTintEffectWithColor:(UIColor *)tintColor;
-(UIImage *) applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
