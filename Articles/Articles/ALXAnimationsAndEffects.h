//
//  ALXAnimations.h
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/23/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALXAnimationsAndEffects : NSObject

-(void) scaleAnimation:(CALayer *)layer WithBounciness:(float)bounciness ToValueWidth:(float) width Height:(float) height;
-(void) slideFromTheRight:(CALayer*) layer FromValue: (float) value Bounciness: (int) bounciness WithSpeed:(float) speed;
-(void) slide: (CALayer*) layer FromValue:(float) value  WithBounciness: (float) bounciness Speed: (float) speed AndResizeWidth: (float) width Height: (float) height;
- (UIImage*) captureBlurInView:(UIView*) view;

@end
