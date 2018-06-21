//
//  SCPostDetailViewController.h
//  SocialApp
//
//  Created by Michelle on 1/4/18.
//  Copyright © 2018 Zhang, Suki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPost;

@interface SCPostDetailViewController : UIViewController

- (void)loadDetailViewWithPost:(SCPost *)post;

@end
