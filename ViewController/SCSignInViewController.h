//
//  SCSignInViewController.h
//  SocialApp
//
//  Created by Michelle on 12/29/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSignInViewControllerDelegate <NSObject>

- (void)loginSuccess;

@end

@interface SCSignInViewController : UIViewController

@property (nonatomic, weak) id<SCSignInViewControllerDelegate> delegate;

@end
