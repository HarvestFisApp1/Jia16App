//
//  FirstViewController.m
//  Jia16
//
//  Created by Ares on 16/7/29.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "SelectVC.h"

#import "GesturePasswordController.h"

#import "HttpAPI.h"

#import "LoginVC.h"

#import "CommonTool.h"

#import "InvestConfirmVC.h"

#import "KeychainItemWrapper.h"

#import "CookieHandler.h"

#import <ImageIO/ImageIO.h>
@interface SelectVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{


    NSURL *refUrl;
    NSString  *currentUrl;
    NSHTTPCookie  *csrfCookie;
    NSHTTPCookie  *p2pCookie;
    UITapGestureRecognizer *tap;
    
    BOOL isOnline;
    
    BOOL isLoading;
}

@property (nonatomic,strong)   UIImageView  *frontView;

@end

@implementation SelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    isOnline=YES;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"loading" withExtension:@"gif"];//加载GIF图片
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
        size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
        NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
        for (size_t i=0; i<frameCout;i++)
        {
            
            CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
            UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
            [frames addObject:imageName];//将图片加入数组中
            CGImageRelease(imageRef);
        }
        
        
        _frontView=[[UIImageView alloc] initWithFrame:self.view.bounds];
        _frontView.animationImages=frames;//将图片数组加入UIImageView动画数组中
        _frontView.backgroundColor=[UIColor whiteColor];
        _frontView.animationDuration=3;//每次动画时长
        [_frontView startAnimating];//开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
        
        
    });

    
    NSString *gestureID=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *gesId=[NSString stringWithFormat:@"gestureId%@",gestureID];
    
    NSString *gestureValue=[[NSUserDefaults standardUserDefaults]objectForKey:gesId];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadUrl:) name:@"reloadUrl" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openGesture:) name:@"openGesture" object:nil];
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login) name:@"login" object:nil];
    if([gestureValue isEqualToString:@"1"])
    {
        
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"verify",@"opType",@"手势密码登录",@"title", nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"openGesture" object:nil userInfo:dict];
        
    }
    else
    {
     
        [CookieHandler deleteCookie];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: nil forKey:kCookie];
    }

    [self requestCurrent];
    [self reloadUrl:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
 [self.navigationController setNavigationBarHidden:YES];
 

}



-(void)viewWillDisappear:(BOOL)animated
{
    [_frontView removeFromSuperview];
    isLoading=NO;

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{



}



-(void)webViewDidFinishLoad:(UIWebView *)webView
{

//   NSString  *js=[self.webView stringByEvaluatingJavaScriptFromString:@"document.cookie"];
//    
//    NSLog(@"%@",js);
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    
    return nil;
    
}




-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *requestStr=request.URL.absoluteString ;
    currentUrl=requestStr;
 
    
    
  if([requestStr hasSuffix:@"GesturePasswordSetup"])//设置手势
  {
       
       NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"reset",@"opType",@"设置手势密码",@"title", nil];
      
      [[NSNotificationCenter defaultCenter]postNotificationName:@"openGesture" object:nil userInfo:dict];
  
      return NO;
  }

    if([requestStr hasSuffix:@"GesturePasswordUpdate"])//修改手势
    {
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"verify",@"opType",@"修改手势密码",@"title", nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"openGesture" object:nil userInfo:dict];

        
        return NO;
    }
    
    
    
    if([requestStr rangeOfString:@"LogoutVC"].location!=NSNotFound)//退出登录
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];

    }
    
    
    if ([requestStr hasSuffix:@"LoadSuccess"]&&isLoading) {
      
        [_frontView removeFromSuperview];
        isLoading=NO;
    }
    
    
    
    
    if([requestStr rangeOfString:@"AutoLogin"].location!=NSNotFound)//H5自动登录
    {
        
        NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: cookiesData forKey:kCookie];
        [self requestCurrent];
        return NO;
        
    }
    
    if([requestStr  rangeOfString:@"SwitchClick"].location!=NSNotFound)//开关手势
    {
        
        NSString *str=requestStr;
        NSArray *array = [str componentsSeparatedByString:@"?"];
        NSString *paramStr=array[1];
        NSArray *paramArry=[paramStr componentsSeparatedByString:@"&"];
        NSString *switchStaus=[paramArry[1] componentsSeparatedByString:@"="][1];
        
        NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: cookiesData forKey:kCookie];
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kCookie]];
        NSString *gesture;
            if ([switchStaus isEqualToString:@"off"]) {
                gesture=@"2";
            }
            else
            {
                gesture=@"1";
            
            }
          for (int i=0; i<cookies.count;i++) {
            
            NSHTTPCookie *cookie=cookies[i];
            if ([cookie.name isEqualToString:@"gesturestatus"]) {
                NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                [cookieProperties setObject:@"gesturestatus" forKey:NSHTTPCookieName];
                [cookieProperties setObject:gesture forKey:NSHTTPCookieValue];
                [cookieProperties setObject:baseIp forKey:NSHTTPCookieDomain];
                [cookieProperties setObject:baseIp forKey:NSHTTPCookieOriginURL];
                [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                
                NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

            }
            
            
        }
        
        NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        NSString *gesId=[NSString stringWithFormat:@"gestureId%@",userId];
        
        [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:gesId];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

        if ([switchStaus isEqualToString:@"off"]) {
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"verify",@"opType",@"关闭手势密码",@"title", nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"openGesture" object:nil userInfo:dict];
        }
        
        NSLog(@"%@",cookies);
        return NO;
        
    }
    

    if([requestStr rangeOfString:@"?InvestConfirmVC"].location!=NSNotFound)//投资确认
    {
        NSString *str=requestStr;
        NSArray *array = [str componentsSeparatedByString:@"?"];
        NSString *paramStr=array[1];
        NSArray *paramArry=[paramStr componentsSeparatedByString:@"&"];
        InvestConfirmVC *confirmVC=[[InvestConfirmVC alloc]init];
        confirmVC.linkUrl=array[0];
        confirmVC.userId=[paramArry[1] componentsSeparatedByString:@"="][1];
        confirmVC.subjectid=[paramArry[2] componentsSeparatedByString:@"="][1];
        confirmVC.titleName=[paramArry[3] componentsSeparatedByString:@"="][1];
        NSString *ids=[paramArry[4] componentsSeparatedByString:@"="][1];
        confirmVC.vouchers=[ids componentsSeparatedByString:@","];
        confirmVC.amount=[[paramArry[5] componentsSeparatedByString:@"="][1] doubleValue];
        NSString *confirmStr=[paramArry[6] componentsSeparatedByString:@"="][1];
        
        if ([confirmStr isEqualToString:@"y"]) {
            confirmVC.canVoucher=YES;
        }
        else
        {
            confirmVC.canVoucher=NO;
        
        }
        confirmVC.voucherAmount=[[paramArry[7] componentsSeparatedByString:@"="][1] integerValue];
        NSString *pdfUrl=[paramArry[8] componentsSeparatedByString:@"="][1];
        confirmVC.pdfUrl=[NSString stringWithFormat:@"https://test2.jia16.com/%@",pdfUrl];
        [self.navigationController pushViewController:confirmVC animated:YES];
        
        
        return NO;
        
    }

    
   if([requestStr hasSuffix:@"LoginVC"])//登录
    {
        NSArray *array = [requestStr componentsSeparatedByString:@"?"];
        refUrl=[NSURL URLWithString:array[0]];
        LoginVC *loginVC=[[LoginVC alloc]init];
        loginVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        
        return NO;
    }
    
    
    if([requestStr hasSuffix:@"PDFurl"])//PDF合同协议
    {
        NSArray *array = [requestStr componentsSeparatedByString:@"?"];
        NSString *urlStr=[NSString stringWithFormat:@"%@?%@",array[0],array[1]];
        NSURL *url=[NSURL URLWithString:urlStr];
        
        
        [[UIApplication sharedApplication] openURL:url];
        
        return NO;
    }


    return YES;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (isOnline&&![currentUrl hasSuffix:@"reload.html"]) {
        return NO;
    }
    return YES;
    
}








-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    
    
    
    
}

-(void)login
{
//    NSDictionary *dic=@{@"name":@"",@"password":@""};
//    NSData *data =    [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:data forKey:@"userKey"];
//    [defaults synchronize];
    LoginVC *login=[[LoginVC alloc]init];
    login.turnType=@"resetGesture";
    [self.navigationController pushViewController:login animated:NO];
    
}

-(void)openGesture:(NSNotification*)noti
{
    NSString *opType=noti.userInfo[@"opType"];
    NSString *title=noti.userInfo[@"title"];
    NSString *ishome=noti.userInfo[@"ishome"];

    GesturePasswordController *gestureVC=[[GesturePasswordController alloc]init];
    gestureVC.opType=opType;
    if ([ishome isEqualToString:@"1"]) {
        gestureVC.isHome=YES;
    }
    gestureVC.title=title;
    [self.navigationController pushViewController:gestureVC animated:YES];

}

-(void)reloadUrl:(NSNotification*)noti
{
    
    NSString *urlStr=noti.userInfo[@"url"];
    
    if (urlStr.length>0) {
        refUrl=[NSURL URLWithString:urlStr];
    }
    
    NSURL *url;
    if (!refUrl) {
        url=[NSURL URLWithString:BaseH5];
        
            if(!isLoading)
            {
                [self.view addSubview:_frontView];
                
                isLoading=YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [_frontView removeFromSuperview];
                    isLoading=NO;
                });
            }
        
    }
    else
    {
        url=refUrl;
        if([url.absoluteString hasSuffix:@"home"]&&!isLoading)
        {
            if(!isLoading)
            {
                [self.view addSubview:_frontView];
                
                isLoading=YES;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [_frontView removeFromSuperview];
                    isLoading=NO;
                });
            }
            
        }
    }
    

    
//    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//     NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kCookie]];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookies:cookies forURL:url mainDocumentURL:nil];
  
    NSDictionary*dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios/1.0", @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
  
   [self.webView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15]];
     [self setCookie];

     [self listenNet];
}


-(void)setCookie
{
    

    NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey:kCookie];
    [defaults synchronize];
    [self requestCurrent];

}



-(void)requestCurrent
{
    
    [[HttpAPI SharedCommonApi]requestGetMethodUrl:HTTP_Current withParas:nil   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
        
        
        if (operation.response.statusCode==200) {
            
            NSDictionary *dic=(NSDictionary*)resultObject;
            
            NSString *userId=[NSString stringWithFormat:@"%@",dic[@"id"]];
            
       
            
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
            
            NSString *username;
            NSString  *isChangeUserName=[NSString stringWithFormat:@"%@",dic[@"isChangeUserName"]];
            if ([isChangeUserName isEqualToString:@"0"]) {
                username=[NSString stringWithFormat:@"%@",dic[@"username"]];
            }
            else
            {
                username=[NSString stringWithFormat:@"%@",dic[@"phone"]];
            }
            
            NSString *nameId=[NSString stringWithFormat:@"usernameId%@",userId];
            NSString *nameState=[NSString stringWithFormat:@"nameState%@",userId];
            NSString *gesId=[NSString stringWithFormat:@"gestureId%@",userId];
             NSString *gestureValue=[[NSUserDefaults standardUserDefaults]objectForKey:gesId];
            
             [[NSUserDefaults standardUserDefaults] setObject:username forKey:nameId];
            [[NSUserDefaults standardUserDefaults] setObject:isChangeUserName forKey:nameState];
                   NSString   *GestureStatus;
            if (gestureValue) {
                GestureStatus=gestureValue;
            }
            else
            {
               GestureStatus=@"0";
            
            }
            [[NSUserDefaults standardUserDefaults] setObject:GestureStatus forKey:gesId];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        
    
            
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
            [cookieProperties setObject:@"gesturestatus" forKey:NSHTTPCookieName];
            [cookieProperties setObject:GestureStatus forKey:NSHTTPCookieValue];
            [cookieProperties setObject:baseIp forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:baseIp forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            

            
            NSArray *cookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (int i=0; i<cookies.count;i++) {
                 NSHTTPCookie *cookie=cookies[i];
    
                if ([cookie.domain isEqualToString:baseIp]&&[cookie.name isEqualToString:@"p2psessionid"]) {
                    
                    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                    [cookieProperties setObject:@"usersessionid" forKey:NSHTTPCookieName];
                    [cookieProperties setObject:cookie.value forKey:NSHTTPCookieValue];
                    [cookieProperties setObject:baseIp forKey:NSHTTPCookieDomain];
                    [cookieProperties setObject:baseIp forKey:NSHTTPCookieOriginURL];
                    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                    
                    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                    
                }
            }

            
        }
        
        NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject: cookiesData forKey:kCookie];
        
    }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                              
                                              
                                              
                                              
                                          }];
    
    
}

-(void)autoLogin
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

    NSData *data=[defaults objectForKey:@"userKey"];

    if(data.length>0)
    {
        NSDictionary *userkeyDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        [[HttpAPI SharedCommonApi]requestPostMethodUrl:HTTP_LOGIN withParas:userkeyDic   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
            
            
            if (operation.response.statusCode==200) {
                NSLog(@"登录成功.......");
                NSData * cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject: cookiesData forKey:kCookie];
                
                [self reloadUrl:nil];
//                [self.navigationController popViewControllerAnimated:NO];
             
            }
     
            
            
        }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   
                                                   
                                                   
                                                   
                                                   
                                               }];
        
        
        

    
    }
   
}


#pragma mark 获取网络状态
-(void)listenNet
{
    
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                tap.delegate= self;
                
                tap.cancelsTouchesInView = NO;
                [self.webView addGestureRecognizer:tap];
                self.webView.userInteractionEnabled=YES;
                
                NSString *privateDocsPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Private Documents"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:privateDocsPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:privateDocsPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                
                NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                
                
                NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"reload" ofType:@"html" inDirectory:@"reload"];
                
                NSURL *url=[NSURL URLWithString:fullPath];
                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                [_webView loadRequest:request];
 
                isOnline=NO;
            
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
            {
              
                isOnline=YES;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
              
                isOnline=YES;
            }
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    
    
}

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:nil];
    
    
}
@end
