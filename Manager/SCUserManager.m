//
//  SCUserManager.m
//  SocialApp
//
//  Created by Michelle on 12/28/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//


#import "SCUserManager.h"
#import "SCUser.h"
#import "AFNetworking.h"

static NSString * const SCBaseURLString = @"https://around-75015.appspot.com";

@interface SCUserManager ()

@property (nonatomic, strong) SCUser *currentUser;

@end

@implementation SCUserManager

+ (SCUserManager *)sharedUserManager
{
    static SCUserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserManager = [SCUserManager new];
    });
    return sharedUserManager;
}

- (void)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password
{
    self.currentUser = [SCUser new];
    self.currentUser.userName = username;
    self.currentUser.password = password;
}

- (BOOL)isUserLogin
{
    return self.currentUser.userName.length > 0;
}

- (void)loginWithUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password andCompletionBlock:(void(^)(NSError *error))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/login",  SCBaseURLString];
    
    // create sesstion manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *body = @{@"username" : [username lowercaseString],
                           @"password" : password,
                           };
    // generate JSON string from NSDictioanry
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // create and config URL request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", nil];
    
    // API call with completion block
    __weak typeof(self) weakSelf = self;
    [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            weakSelf.currentUser = [[SCUser alloc] initWithUsername:username andPassword:password];
            NSString *token = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            weakSelf.currentUser.token = [NSString stringWithFormat:@"Bearer %@", token];
            NSLog(@"user successfully login with token: %@", token);
        }
        else {
            NSLog(@"user login fail: %@", error);
        }
        if (completionBlock) {
            completionBlock(error);
        }
    }] resume];
}

- (void)signupWithUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password andCompletionBlock:(void(^)(NSError *error))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@/signup",  SCBaseURLString];
    // create sesstion manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *body = @{@"username" : [username lowercaseString],
                           @"password" : password,
                           };
    // generate JSON string from NSDictioanry
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // create and config URL request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", nil];
    // API call with completion block
    [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Sign up API response: %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            [self loginWithUsername:username password:password andCompletionBlock:^(NSError * _Nullable error) {
                if (completionBlock) {
                    completionBlock(error);
                }
            }];
        }
        else {
            NSLog(@"fail to sign up: %@", error);
            if (completionBlock) {
                completionBlock(error);
            }
        }
    }] resume];
}

@end

