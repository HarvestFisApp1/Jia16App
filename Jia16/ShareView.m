//
//  ShareView.m
//  Jia16
//
//  Created by Ares on 16/12/21.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "ShareView.h"
#import <UShareUI/UShareUI.h>
@interface ShareView ()

@end

@implementation ShareView

-(instancetype)init
{
    self=[super init];
    if (self) {
        
        self.backgroundColor=[UIColor blackColor];
        self.frame=CGRectMake(0,0,mainWidth,mainHeight);
        self.alpha=0.9;
        
        UIButton  *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame=CGRectMake(0,0,100,100);
        btn.center=self.center;
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }

    return  self;
}


//点击分享按钮
- (void)share {
    __weak typeof(self) weakSelf = self;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType,NSDictionary* userInfo){
    
        
    
    
    }];
    
//    //设置用户自定义的平台
//    
//    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
//     
//                                     withPlatformIcon:[UIImage imageNamed:@"zhongjianggonggao_xyzj"]
//     
//                                     withPlatformName:@"复制链接"];

}
@end
