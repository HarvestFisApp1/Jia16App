//
//  MoreVC.m
//  Jia16
//
//  Created by Ares on 16/7/29.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import "MoreVC.h"

#import "LoginVC.h"

#import "InvestConfirmVC.h"

#import "ContactUSViewController.h"

#import "GesturePasswordController.h"

#import "AboutVC.h"
@interface MoreVC ()

@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (IBAction)LoginClick:(id)sender {
    
    LoginVC *login=[[LoginVC alloc]init];
    login.navigationController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:YES];
    
}
- (IBAction)investMakrSure:(id)sender {
    
    InvestConfirmVC *confirmVC=[[InvestConfirmVC alloc]init];
    confirmVC.navigationController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:confirmVC animated:YES];
    
}

- (IBAction)ContactUS:(id)sender {
    
    ContactUSViewController *contactUS=[[ContactUSViewController alloc]init];
    [self.navigationController pushViewController:contactUS animated:YES];
    
}

- (IBAction)GestureClick:(id)sender {
    
    GesturePasswordController *gestureVC=[[GesturePasswordController alloc]init];
    [self.navigationController pushViewController:gestureVC animated:YES];
    
}

- (IBAction)aboutClick:(id)sender {
    
    AboutVC  *about=[[AboutVC alloc]init];
    [self presentViewController:about animated:YES completion:nil];
    
}
@end
