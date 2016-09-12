//
//  HttpAPI.m
//  Jia16
//
//  Created by Ares on 16/8/3.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "HttpAPI.h"
#import "NSObject+SBJSON.h"
@interface HttpAPI()
{
    HttpHanlder *http_common;
}
@end

@implementation HttpAPI


+ (instancetype)SharedCommonApi {
    static HttpAPI *dm = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dm = [[HttpAPI alloc] init];
    });
    return dm;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        http_common = [[HttpHanlder alloc] init];
    }
    return self;
}

- (void)requestPostRsaMethodUrl:(NSString *)url
                     parameters:(NSDictionary *)paras
                        success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                        failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    [http_common requestPostRsaMethodUrl:url
                              parameters:paras
                                 success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                                 failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure];
}

- (void)requestPostMethodUrl:(NSString *)url
                   withParas:(NSDictionary *)paras
                     success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [http_common requestPostMethodUrl:url
                            withParas:[self dictionaryToString:paras]
                              success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                              failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure];
    
}

- (void)requestPostMethodUrlWithStr:(NSString *)url
                   withParas:(NSDictionary *)paras
                     success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [http_common requestPostMethodUrlWithStr:url
                            withParas:[self dictionaryToString:paras]
                              success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                              failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure];
    
}

- (void)requestGetMethodUrl:(NSString *)url
                  withParas:(NSDictionary *)paras
                    success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [http_common requestGetMethodUrl:url
                           withParas:[self dictionaryToString:paras]
                             success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                             failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure];
}


// 字典转成json字符串
- (NSString *)dictionaryToString:(NSDictionary *)dic {
//    NSError *error;
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];

//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStr=[dic JSONRepresentation];

    


    return jsonStr;
}

//// json字符串AES加密
//- (NSString *)stringAES:(NSString *)str {
//    NSString *strAES = [SecurityUtil encryptAESData:str app_key:KEY];
//    //    NSLog(@"参数加密后为:%@",strAES);
//    
//    return strAES;
//}

@end
