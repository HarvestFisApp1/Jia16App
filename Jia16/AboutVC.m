//
//  AboutVC.m
//  Jia16
//
//  Created by Ares on 16/8/8.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled=YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 50;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=Font_Size(15);
    cell.textLabel.textColor=Color_Macro(102,102,102,1);
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    
    
    if (indexPath.row==0) {
        cell.textLabel.text=@"关于我们";

    }
    else  if (indexPath.row==1) {
        cell.textLabel.text=@"股东介绍";
 
        
    }
    else  if (indexPath.row==2) {
        cell.textLabel.text=@"高管团队";

        
    }

    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        
    }

}


@end
