//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

#import "GesturePasswordController.h"

#import "KeychainItemWrapper/KeychainItemWrapper.h"

#import "LoginVC.h"


#import "SelectVC.h"

@interface GesturePasswordController ()<UIAlertViewDelegate>

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
    NSString * GestureStatus;
    NSInteger   times;
    NSString *gesId;
    NSString *passWordId;
}

@synthesize gesturePasswordView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.】
    self.view.frame=CGRectMake(0,0,mainWidth,mainHeight);
    self.view.backgroundColor=Color_Macro(242,242,242,1);
    [self.navigationController setNavigationBarHidden:NO];
    previousString = [NSString string];
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    gesId=[NSString stringWithFormat:@"gestureId%@",userId];
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//    password = [keychin  objectForKey:(__bridge id)kSecValueData];
    passWordId=[NSString stringWithFormat:@"passWordId%@",userId];
    password=[[NSUserDefaults standardUserDefaults]objectForKey:passWordId];
    
    NSString *timeId=[NSString stringWithFormat:@"times%@",userId];
    
    NSString *timeValue=[[NSUserDefaults standardUserDefaults]objectForKey:timeId];
    if ([timeValue integerValue]>0) {
        times=[timeValue integerValue];
    }
    else
    {
        [gesturePasswordView.state setText:@"手势密码失效，请用账号登录后重新设置手势密码"];
    
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",times] forKey:timeId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    GestureStatus=[[NSUserDefaults standardUserDefaults] valueForKey:@"GestureStatus"];
    if ([self.opType isEqualToString:@"reset"]) {
        
        [self reset];

    }
    else {
        [self verify];
         self.navigationItem.hidesBackButton =YES;

    }
}

-(void)backBarButton
{
    if ([self.title isEqualToString:@"关闭手势密码"]) {
        NSString *url=[NSString stringWithFormat:@"%@/#!account",BaseH5];
        GestureStatus=@"1";
        
        [[NSUserDefaults standardUserDefaults] setObject:GestureStatus forKey:gesId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self  setCookie];
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];

        
    }
     [self.navigationController popViewControllerAnimated:NO];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 验证手势密码
- (void)verify{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:CGRectMake(0,0, mainWidth, mainHeight)];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setStyle:1];
    [gesturePasswordView setGesturePasswordDelegate:self];
    [self.view addSubview:gesturePasswordView];
    
    
    
    
      if ([self.title isEqualToString:@"修改手势密码"]||[self.title isEqualToString:@"关闭手势密码"]) {
         
          [gesturePasswordView.changeButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
          if ([self.title isEqualToString:@"关闭手势密码"]) {
               [gesturePasswordView.state setText:@"绘制解锁图案"];
              
          }
          else
          {
                [gesturePasswordView.state setText:@"绘制原解锁图案"];
          }
          
          [gesturePasswordView.forgetButton setHidden:YES];
          self.navigationItem.hidesBackButton =NO;
          self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
          [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
      }
      else
      {
          NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
          NSString *userNameId=[NSString stringWithFormat:@"usernameId%@",userId];
          NSString *nameState=[NSString stringWithFormat:@"nameState%@",userId];
          NSString *ischange=[[NSUserDefaults standardUserDefaults]objectForKey:nameState];
          NSString *name=[[NSUserDefaults standardUserDefaults]objectForKey:userNameId];
          if (userId) {
              if ([ischange isEqualToString:@"1"]) {
                  
                  gesturePasswordView.userName.text=name;
              }
              else
              {
                  
                  NSString *firstLetter = [name substringWithRange:NSMakeRange(0, 1)];
                  NSString *lastLetter  = [name substringWithRange:NSMakeRange(name.length - 1,1)];
                  if (name.length == 2) {
                      name = [NSString stringWithFormat:@"%@*",firstLetter];
                  }else{
                      for (NSInteger i = 0; i < (name.length - 1); i++) {
                          firstLetter = [NSString stringWithFormat:@"%@*",firstLetter];
                      }
                      name = [NSString stringWithFormat:@"%@%@",firstLetter,lastLetter];
                  }
                  
                   gesturePasswordView.userName.text=name;
                  
                  
              }
              
              
              
          }
          else
          {
               gesturePasswordView.userName.text=@"获取用户信息失败";
              
          }

      
      }

}

#pragma -mark 重置手势密码
- (void)reset{
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:CGRectMake(0,0, mainWidth, mainHeight)];
    [gesturePasswordView.tentacleView setResetDelegate:self];
    [gesturePasswordView.tentacleView setRerificationDelegate:self];
    [gesturePasswordView.tentacleView setStyle:2];
    [gesturePasswordView.imgView setHidden:YES];
    [gesturePasswordView.forgetButton setHidden:YES];
    [gesturePasswordView.changeButton setHidden:YES];
    [self.view addSubview:gesturePasswordView];
    [gesturePasswordView.state setText:@"绘制解锁图案"];
    if ([self.title isEqualToString:@"修改手势密码"]) {
        [gesturePasswordView.changeButton setTitle:@"忘记手势密码" forState:UIControlStateNormal];
        [gesturePasswordView.state setText:@"绘制新解锁图案"];
        [gesturePasswordView.forgetButton setHidden:YES];

    }
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
}

#pragma -mark 清空记录
- (void)clear{
//    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:gesId accessGroup:nil];
//    [keychin resetKeychainItem];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:passWordId];
     [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:gesId];
    GestureStatus=@"0";
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *firstLoginId=[NSString stringWithFormat:@"firstLoginId%@",userId];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:firstLoginId];//设置引导状态
    [[NSUserDefaults standardUserDefaults] setObject:GestureStatus forKey:gesId];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];
    [self  setCookie];
}

#pragma -mark 忘记交易密码/重新设置手势密码
- (void)forget{
    
    if ([gesturePasswordView.changeButton.titleLabel.text isEqualToString:@"重新设置手势密码"]) {
        previousString=@"";
        [self reset];
        [self clear];
    }
    else
    {
       
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"忘记手势密码需要重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录",nil];
        alert.tag=333;
        [alert show];
    
    }


    
}

#pragma -mark 使用其他账号登录
- (void)change{
    
    

    [self.navigationController popViewControllerAnimated:NO];
     [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil userInfo:nil];
   
    
}


-(BOOL)verLeastBtn
{
  
    
    [gesturePasswordView.state setText:@"至少连接4个点，请重新绘制"];
    [gesturePasswordView.tentacleView enterError];

    return NO;
}

- (BOOL)verification:(NSString *)result{
    if ([result isEqualToString:password]) {
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:53/255.f green:53/255.f blue:53/255.f alpha:1]];
        [gesturePasswordView.state setText:@"输入正确"];
        if ([self.title isEqualToString:@"关闭手势密码"]) {
            GestureStatus=@"2";
            
            [[NSUserDefaults standardUserDefaults] setObject:GestureStatus forKey:gesId];
            [[NSUserDefaults standardUserDefaults] synchronize];   //设置开启状态
            
            [self  setCookie];
            


        }
        if ([self.title isEqualToString:@"修改手势密码"]) {
            
            
            [self reset];
            
            
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
  
        NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        NSString *timeId=[NSString stringWithFormat:@"times%@",userId];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:timeId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:nil];
        return YES;
    }
    if (times>0) {
        [gesturePasswordView.state setTextColor:[UIColor orangeColor]];
        [gesturePasswordView.state setText:[NSString stringWithFormat:@"手势密码错误,还可以输入%zd次",times]];
          times--;
            NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        NSString *timeId=[NSString stringWithFormat:@"times%@",userId];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",times] forKey:timeId];
        [[NSUserDefaults standardUserDefaults] synchronize];
         [gesturePasswordView.tentacleView enterError];
    }
    else
    {
        
        
        [self clear];
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"手势密码已失效" message:@"请重新登录" delegate:self cancelButtonTitle:nil  otherButtonTitles:@"重新登录",nil];
        alert.tag=111;
        [alert show];

    }
  
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:53/255.f green:53/255.f blue:53/255.f alpha:1]];
        if ([self.title isEqualToString:@"修改手势密码"]) {

            [gesturePasswordView.state setText:@"再次绘制新解锁图案"];
            [gesturePasswordView.changeButton setHidden:NO];
            [gesturePasswordView.changeButton setTitle:@"重新设置手势密码" forState:UIControlStateNormal];
            [gesturePasswordView setGesturePasswordDelegate:self];
        }
        else
        {
            [gesturePasswordView.state setText:@"再次绘制解锁图案"];
        }
 
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {
//            KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
//            [keychin setObject:gesId forKey:(__bridge id)kSecAttrAccount];
//            [keychin setObject:result forKey:(__bridge id)kSecValueData];
            //[self presentViewController:(UIViewController) animated:YES completion:nil];
//            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
//            [gesturePasswordView.state setText:@"已保存手势密码"];
      
            
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"手势密码设置成功,请牢记！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag=222;
                [alert show];
            
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:passWordId];
            
            
                 GestureStatus=@"1";
           
                [[NSUserDefaults standardUserDefaults] setObject:GestureStatus forKey:gesId];
                [[NSUserDefaults standardUserDefaults] synchronize];   //设置开启状态
            
                NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
                NSString *firstLoginId=[NSString stringWithFormat:@"firstLoginId%@",userId];
            
               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLoginId];//设置引导状态
                [self  setCookie];

            NSString *url=[NSString stringWithFormat:@"%@/#!account",BaseH5];
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
            return YES;
        }
        else{
            previousString =@"";
            [gesturePasswordView.state setTextColor:Color_Macro(252,120,1,1)];
            [gesturePasswordView.state setText:@"与上次绘制不一样，请重新绘制"];
             [gesturePasswordView.tentacleView enterError];
            return NO;
        }
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==111&&buttonIndex==0) {
       
        
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil userInfo:nil];
        
    }
    else if(alertView.tag==222)
    {
        
        NSString *url;
        if (_isHome) {
            
            url=[NSString stringWithFormat:@"%@/#!home",BaseH5];
        }
        else
        {
            url=[NSString stringWithFormat:@"%@/#!account",BaseH5];

        }
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
        

    }
    else if (alertView.tag==333)
    {
        if (buttonIndex==1) {
            [self clear];
            [self.navigationController popViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil userInfo:nil];
        }
       
        
        
        
    }

}




-(void)setCookie
{
    
    
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"gesturestatus" forKey:NSHTTPCookieName];
    [cookieProperties setObject:GestureStatus forKey:NSHTTPCookieValue];
    [cookieProperties setObject:baseIp forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:baseIp forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
     NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

}



@end
