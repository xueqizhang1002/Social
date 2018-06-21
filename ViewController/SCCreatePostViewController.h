//
//  SCCreatePostViewController.h
//  SocialApp
//
//  Created by Michelle on 1/1/18.
//  Copyright © 2018 Zhang, Suki. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCreatePostViewControllerDelegate <NSObject>

- (void)didCreatePost;

@end

@interface SCCreatePostViewController : UIViewController

@property (nonatomic, weak) id<SCCreatePostViewControllerDelegate> delegate;

@end

