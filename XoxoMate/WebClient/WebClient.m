//
//  WebClient.m
//  TMBomb
//
//  Created by Manish Dudharejia on 04/07/15.
//  Copyright (c) 2015 Manish Dudharejia. All rights reserved.
//

#import "WebClient.h"
#import "AFNetworking.h"
#import "Constants.h"
//#import "Helper.h"

@implementation WebClient

+ (void)requestWithUrl:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
//    [manager.requestSerializer setValue:kLend_API_KEY forHTTPHeaderField:@"PC-API-KEY"];
    
    [manager POST:stUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            if(success) {
                success(responseObject);
            }
        }
        else {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if(success) {
                success(response);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(failure) {
            failure(error);
        }
    }];
}

+ (void)requestWithUrlplusLoader:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
//    [manager.requestSerializer setValue:kLend_API_KEY forHTTPHeaderField:@"PC-API-KEY"];
    [manager POST:stUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            if(success) {
                success(responseObject);
            }
        }
        else {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if(success) {
                success(response);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(failure) {
            failure(error);
        }
    }];
}

+ (void)requestWithUrlWithResultVerification:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:stUrl parmeters:parameters success:^(NSDictionary *response) {
        if([[response objectForKey:@"success"] boolValue]) {
            if(success) {
                success(response);
            }
        }
        else {
            NSError *error = [NSError errorWithDomain:@"Error" code:kDefaultErrorCode userInfo:@{NSLocalizedDescriptionKey:[response objectForKey:@"message"]}];
            if(failure) {
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

+ (void)requestWithUrlWithResultVerificationWithLoder:(NSString *)stUrl parmeters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure {
    [self requestWithUrl:stUrl parmeters:parameters success:^(NSDictionary *response) {
        if(response) {
            if(success) {
                success(response);
            }
        }
        else {
            NSError *error = [NSError errorWithDomain:@"Error" code:kDefaultErrorCode userInfo:nil];
            if(failure) {
                failure(error);
            }
        }
    } failure:^(NSError *error) {
        if(failure) {
            failure(error);
        }
    }];
}

@end
