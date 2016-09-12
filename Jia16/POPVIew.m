//
//  POPVIew.m
//  ZhuoJinFu
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 dimeng. All rights reserved.
//

#import "POPVIew.h"

#import "GesturePasswordController.h"

@interface POPVIew()<UITableViewDataSource,UITableViewDelegate>
{

    
    
}

@property (nonatomic,strong)  UITableView  *tableView;

@end


@implementation POPVIew



-(instancetype)initWithAmount:(double)avMoney payMoney:(double)payMoney
{
    self=[super init];
    if (self) {
        

        
    }
    
    return self;
    
}


-(instancetype)initWithText:(NSString *)title Message:(NSString *)message leftButton:(NSString*)leftBtn rightBtn:(NSString *)rightBtn
{
    
    self=[super init];
    if (self) {

        
    }
    
    return self;
}






-(void)show
{
    
    [self updateFrame];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
}



-(void)updateFrame
{
    
    self.frame=CGRectMake(0, 0, mainWidth, mainHeight);
    self.backgroundColor=[UIColor blackColor];
    UIColor *color = [UIColor blackColor];
    self.backgroundColor = [color colorWithAlphaComponent:0.6];

    [self addSubview:self.tableView];

    
    
    
    
}



-(UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.layer.cornerRadius=8;
        _tableView.layer.masksToBounds=YES;
        _tableView.frame=CGRectMake(0, 0, 266, 220);
        _tableView.center=CGPointMake(mainWidth/2, mainHeight/2);
        _tableView.scrollEnabled=NO;
        _tableView.alpha=1;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
    }
    
    
    return _tableView;
    
}





#pragma make button event

-(void)leftBtnClick
{
    [self removeFromSuperview];
    
}






#pragma mark tableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index=[indexPath row];
    UITableViewCell  *cell;
    cell=[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    
    
    switch (index) {
            
            
        case 0:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0 ,266-30, 70)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=Font_Size(15);
            label.textColor=Color_Macro(51, 51, 51, 1);
            label.text=@"为了您的资金安全和使用便捷，请设置手势密码";
            label.numberOfLines=0;
            label.lineBreakMode=NSLineBreakByCharWrapping;
            [cell addSubview:label];
            
            
            return cell;
            
            
        }
            break;
            
        case 1:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 266-30,50)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=Font_Size(15);
            label.textColor=Color_Macro(51, 51, 51, 1);
            label.text=@"去设置";
            
            [cell addSubview:label];
            
            return cell;
            
            
            
        }
            break;
            
        case 2:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 266-30,50)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=Font_Size(15);
            label.textColor=Color_Macro(51, 51, 51, 1);
            label.text=@"暂不设置";
            [cell addSubview:label];
            
            
            return cell;
            
            
        }
            break;
            
        case 3:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 266-30,50)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=Font_Size(15);
            label.textColor=Color_Macro(51, 51, 51, 1);
            label.text=@"不再提醒";
            
            [cell addSubview:label];
            
            
            return cell;
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 4;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==0) {
        return 70;
    }
    
    return 50;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath];

    
    [self removeFromSuperview];
    
}

-(void)closeView
{
    [self removeFromSuperview];
    
}



@end
