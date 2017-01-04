//
//  AppDelegate.m
//  Jia16
//
//  Created by Ares on 16/7/29.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "AppDelegate.h"

#import "GesturePasswordController.h"

#import "ZWIntroductionViewController.h"

#import "SelectVC.h"

#import "HttpAPI.h"

#import "CXAlertView.h"

#import "UMMobClick/MobClick.h"

#import <UMSocialCore/UMSocialCore.h>
@interface AppDelegate ()
{

    NSString *versionUrl;
}
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@property (nonatomic,strong)SelectVC    *selVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"583cf3484ad15622cf001f67"];
    

    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7208eaaf0f57f34d" appSecret:@"08034277e141e640cadbc6e26842f96a" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105662722"  appSecret:@"CeFHk1L2OFiYxsE5" redirectURL:@"http://mobile.umeng.com/social"];
  
    UMConfigInstance.appKey = @"583cf3484ad15622cf001f67";
    UMConfigInstance.channelId = @"IOS";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    

    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                        error:nil];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        UIDevice *device = [UIDevice currentDevice];
        [self umengEvent:@"uploadDevice" attributes:@{@"udid":device.identifierForVendor.UUIDString,@"version" :  device.systemVersion,@"device":device.model} number:@(10)];
        
        
        
        NSLog(@"苹果设备唯一标识UUID: %@", device.identifierForVendor);
        
        NSLog(@"系统版本: %@", device.systemVersion);
        
        NSLog(@"设备型号: %@", device.model);

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        self.introductionView = [[ZWIntroductionViewController alloc] init];
        self.window.rootViewController = self.introductionView;
        
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            weakSelf.window.rootViewController = storyboard.instantiateInitialViewController;
            [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

            
        };
        
        self.introductionView.didRegister=^(){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            weakSelf.window.rootViewController = storyboard.instantiateInitialViewController;
            [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *url=[NSString stringWithFormat:@"%@/#!register",BaseH5];
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
            });
   
        };
        
        

    }
    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
   
    [self checkVersion];
    
    return YES;
}


-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}


-(void)checkVersion
{

        
    [[HttpAPI SharedCommonApi]requestPostMethodUrl:HTTP_Update withParas:nil   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
            
        
                NSDictionary *resultDic = (NSDictionary *)resultObject;

                    NSString *currentBuild=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    NSString *versionId =resultDic[@"versionId"];
                    int b=versionId.intValue;
                    
                    if (b>currentBuild.intValue) {
                        versionUrl = resultDic[@"url"];
                        NSString *ifUpdate = resultDic[@"ifUpdate"];
                        if (![ifUpdate isEqualToString:@"yes"]) {
                            CXAlertView *alert=[[CXAlertView alloc]initWithTitle:@"升级提示" message:resultDic[@"descr"] cancelButtonTitle:nil];
                            alert.viewBackgroundColor=[UIColor whiteColor];
                            // This is a demo for changing content at realtime.
                            [alert addButtonWithTitle:@"忽略"
                                                 type:CXAlertViewButtonTypeCancel
                                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                  [alertView dismiss];
                                                  
                                                  
                                              }];
                            [alert addButtonWithTitle:@"立即更新"
                                                 type:CXAlertViewButtonTypeDefault
                                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                  // Dismiss alertview
                                                  [alertView dismiss];
                                                  [self openUrl:versionUrl];
                                
                                              }];
                            
                            
                            [alert show];
                        }else{
                            CXAlertView *alert=[[CXAlertView alloc]initWithTitle:@"升级提示" message:resultDic[@"descr"] cancelButtonTitle:nil];
                            alert.viewBackgroundColor=[UIColor whiteColor];
                            // This is a demo for changing content at realtime.
                            [alert addButtonWithTitle:@"立即更新"
                                                 type:CXAlertViewButtonTypeCancel
                                              handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
                                                  //                                          [alertView dismiss];  //强制更新不消失
                                                  [self openUrl:versionUrl];
                                      
                                              }];
                            [alert show];
                            
                        }
                    }
        
        
    }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   
                                                   
                                                   
                                                   
                                                   
                                               }];
        
        

    
}

- (void)openUrl:(NSString *)urlStr
{
    NSURL *URL = [NSURL URLWithString:urlStr];
    UIApplication *application = [UIApplication sharedApplication];
    if (![application canOpenURL:URL]) {
        return;
    }
    [[UIApplication sharedApplication]openURL:URL];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {


}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
    NSString *str=url.absoluteString;
    if ([str rangeOfString:@"jia16://"].location!=NSNotFound) {
        NSArray *array = [str componentsSeparatedByString:@"jia16://"];
        NSString *paramStr=array[1];
        
        NSString *linkUrl=[NSString stringWithFormat:@"%@%@",BaseH5,paramStr];
        self.linkUrl=linkUrl;
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:linkUrl,@"url",@"1",@"isAwake",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"closeLogin" object:nil userInfo:nil];
    }

    
    
    return YES;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
