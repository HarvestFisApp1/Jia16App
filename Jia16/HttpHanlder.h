//
//  HttpHanlder.h
//  Jia16
//
//  Created by Ares on 16/8/3.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

typedef enum
{
    DMHttpResponseType_Json,
    DMHttpResponseType_Common
} DMHttpResponseType;

@interface HttpHanlder : AFHTTPRequestOperationManager
- (void)requestPostRsaMethodUrl:(NSString *)url
                     parameters:(NSDictionary *)paras
                        success:(void(^)(AFHTTPRequestOperation *operation, NSObject *resultObject))success
                        failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)requestPostMethodUrl:(NSString *)url
                   withParas:(NSString *)paras
                     success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)requestPostMethodUrlWithStr:(NSString *)url
                   withParas:(NSString *)paras
                     success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)requestGetMethodUrl:(NSString *)url
                  withParas:(NSString *)paras
                    success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)requestPostMethodUrl1:(NSString *)url
                    withParas:(NSString *)paras
                      success:(void(^)(AFHTTPRequestOperation *operation, NSObject *resultObject))success
                      failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
