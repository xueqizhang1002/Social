//
//  SCPost.h
//  SocialApp
//
//  Created by Michelle on 11/27/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SCPost : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *imageURL;

- (instancetype)initWithDictionary:(NSDictionary *) dict;
@end
