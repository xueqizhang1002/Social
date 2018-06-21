//
//  SCUser.h
//  SocialApp
//
//  Created by Michelle on 12/28/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUser : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;

- (instancetype) initWithUsername:(NSString *)username andPassword:(NSString *)password;
@end
