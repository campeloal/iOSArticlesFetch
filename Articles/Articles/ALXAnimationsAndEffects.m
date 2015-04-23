//
//  ALXAnimations.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/23/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXAnimationsAndEffects.h"
#import "UIImage+ImageEffects.h"
#import <POP/POP.h>

@implementation ALXAnimationsAndEffects

-(void) scaleAnimation:(CALayer*) layer WithBounciness:(float) bounciness
          ToValueWidth:(float) width Height: (float) height
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(width, height)];
    scaleAnimation.springBounciness = bounciness;
    [layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void) slideFromTheRight:(CALayer*) layer FromValue: (float) value Bounciness: (int) bounciness WithSpeed:(float) speed
{
    POPSpringAnimation *posXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    posXAnimation.fromValue = @(value);
    posXAnimation.springBounciness = bounciness;
    posXAnimation.springSpeed =speed;
    [layer pop_addAnimation:posXAnimation forKey:@"slideAnim"];
}

-(void) slide: (CALayer*) layer FromValue:(float) value  WithBounciness: (float) bounciness Speed: (float) speed AndResizeWidth: (float) width Height: (float) height
{
    POPSpringAnimation *posXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    
    posXAnimation.fromValue = @(value);
    posXAnimation.springBounciness = bounciness;
    posXAnimation.springSpeed =speed;
    
    sizeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(width, height)];
    
    [layer pop_addAnimation:posXAnimation forKey:@"posXAnim"];
    [layer pop_addAnimation:sizeAnimation forKey:@"sizeAnim"];
}

- (UIImage*) captureBlurInView:(UIView*) view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *imageToBlur = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage* blurredImage = [imageToBlur applyLightEffect];
    
    return blurredImage;
}

@end
