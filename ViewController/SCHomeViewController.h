//
//  SCHomeViewController.h
//  SocialApp
//
//  Created by Michelle on 12/27/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPost;

@interface SCHomeViewController : UIViewController

- (void)loadResultPageWithPosts:(NSArray<SCPost *> *)posts;

@end
