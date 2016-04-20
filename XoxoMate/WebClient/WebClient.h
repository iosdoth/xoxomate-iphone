//
//  WebClient.h
//  TMBomb
//
//  Created by Manish Dudharejia on 04/07/15.
//  Copyright (c) 2015 Manish Dudharejia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebClient : NSObject

+ (void)requestWithUrl:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
+ (void)requestWithUrlplusLoader:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *))failure;
+ (void)requestWithUrlWithResultVerification:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;
+ (void)requestWithUrlWithResultVerificationWithLoder:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

@end
