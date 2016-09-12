//
//  InvestConfirmVC.m
//  Jia16
//
//  Created by Ares on 16/8/4.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "InvestConfirmVC.h"

#import "CommonTool.h"

#import "PwdCommonView.h"

#import "HttpAPI.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "SBJSON.h"

#import "json/JSON.h"
@interface InvestConfirmVC ()<UITableViewDelegate,UITableViewDataSource,PwdCommonViewDelegate,UIAlertViewDelegate>
{
    BOOL _isSelected;
    UIButton *_confirmBtn;
    BOOL  isVoucher;
    NSString *passWord;
}
@property(nonatomic,strong)  UITableView *tableView;
@end

@implementation InvestConfirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"投资确认";
    isVoucher=self.canVoucher;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
    [self.view addSubview:self.tableView];
    
}


-(void)backBarButton
{

    [self.navigationController popViewControllerAnimated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)requestInfo
{
    NSDate *now=[NSDate date];
    int timeStamp=[now timeIntervalSince1970];
    NSString *stampStr=[NSString stringWithFormat:@"%d",timeStamp];
    
    NSDictionary *dic=@{@"timestamp":stampStr,@"password":passWord};
    
        NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
    NSString *url=[NSString stringWithFormat:@"%@/%@/deal-password/verification", DM_BASE_URL,userId];

    [[HttpAPI SharedCommonApi]requestPostMethodUrl:url withParas:dic   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
        
        if (operation.response.statusCode==200) {

               [self confirmRequest];

        }
        else
        {
            
            
        }

        

        
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           
        
        NSDictionary *dic=(NSDictionary*)operation.responseObject;
        NSString *msg=[NSString stringWithFormat:@"%@",dic[@"message"]];
        
        
        
        [CommonTool showAlertWithMsg:msg];
 
    }];
   

}



#pragma mark 投资确认
-(void)confirmRequest
{
   
    NSDate *now=[NSDate date];
    int timeStamp=[now timeIntervalSince1970];
    NSString *stampStr=[NSString stringWithFormat:@"%d",timeStamp];
    NSDictionary *dic1=@{@"amount":@(self.amount),@"currency":@"CNY"};
    NSDictionary *dic;
    if (self.voucherAmount>0) {
        NSMutableArray *vouchers=[[NSMutableArray alloc]init];
        
        for(int i=0;i<self.vouchers.count;i++)
        {
            NSInteger value=[self.vouchers[i] integerValue];
            NSNumber *aNumber = [NSNumber numberWithInteger:value];
            [vouchers addObject:aNumber];
        }
            
    
        NSLog(@"%@----------",vouchers);
         dic=@{@"timestamp":stampStr,@"vouchers":vouchers,@"investmentAmount":dic1};
    }
    else
    {
         dic=@{@"timestamp":stampStr,@"investmentAmount":dic1};
    }
    
    NSString *url=[NSString stringWithFormat:@"%@/%@/subjects/%@/investment-requests",BASE_URL,self.userId,self.subjectid];

    [[HttpAPI SharedCommonApi]requestPostMethodUrl:url withParas:dic   success:^(AFHTTPRequestOperation* operation, NSObject *resultObject) {
        
        
        if (operation.response.statusCode==201||operation.response.statusCode==200) {
           
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"恭喜您，投资申请已成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

            [alert show];
        }
       
        
        
        
        
    }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               
                             
                                               
                                               NSDictionary *dic=(NSDictionary*)operation.responseObject;
                                               NSString *msg=[NSString stringWithFormat:@"%@",dic[@"message"]];
                                               if(msg.length>0)
                                               {
                                                  [CommonTool showAlertWithMsg:msg];
                                               
                                               }
                                               else
                                               {
                                                  [CommonTool showAlertWithMsg:@"投资失败,请重试!"];
                                                  
                                               }
                                          
                                               
                                               
                                               
                                               
                                           }];
}


//把多个json字符串转为一个json字符串
- (NSString *)objArrayToJSON:(NSArray *)array {
    
    NSString *jsonStr = @"[";
    
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
    
 
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.linkUrl,@"url", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadUrl" object:nil userInfo:dict];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
    


}


#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!isVoucher) {
        return 4;
    }
    return 6;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    int i=0;
    if (isVoucher) {
        i=2;
    }
    
    if (indexPath.row==0) {
        return 10;
    }
    else if (indexPath.row==3+i)
    {
        if (isVoucher) {
             return mainHeight-10-50*4;
        }
        else
        {
           return mainHeight-10-50*2;
        }
       


    }
    
    return 50;
    
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=Font_Size(15);
    cell.textLabel.textColor=Color_Macro(102,102,102,1);
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(150,0,200,50)];
    label.font=Font_Size(15);
    [cell addSubview:label];
    
    int i=0;
    if (isVoucher) {
        i=2;
    }
    
    if (indexPath.row==0) {
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    else  if (indexPath.row==1) {
       cell.textLabel.text=@"标的名称";
       label.text=[[NSString stringWithFormat:@"%@",self.titleName] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }
    else  if (indexPath.row==2) {
        cell.textLabel.text=@"本次投资金额";
        label.text=[NSString stringWithFormat:@"%.2f元",self.amount];
        
    }
    else if(indexPath.row==3&&isVoucher)
    {
        cell.textLabel.text=@"代金券抵扣";
        if (self.voucherAmount>0) {
              label.text=[NSString stringWithFormat:@"%.2f元",self.voucherAmount];
        }
        else
        {
        
              label.text=@"未使用";
        }
  
    }
    else if(indexPath.row==4)
    {
        
        double factAmount=self.amount-self.voucherAmount;
        cell.textLabel.text=@"实付金额";
        NSDictionary *dic1=@{@"str":[NSString stringWithFormat:@"%.2f",factAmount],@"font":@"15",@"color":Color_Macro(255, 120, 0, 1)};
        NSDictionary *dic2=@{@"str":@"元",@"font":@"15",@"color":Color_Macro(133, 133, 133, 1)};
        label.attributedText=[CommonTool changeAttributeString:dic1 Str2Dic:dic2];
        
    }
    else if (indexPath.row==3+i)
    {
        cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
        
        UIButton  *checkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [checkBtn setImage:[UIImage imageNamed:@"icon_radio"] forState:UIControlStateNormal];
        [checkBtn setImage:[UIImage imageNamed:@"icon_radio_checked"] forState:UIControlStateSelected];
        checkBtn.frame = CGRectMake(10, 13, 30, 30);
        checkBtn.imageView.frame=CGRectMake(5, CGRectGetMaxY(label.frame)+10, 16, 16);
        checkBtn.layer.cornerRadius=8;
        checkBtn.layer.masksToBounds=YES;
        [checkBtn addTarget:self action:@selector(checkClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:checkBtn];
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(checkBtn.frame)+18, 10, 260, 19)];
        label.font=Font_Size(15);
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled=YES;
        
        NSDictionary *dic1=@{@"str":@"我已阅读并同意 ",@"font":@"14",@"color":Color_Macro(133,133, 133, 1)};
        NSDictionary *dic2=@{@"str":@"《网站投资协议》",@"font":@"14",@"color":Color_Macro(130, 175, 211, 1)};
        label.attributedText=[CommonTool changeAttributeString:dic1 Str2Dic:dic2];
        [cell addSubview:label];
        
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(checkBtn.frame)+18, CGRectGetMaxY(label.frame)+10, 260, 19)];
        label1.font=Font_Size(15);
        label1.text=@"确认后资金将进入冻结账户";
        label1.textColor=Color_Macro(133,133,133,1);
        [cell addSubview:label1];
        
        _confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame=CGRectMake(10,CGRectGetMaxY(checkBtn.frame)+40,mainWidth-20,44);
        _confirmBtn.layer.cornerRadius=3;
        _confirmBtn.layer.masksToBounds=YES;
        _confirmBtn.userInteractionEnabled=NO;
        [_confirmBtn setTitle:@"确认投资" forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:Font_Size(17)];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setBackgroundColor:Color_Macro(193, 193,193,1)];
        [cell addSubview:_confirmBtn];
        
        
        
    }
    
    
    return cell;
}


#pragma mark checkBox
-(void)checkClick:(id)sender
{
    _isSelected=!_isSelected;
    
    UIButton *btn=(UIButton*)sender;
    btn.selected=_isSelected;
//    btn.userInteractionEnabled=_isSelected;
    if (_isSelected) {
        _confirmBtn.userInteractionEnabled=YES;
        _confirmBtn.backgroundColor=Color_Macro(255, 92, 12, 1);
    }
    else
    {
        
        _confirmBtn.userInteractionEnabled=NO;
        _confirmBtn.backgroundColor=Color_Macro(187, 187, 187, 1);
    }
    
    
}


-(void)tapClick
{
    if (self.pdfUrl) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pdfUrl]];
        
    }

}

-(void)confirmClick
{
    PwdCommonView *passWd = [[PwdCommonView alloc] initWithFrame:self.view.bounds];
    passWd.delegate = self;
    [passWd showTransPasswdView:1 params:nil];

}

#pragma mark  pwdDelegate
-(void)clickDeterBtn:(PwdCommonView *)view
{
    
    passWord=view.passWordField.text;
    
    [self requestInfo];
    

}




-(void)clickForgetPasswd:(PwdCommonView *)view
{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"忘记交易密码请在“我的账户”页找回。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.tag=111;
    [alert show];

}



-(void)clickFindJYPasswd:(PwdCommonView *)view
{


}



#pragma mark  tableView初始化
-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.scrollEnabled=NO;
    }
    return _tableView;

}


@end
