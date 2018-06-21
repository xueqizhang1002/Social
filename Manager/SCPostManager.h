//
//  SCPostManager.h
//  SocialApp
//
//  Created by Michelle on 12/31/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CLLocation;
@class SCPost;

@interface SCPostManager : NSObject

// Create posts with message
+ (void)createPostWithMessage:(NSString *)message imageFile:(UIImage *)image andCompletion:(void (^)(NSError *error))completionBlock;

// Load all posts within a givin location and range
+ (void)getPostsWithLocation:(CLLocation *)location range:(NSInteger)range andCompletion:(void(^)(NSArray <SCPost *> *posts, NSError *error))completionBlock;

@end
