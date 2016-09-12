//
//  CommonTool.m
//  Jia16
//
//  Created by Ares on 16/8/2.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool

//用户名格式验证
+(BOOL)isValidateAccount:(NSString *)account
{
    NSString *accountRegex = @"^[a-zA-Z0-9_][a-zA-Z0-9_]{5,17}$";
    NSPredicate *accountTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", accountRegex];
    return [accountTest evaluateWithObject:account];
}

+(NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}


+(NSAttributedString*)changeAttributeString:(NSDictionary *)strDic1 Str2Dic:(NSDictionary*)strDic2
{
    // 两个字符串转化成NSAttributedString
    NSString  *str1 = strDic1[@"str"];
    NSString  *str2 = strDic2[@"str"];
    NSString *mixString0 = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *attStr0 = [[NSMutableAttributedString alloc]initWithString:mixString0];
    UIFont *f1 = [UIFont systemFontOfSize:[strDic1[@"font"] floatValue]];
    UIFont *f2 = [UIFont systemFontOfSize:[strDic2[@"font"] floatValue]];
    [attStr0 addAttribute:NSFontAttributeName value:f1 range:[mixString0 rangeOfString:str1]];
    [attStr0 addAttribute:NSForegroundColorAttributeName value:strDic1[@"color"] range:[mixString0 rangeOfString:str1]];
    [attStr0 addAttribute:NSFontAttributeName value:f2 range:[mixString0 rangeOfString:str2]];
    [attStr0 addAttribute:NSForegroundColorAttributeName  value:strDic2[@"color"] range:[mixString0 rangeOfString:str2]];
    
    
    return attStr0;
    
}



//只有提示消息的alert
+(void)showAlertWithMsg:(NSString *)msg
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    });
    
}
@end
