//
//  InvestDetailVC.m
//  Jia16
//
//  Created by Ares on 16/9/20.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "InvestDetailVC.h"

@interface InvestDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@end

@implementation InvestDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"固定收益" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButton)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
    
     self.title=@"新手专享10号P";
    // Do any additional setup after loading the view.
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

#pragma mark tableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSInteger row=indexPath.row;
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if(row==0)
    {
    
    
    }
    
    
    
    return cell;


}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  12;

}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  10;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0) {
        
    }
    
    
      

}







-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }

    return _tableView;
}

@end
