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
@interface AppDelegate ()
{

    NSString *versionUrl;
}
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@property (nonatomic,strong)SelectVC    *selVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  

    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        self.introductionView = [[ZWIntroductionViewController alloc] init];
        self.window.rootViewController = self.introductionView;
        
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            weakSelf.window.rootViewController = storyboard.instantiateInitialViewController;
            [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

            
        };

    }
    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
   
    [self checkVersion];
    
    return YES;
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
    NSArray *array = [str componentsSeparatedByString:@"jia16://"];
    NSString *paramStr=array[1];
    
    NSString *linkUrl=[NSString stringWithFormat:@"%@%@",BaseH5,paramStr];
    self.linkUrl=linkUrl;
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:linkUrl,@"url",@"1",@"isAwake",nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"closeLogin" object:nil userInfo:nil];
    return YES;

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
