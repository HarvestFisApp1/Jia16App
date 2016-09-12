//
//  HttpAPI.h
//  Jia16
//
//  Created by Ares on 16/8/3.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpHanlder.h"

typedef void (^JMWhenTappedBlock)();
@interface HttpAPI : NSObject

@property (nonatomic,strong) JMWhenTappedBlock block;

+ (instancetype)SharedCommonApi;

/********** Our app only use post method **********/

// GET RSA
- (void)requestPostRsaMethodUrl:(NSString *)url
                     parameters:(NSDictionary *)paras
                        success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                        failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// POST
- (void)requestPostMethodUrl:(NSString *)url
                   withParas:(NSDictionary *)paras
                     success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)requestPostMethodUrlWithStr:(NSString *)url
                   withParas:(NSDictionary *)paras
                     success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

// GET
- (void)requestGetMethodUrl:(NSString *)url
                  withParas:(NSDictionary *)paras
                    success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
