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

/**
 *  Scale animation using POP library
 *
 *  @param layer      layer to apply animation
 *  @param bounciness bounce factor
 *  @param width      final width
 *  @param height     final height
 */
-(void) scaleAnimation:(CALayer*) layer WithBounciness:(float) bounciness
          ToValueWidth:(float) width Height: (float) height
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(width, height)];
    scaleAnimation.springBounciness = bounciness;
    [layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

/**
 *  Slide from the right to the left using POP library
 *
 *  @param layer      layer to apply animation
 *  @param value      initial value for the slide position
 *  @param bounciness bounce factor
 *  @param speed      slide's speed
 */
-(void) slideFromTheRight:(CALayer*) layer FromValue: (float) value Bounciness: (int) bounciness WithSpeed:(float) speed
{
    POPSpringAnimation *posXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    posXAnimation.fromValue = @(value);
    posXAnimation.springBounciness = bounciness;
    posXAnimation.springSpeed =speed;
    [layer pop_addAnimation:posXAnimation forKey:@"slideAnim"];
}


/**
 *  Animation that combines slide and resize
 *
 *  @param layer      layer to apply animations
 *  @param value      initial value for the slide position
 *  @param bounciness bounce factor
 *  @param speed      slide's speed
 *  @param width      final width for resizing
 *  @param height     final height for resizing
 */
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

/**
 *  Apply blur on a view using UIImage+ImageEffects library
 *
 *  @param view view to capture the blur
 *
 *  @return the blurred image
 */
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
