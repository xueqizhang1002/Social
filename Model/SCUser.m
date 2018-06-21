//
//  SCUser.m
//  SocialApp
//
//  Created by Michelle on 12/28/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import "SCUser.h"

@implementation SCUser

- (instancetype) initWithUsername:(NSString *)username andPassword:(NSString *)password {
    if (self = [super init]) {
        self.userName = username;
        self.password = password;
    }
    return self;
}

@end
