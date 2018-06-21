//
//  SCPost.m
//  SocialApp
//
//  Created by Michelle on 11/27/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import "SCPost.h"

@implementation SCPost

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = dict[@"user"];
        self.message = dict[@"message"];
        CLLocationDegrees latitute = [dict[@"location"][@"lat"] doubleValue];
        CLLocationDegrees longtitude = [dict[@"location"][@"lon"] doubleValue];
        self.location = [[CLLocation alloc] initWithLatitude:latitute longitude:longtitude];
        self.imageURL = dict[@"url"];
    }
    return self;
}
@end
