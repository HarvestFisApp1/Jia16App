//
//  PwdCommonView.m
//  ZhuoJinFu
//
//  Created by 李雪海 on 16/5/6.
//  Copyright © 2016年 dimeng. All rights reserved.
//

#import "PwdCommonView.h"

#import "UIImage+RenderedImage.h"

#import "UIViewController+MBProgressHUD.h"

#import "POPVIew.h"

#import "CommonTool.h"

@interface PwdCommonView ()<UITextFieldDelegate, popViewDelegate>
{
    UIView *_bgView;
    
    UIView *_whiteView;
    
    NSInteger _type;
    
    UIViewController *_delegateControVc;
    
    UIImageView *_mimaseeImageV;
    
    BOOL _isMimaseeOpen;
    
    NSDictionary *_params;
    
    NSString *_passWard;
    
    UITextField *passWordField;
}
@end
@implementation PwdCommonView

- (void)initView:(NSInteger)type
{
    self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.6];
    
    UIView *whiteView;
    
    if (iPhone4 || iPhone5)
    {
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 75, mainWidth-30, 200)];
    }
    else
    {
        whiteView = [[UIView alloc] initWithFrame:CGRectMake(15, 150, mainWidth-30, 230)];
    }
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10;
    [self addSubview:whiteView];
    [self bringSubviewToFront:whiteView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(10, 10, 25, 25);
    closeButton.layer.cornerRadius=12.5;
    closeButton.layer.masksToBounds=YES;
    [closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [closeButton.imageView setFrame:CGRectMake(0,0,10,10)];
    closeButton.imageView.contentMode =UIViewContentModeScaleAspectFit;
    [closeButton addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,whiteView.frame.size.width,49)];
    label1.textColor = Color_Macro(51, 51, 51, 1);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = Font_Size(17);
    [whiteView addSubview:label1];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49,whiteView.frame.size.width, 1)];
    line.backgroundColor = Color_Macro(204, 204, 204, 1);
    line.alpha = 0;
    [whiteView addSubview:line];
    

    UIView *textView;


    if (iPhone4 || iPhone5)
    {
        textView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame)+5, whiteView.frame.size.width-30, 44)];

    
    }
    else
    {
        textView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame)+5,whiteView.frame.size.width-30, 44)];

    }
    
    
    textView.layer.borderColor = Color_Macro(161, 161, 161, 1).CGColor;
    textView.layer.borderWidth = 0.7;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 5;
    passWordField=[[UITextField alloc] initWithFrame:CGRectMake(0,0, whiteView.frame.size.width-100, 44)];
    [passWordField setTintColor:Color_Macro(51, 51, 51, 1)];

    passWordField.textColor = Color_Macro(51, 51, 51, 1);
    passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    passWordField.leftView = viewLeft;
    passWordField.leftViewMode = UITextFieldViewModeAlways;
    if (iPhone5 || iPhone4)
    {
        passWordField.font = Font_Size(12);
        
    }
    else
    {
        passWordField.font = Font_Size(16);
        
    }
    passWordField.secureTextEntry = YES;
    passWordField.delegate = self;
    [passWordField becomeFirstResponder];
    [textView addSubview:passWordField];
    
    UISwitch  *open=[[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passWordField.frame)+10,6,55,20)];
    open.onTintColor=Color_Macro(250,120,0, 1);
    open.onImage=[UIImage imageNamed:@"开"];
    open.offImage=[UIImage imageNamed:@"关"];
    [open setOn:NO];
    [open addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [textView addSubview:open];

    [whiteView addSubview:textView];
    
    UILabel *label2;
    if (type == 1)
    {
        label1.text = @"请输入交易密码";
        passWordField.placeholder = @"请输入交易密码";
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(textView.frame) + 8, 100, 21)];
        label2.text = @"忘记交易密码?";
        label2.font = Font_Size(14);
        label2.textAlignment = NSTextAlignmentRight;
        label2.textColor = Color_Macro(133, 133, 133, 1);
        
        
        label2.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickJYpasswd)];
        [label2 addGestureRecognizer:tap];
    }
    else if (type == 0)
    {
        label1.text = @"设置交易密码";
        passWordField.placeholder = @"请输入6-16位数字和字母";
        
        UIView *viewRight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 14)];
        //        viewRight.backgroundColor = [UIColor redColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, viewRight.frame.size.height)];
        imageV.image = [UIImage imageNamed:@"mimasee_off"];
        imageV.userInteractionEnabled = YES;
        [viewRight addSubview:imageV];
        passWordField.rightView = viewRight;
        passWordField.rightViewMode = UITextFieldViewModeAlways;
        
        UITapGestureRecognizer *tar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMimasee)];
        [imageV addGestureRecognizer:tar];
        
        _mimaseeImageV = imageV;
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(textView.frame) + 8, 200, 21)];
        label2.text = @"请牢记交易密码，投资、提现使用";
        label2.font = Font_Size(12);
        label2.textColor = Color_Macro(153, 153, 153, 1);
    }
    else if (type ==2)
    {
        label1.text = @"输入登录密码";
        passWordField.placeholder = @"请输入登录密码";
        
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(whiteView.frame.size.width-15-100, CGRectGetMaxY(textView.frame), 100, 21)];

    }
    
    [whiteView addSubview:label2];
    
    UIButton *deterButton = [[UIButton alloc] init];
    deterButton.frame = CGRectMake(15, CGRectGetMaxY(label2.frame) + 16, whiteView.frame.size.width-30, 43);
    [deterButton setTitle:@"确定" forState:UIControlStateNormal];
    [deterButton setTitle:@"确定" forState:UIControlStateHighlighted];
    deterButton.titleLabel.font = Font_Size(18);
    [deterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [deterButton setBackgroundImage:[UIImage imageWithColor:Color_Macro(255, 92, 12, 1) Size:deterButton.frame.size] forState:UIControlStateNormal];
    [deterButton setBackgroundImage:[UIImage imageWithColor:Color_Macro(245, 81, 0, 1) Size:deterButton.frame.size] forState:UIControlStateHighlighted];
    deterButton.layer.cornerRadius = 5;
    deterButton.layer.masksToBounds = YES;
    [deterButton addTarget:self action:@selector(clickDeterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:deterButton];
    
    [self addSubview:whiteView];
    
    _type = type;
    
    _whiteView = whiteView;
    
    self.passWordField = passWordField;
    
    self.passWordField.keyboardType = UIKeyboardTypeASCIICapable;
}

- (void)clickJYpasswd
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickForgetPasswd:)])
    {
        [_delegate clickForgetPasswd:self];
    }
    
    [self clickCloseBtn];
}


- (void)showTransPasswdView:(NSInteger)type params:(NSDictionary *)params;
{
    
    [self initView:type];
    
    _params = params;
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)clickCloseBtn
{
    
    [self removeFromSuperview];
}

- (void)whiteViewClose
{
    [_whiteView removeFromSuperview];
    _whiteView = nil;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)clickMimasee
{
    _isMimaseeOpen = !_isMimaseeOpen;
    
    if (_isMimaseeOpen)
    {
        self.passWordField.keyboardType = UIKeyboardTypeASCIICapable;
        
        _mimaseeImageV.image = [UIImage imageNamed:@"mimasee_on"];
        
        self.passWordField.text = self.passWordField.text;
        
        self.passWordField.secureTextEntry = NO;
        
    }
    else
    {
        self.passWordField.keyboardType = UIKeyboardTypeASCIICapable;
        
        _mimaseeImageV.image = [UIImage imageNamed:@"mimasee_off"];
        
        self.passWordField.text = self.passWordField.text;
        
        self.passWordField.secureTextEntry = YES;
    }
}

- (void)clickDeterBtn:(UIButton*)deterBtn
{
    [self endEditing:YES];
    
    _delegateControVc = (UIViewController *)self.delegate;
    
    NSString *textName = [self.passWordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (_type != 2)
    {
        self.delPwd=textName;
        
    }
    
    if (textName.length==0)
    {
        if (_type ==2)
        {
            [CommonTool showAlertWithMsg:@"请输登陆密码"];
            
        }
        else
        {
            // 接口验证
            [CommonTool showAlertWithMsg:@"请输入交易密码"];
        }
        
    }
    
    else
    {
        if (_type == 2)
        {
            [self dengLuPwd];
            return;
        }
        if (_delegate && [ _delegate respondsToSelector:@selector(clickDeterBtn:)])
        {
            [_delegate clickDeterBtn:self];
        }
   
        [self clickCloseBtn];
    
    }
}

- (void)dengLuPwd
{
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *textName = [self.passWordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![textName isEqualToString:password])
    {
        [CommonTool showAlertWithMsg:@"登录密码不正确，请重试"];
    }
    else
    {
        
        
        if (_delegate && [_delegate respondsToSelector:@selector(clickFindJYPasswd:)])
        {
            [_delegate clickFindJYPasswd:self];
        }
        
        [self clickCloseBtn];
    }
}

#pragma mark TextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return (range.location>15?NO:YES);
}


#pragma mark   switchAction
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (!isButtonOn) {
        passWordField.secureTextEntry = YES;
    }else {
        passWordField.secureTextEntry= NO;
    }
}



@end
