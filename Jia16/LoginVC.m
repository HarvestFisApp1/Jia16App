 //
//  LoginVC.m
//  Jia16
//
//  Created by Ares on 16/7/29.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "LoginVC.h"
#import "CommonTool.h"
#import "HttpAPI.h"
#import "UserModel.h"
#import "CookieHandler.h"
#import "POPVIew.h"
#import "GesturePasswordController.h"
#import "KeychainItemWrapper.h"
#import "UMMobClick/MobClick.h"
#import <UShareUI/UShareUI.h>
@interface LoginVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,popViewDelegate>
{
    UITextField *textFieldName;
    UITextField *textFieldPwd;
    UIButton *LoginBtn;
    POPVIew *popView;
}
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    [self.view addSubview:self.tableView];
    [self initNav];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(close) name:@"closeLogin" object:nil];
    
   
}

-(void)initNav
{
       UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 14)];
    [btn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn.titleLabel setFont:Font_Size(14)];
    [btn setTitleColor:Color_Macro(255,111, 0, 1) forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem=rightButton;
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([self.turnType isEqualToString:@"resetGesture"]) {
        self.navigationItem.hidesBackButton=YES;
    }
    else
    {
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];

    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)backBarButton
{
    NSString *url=[NSString stringWithFormat:@"%@/#!home",BaseH5];

    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self.navigationController popViewControllerAnimated:NO];
        });
  

}


-(void)registerClick
{
        NSString *url=[NSString stringWithFormat:@"%@/#!register",BaseH5];
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
    
    

}



-(void)findPWdClick
{
    NSString *url=[NSString stringWithFormat:@"%@/#!findloginpwd",BaseH5];

        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
        
           [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
  
}



-(void)close
{

      [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark tableView Delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||indexPath.row==2) {
        return 17;
    }
    else if (indexPath.row==1||indexPath.row==3)
    {
        return 50;
    }
   
      return mainHeight-17*2-50*2;

    

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(15,12,21,28)];

    [cell addSubview:imgView];
    


    
  
    if (indexPath.row==0||indexPath.row==2) {
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    else  if (indexPath.row==1) {
        textFieldName=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10,0, 300, 50)];
        textFieldName.font=Font_Size(15);
        [cell addSubview:textFieldName];
          textFieldName.placeholder=@"请输入您的手机号或用户名";
            imgView.image=[UIImage imageNamed:@"login_phone"];
    }
    else if(indexPath.row==3)
    {
        
        textFieldPwd=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+10,0, 300, 50)];
        textFieldPwd.font=Font_Size(15);
        textFieldPwd.delegate=self;
        [cell addSubview:textFieldPwd];
        textFieldPwd.secureTextEntry = YES;
        textFieldPwd.placeholder=@"请输入您的登录密码";
            imgView.image=[UIImage imageNamed:@"login_pwd"];
        UISwitch  *open=[[UISwitch alloc]initWithFrame:CGRectMake(mainWidth-65,12,55,30)];
        [open setOn:NO];

        //开关控件切换槽 颜色
        open.onTintColor=Color_Macro(250,120,0, 1);
        open.onImage=[UIImage imageNamed:@"开"];
        open.offImage=[UIImage imageNamed:@"关"];
        [open addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:open];
        
    
    }
    else if (indexPath.row==4)
    {
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        UIButton *btnFindPwd=[UIButton buttonWithType:UIButtonTypeCustom];
        btnFindPwd.frame=CGRectMake(12, 10,91,18);
        [btnFindPwd setTitle:@"忘记登录密码?" forState:UIControlStateNormal];
        [btnFindPwd.titleLabel setFont:Font_Size(13)];
        [btnFindPwd setTitleColor:Color_Macro(37,118,184, 1) forState:UIControlStateNormal];
        [btnFindPwd addTarget:self action:@selector(findPWdClick) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnFindPwd];
        
        LoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        LoginBtn.frame=CGRectMake(10,CGRectGetMaxY(btnFindPwd.frame)+20,mainWidth-20,44);
        LoginBtn.layer.cornerRadius=3;
        LoginBtn.layer.masksToBounds=YES;
        LoginBtn.userInteractionEnabled=NO;
        [LoginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [LoginBtn.titleLabel setFont:Font_Size(17)];
        [LoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [LoginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [LoginBtn setBackgroundColor:Color_Macro(193, 193,193,1)];
        [cell addSubview:LoginBtn];
        
    
        
    }

    
    return cell;
}



#pragma mark tap

-(void)tapClick
{
    
    
}


#pragma mark   switchAction
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (!isButtonOn) {
        textFieldPwd.secureTextEntry = YES;
        
    }else {
        textFieldPwd.secureTextEntry= NO;
    }
      textFieldPwd.font=Font_Size(15);
}




-(void)loginClick
{
    [textFieldPwd resignFirstResponder];
    [textFieldName resignFirstResponder];

    [self vaildLoginInfo];


}



-(void)vaildLoginInfo
{
  
    if([CommonTool isValidateAccount:textFieldName.text])
    {
       [self  requestLogin];
    }
    else
    {

        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"请输入正确的用户名" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];

    }

}


-(void)requestLogin
{
    
      NSDictionary *dic=@{@"name":textFieldName.text,@"password":textFieldPwd.text};
    [[HttpAPI SharedCommonApi]requestPostMethodUrl:HTTP_LOGIN withParas:dic   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
        

        if (operation.response.statusCode==200) {
            
            [self requestCurrent];
        
            [MobClick event:@"loginSuccess"];
        }
        else
        {
        
        
              [CommonTool showAlertWithMsg:@"请输入正确用户名和密码！"];
        
        }
    
    
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    
        NSDictionary *dic=(NSDictionary*)operation.responseObject;
        NSString *msg=[NSString stringWithFormat:@"%@",dic[@"message"]];
        [CommonTool showAlertWithMsg:msg];
    
    
    }];
    

}




-(void)requestCurrent
{
    
    
    [[HttpAPI SharedCommonApi]requestGetMethodUrl:HTTP_Current withParas:nil   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
        
        
        if (operation.response.statusCode==200) {
            
            NSDictionary *dic=(NSDictionary*)resultObject;
            
            NSString *userId=[NSString stringWithFormat:@"%@",dic[@"id"]];
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
            
            NSString *username=[NSString stringWithFormat:@"%@",dic[@"username"]];
            
            
            NSString *nameId=[NSString stringWithFormat:@"usernameId%@",userId];
            NSString *gesId=[NSString stringWithFormat:@"gestureId%@",userId];
            NSString *firstLoginId=[NSString stringWithFormat:@"firstLoginId%@",userId];
            NSString *gestureValue=[[NSUserDefaults standardUserDefaults]objectForKey:gesId];
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:nameId];

            NSString *timeId=[NSString stringWithFormat:@"times%@",userId];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:timeId];
            
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
            
      
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:firstLoginId]&&([gestureValue isEqualToString:@"0"]||!gestureValue)){

                if(!popView)
                {
                    popView = [[POPVIew alloc] initWithText:nil Message:@"" leftButton:nil rightBtn:@""];
                    popView.delegate=self;
                    [popView show];
         
                }
                
              
                
            }
            else
            {
                
                
                [self.navigationController popViewControllerAnimated:NO];
                if ([self.turnType isEqualToString:@"resetGesture"]) {
                    
                    NSString *url=[NSString stringWithFormat:@"%@/#!home",BaseH5];
                    
                    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url", nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
                    
                }
                else
                {
                    [CommonTool showAlertWithMsg:@"登录成功！"];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil];
                }
                
                
                
            }
        }
        

        
    }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              
                                              
                                              
                                              [self requestCurrent];
                                              
                                          }];
    
    
}

#pragma mark   poviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView!=self.tableView) {
        [self.navigationController popViewControllerAnimated:NO];
        NSInteger row=[indexPath row];
        switch (row) {
            case 1:
            {
                
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"reset",@"opType",@"设置手势密码",@"title", @"1",@"ishome",nil];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"openGesture" object:nil userInfo:dict];
                
            }
                
                
                break;
                
            case 2:
            {
                
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil];
                
            }
                
                break;
                
            case 3:
            {
                NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
                NSString *firstLoginId=[NSString stringWithFormat:@"firstLoginId%@",userId];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLoginId];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil];
                
            }
                
                break;
                
                
            default:
                break;
        }
        
        

    }
    
}


#pragma mark textfield

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   if(textField==textFieldPwd)
   {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
       if (toBeString.length>0) {
           [LoginBtn setBackgroundColor:Color_Macro(252, 120,0,1)];
           LoginBtn.userInteractionEnabled=YES;
       }
       else
       {
           [LoginBtn setBackgroundColor:Color_Macro(193, 193,193,1)];
           LoginBtn.userInteractionEnabled=NO;
           
       }
   }
       

    return YES;

}


#pragma mark tableView init

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0,mainWidth,mainHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
        
    }
    return  _tableView;

}


@end
