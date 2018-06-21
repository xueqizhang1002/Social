//
//  SCSpinnerView.m
//  SocialApp
//
//  Created by Michelle on 1/4/18.
//  Copyright © 2018 Zhang, Suki. All rights reserved.
//

#import "SCSpinnerView.h"

static UIImageView *spinnerView = nil;

@implementation SCSpinnerView

+ (void)presentSpinnerInView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!spinnerView) {
            spinnerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Spinner"]];
        }
        CABasicAnimation *rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
        rotationAnimation.speed = 20.0f;
        rotationAnimation.duration = 10.0f;
        rotationAnimation.repeatCount = INFINITY;
        
        [spinnerView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        spinnerView.center = view.center;
        [view addSubview:spinnerView];
    });
}

+ (void)removeSpinner {
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinnerView.layer removeAllAnimations];
        [spinnerView removeFromSuperview];
    });
}

@end
