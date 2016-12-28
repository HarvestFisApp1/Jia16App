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

#import "UIImage+GIF.h"
#import "AppDelegate.h"
#import "ShareView.h"
#import <UShareUI/UShareUI.h>
@interface SelectVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate,NSURLConnectionDelegate>
{


    NSURL *refUrl;
    NSString  *currentUrl;
    NSHTTPCookie  *csrfCookie;
    NSHTTPCookie  *p2pCookie;
    UITapGestureRecognizer *tap;
    NSNotification *memNoti;
    
    BOOL isOnline;
    
    BOOL isLoading;
    
    
    
    NSString *linkUrl;
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
    
    @autoreleasepool {
        dispatch_once(&onceToken, ^{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage *image = [UIImage sd_animatedGIFWithData:data];
//            UIImage *animatedImage = [UIImage animatedImageWithImages:image.images duration:3];
            
            
            _frontView=[[UIImageView alloc] initWithFrame:self.view.bounds];
            _frontView.animationImages=image.images;//将图片数组加入UIImageView动画数组中
            data=nil;
            image=nil;
            
            _frontView.backgroundColor=[UIColor whiteColor];
            _frontView.animationDuration=3;//每次动画时长
            [_frontView startAnimating];//开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
            
            
        });

    }
  
    
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
//    else
//    {
//     
//        [CookieHandler deleteCookie];
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject: nil forKey:kCookie];
//    }

    [self requestCurrent];
    
    
    
    [self reloadUrl:memNoti];
    

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if([currentUrl hasSuffix:@"LoginVC"])//登录
    {
        NSArray *array = [currentUrl componentsSeparatedByString:@"?"];
        refUrl=[NSURL URLWithString:array[0]];
       [self.webView loadRequest:[NSURLRequest requestWithURL:refUrl]];
    }

    

 [self.navigationController setNavigationBarHidden:YES];
 

}



-(void)viewWillDisappear:(BOOL)animated
{
    [_frontView removeFromSuperview];
    _frontView=nil;
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
 
    requestStr = [requestStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
        [_frontView stopAnimating];
        [_frontView removeFromSuperview];
        _frontView=nil;
     
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
    
    
    
    if([requestStr rangeOfString:@"?shareNative"].location!=NSNotFound)//分享
    {
        //设置用户自定义的平台
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),
                                                   
                                                   @(UMSocialPlatformType_QQ),
                                                   ]];
        
        NSString *str=requestStr;
        NSArray *array = [str componentsSeparatedByString:@"?"];
        NSString *paramStr=array[1];
        NSArray *paramArry=[paramStr componentsSeparatedByString:@"&"];
        NSString *title=[paramArry[1] componentsSeparatedByString:@"="][1];
        title=[title stringByReplacingOccurrencesOfString:@"'" withString:@""];
        NSString *imageUrl=[paramArry[2] componentsSeparatedByString:@"="][1];
        imageUrl=[NSString stringWithFormat:@"%@/%@",BaseH5,imageUrl];
       __block  NSData *data;
       __block UIImage *image;
        dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);

        dispatch_async(concurrentQueue, ^(){
        
            data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            image=[UIImage imageWithData:data];
        });

        
        
        NSString *text=[paramArry[3] componentsSeparatedByString:@"="][1];

        NSString *url=[paramArry[4] componentsSeparatedByString:@"="][1];
        url=[NSString stringWithFormat:@"%@%@",BaseH5,url];
        [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
                                         withPlatformIcon:[UIImage imageNamed:@"umsocial_default"]
                                         withPlatformName:@"复制链接"];
        
        [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
        [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            //在回调里面获得点击的
            if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
              
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = url;
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"已复制链接" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                
                
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                //创建网页内容对象
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:image];
                //设置网页地址
                shareObject.webpageUrl =url;
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                
                [self shareWebPageToPlatformType:platformType msgObj:messageObject];
            }
            
        }];
        
   
        
        
        
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
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    linkUrl=appDelegate.linkUrl;

    if(linkUrl.length>0)
    {
    
        urlStr=linkUrl;
    }
 
    
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
                    _frontView=nil;
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
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];

     [self setCookie];

     [self listenNet];
}

-(BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace {
    return[protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
       
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
-(void)setCookie
{
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"app_channel" forKey:NSHTTPCookieName];
    [cookieProperties2 setObject:@"ios" forKey:NSHTTPCookieValue];
    [cookieProperties2 setObject:baseIp forKey:NSHTTPCookieDomain];
    [cookieProperties2 setObject:baseIp forKey:NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];

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
            

            NSMutableDictionary *cookieProperties1 = [NSMutableDictionary dictionary];
            [cookieProperties1 setObject:@"versionNo" forKey:NSHTTPCookieName];
            [cookieProperties1 setObject:versionNo forKey:NSHTTPCookieValue];
            [cookieProperties1 setObject:baseIp forKey:NSHTTPCookieDomain];
            [cookieProperties1 setObject:baseIp forKey:NSHTTPCookieOriginURL];
            [cookieProperties1 setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties1 setObject:@"0" forKey:NSHTTPCookieVersion];
            
            NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
            

            
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

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType msgObj:(UMSocialMessageObject*)MsgObj
{
 
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:MsgObj currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

@end
