 //
//  HttpHanlder.m
//  Jia16
//
//  Created by Ares on 16/8/3.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "HttpHanlder.h"

@implementation HttpHanlder

- (void)requestPostRsaMethodUrl:(NSString *)url
                     parameters:(NSDictionary *)paras
                        success:(void(^)(AFHTTPRequestOperation *operation, NSObject *resultObject))success
                        failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"ios/1.0" forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8"forHTTPHeaderField:@"Content-Type"];
    
    
    [manager GET:url parameters:nil success:success failure:failure];
}

- (void)requestPostMethodUrlWithStr:(NSString *)url
                          withParas:(NSString *)paras
                            success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                            failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{

    NSData *bodyData = [[paras stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = nil;
    request.timeoutInterval = 20.0f;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setHTTPBody:bodyData];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"ios/1.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [request setValue:token forHTTPHeaderField:@"Authorization"];
    
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id resultObject) {
                                                                          
                                                                      }
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          
                                                                          failure(operation, error);
                                                                      }];
    
    [self.operationQueue addOperation:operation];

}

- (void)requestPostMethodUrl1:(NSString *)url
                   withParas:(NSString *)paras
                     success:(void(^)(AFHTTPRequestOperation *operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    //    NSData *bodyData = [[paras stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = nil;
    request.timeoutInterval = 20.0f;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kCookie]];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:[NSURL URLWithString:url] mainDocumentURL:nil];

    for (int i=0; i<cookies.count;i++) {
        
        NSHTTPCookie *cookie=cookies[i];
        
        
        
        if ([cookie.domain isEqualToString:baseIp]&&[cookie.name isEqualToString:@"_csrf"]) {
            
            [request addValue:cookie.value forHTTPHeaderField:@"CSRF-TOKEN"];
        }
        


    }
//
   
    [request setHTTPBody: [paras dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"ios/1.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

  
    
    
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id resultObject) {
                                                                          
                                                                          success(operation,resultObject);                                                                     }
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          
                                                                          failure(operation, error);
                                                                      }];
    
    [self.operationQueue addOperation:operation];
}

- (void)requestPostMethodUrl:(NSString *)url
                   withParas:(NSString *)paras
                     success:(void(^)(AFHTTPRequestOperation *operation, NSObject *resultObject))success
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = nil;
    request.timeoutInterval = 20.0f;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];

    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kCookie]];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:[NSURL URLWithString:url] mainDocumentURL:nil];
    for (int i=0; i<cookies.count;i++) {
        
        NSHTTPCookie *cookie=cookies[i];
        
        
        
        if ([cookie.domain isEqualToString:baseIp]&&[cookie.name isEqualToString:@"_csrf"]) {
            
            [request addValue:cookie.value forHTTPHeaderField:@"CSRF-TOKEN"];
        }
        
        }
//

    
    [request setHTTPBody: [paras dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"ios/1.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id resultObject) {
                                                                          
                                                                          success(operation,resultObject);                                                                     }
                                                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          
                                                                          failure(operation, error);
                                                                      }];
    
    [self.operationQueue addOperation:operation];
}

- (void)requestGetMethodUrl:(NSString *)url
                  withParas:(NSString *)paras
                    success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                    failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableURLRequest *request = nil;
    
    //    NSLog(@"***%@",url);
    
    NSArray *array = [url componentsSeparatedByString:@"?"];
    NSString *url_new = array[0];
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url_new]];
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kCookie]];

    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:[NSURL URLWithString:url_new] mainDocumentURL:nil];
    for (int i=0; i<cookies.count;i++) {
        
        NSHTTPCookie *cookie=cookies[i];
        
        
        
        if ([cookie.domain isEqualToString:baseIp]&&[cookie.name isEqualToString:@"_csrf"]) {
            
            [request addValue:cookie.value forHTTPHeaderField:@"CSRF-TOKEN"];
        }
    }

    

    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                      success:success
                                                                      failure:failure];
    
    [self.operationQueue addOperation:operation];
}



@end
