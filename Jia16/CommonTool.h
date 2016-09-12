//
//  CommonTool.h
//  Jia16
//
//  Created by Ares on 16/8/2.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonTool : NSObject
+(BOOL)isValidateAccount:(NSString *)account;
+(NSString *)changeFloat:(NSString *)stringFloat;  //移除小数点后多余的0
//只有提示消息的alert
+(void)showAlertWithMsg:(NSString *)msg;

+(NSAttributedString*)changeAttributeString:(NSDictionary *)strDic1 Str2Dic:(NSDictionary*)strDic2;//两个字符串合成NSAttributedString
@end
