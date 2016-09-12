//
//  UIViewController+MBProgressHUD.m
//
//
//  Created by zuoteng on 14/12/10.
//  Copyright (c) 2014年 zuoteng. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"

@implementation UIViewController (MBProgressHUD)

- (MBProgressHUD *)showAlertWords:(NSString *)string
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.view];
    if (!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
    }
    progressHUD.detailsLabelText = string;
    progressHUD.detailsLabelFont = [UIFont systemFontOfSize:14];
    progressHUD.mode = MBProgressHUDModeText;
    [progressHUD showAnimated:YES whileExecutingBlock:^{
        
        sleep(1.5);
    } completionBlock:^{
        
        [progressHUD removeFromSuperview];
    }];
    
    return progressHUD;
}

- (MBProgressHUD *)showAlertWords:(NSString *)string time:(int)times
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.view];
    if (!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
    }
    progressHUD.detailsLabelText = string;
    progressHUD.detailsLabelFont = [UIFont systemFontOfSize:14];
    progressHUD.mode = MBProgressHUDModeText;
    [progressHUD showAnimated:YES whileExecutingBlock:^{
        
        sleep(times);
    } completionBlock:^{
        
        [progressHUD removeFromSuperview];
    }];
    
    return progressHUD;
}

- (MBProgressHUD *)showAlertWordsAddNavView:(NSString *)string
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.navigationController.view];
    if (!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:progressHUD];
    }
    [self showAlertWordsWithProgressHUD:progressHUD string:string];
    
    return progressHUD;
}

- (void)showAlertWordsWithProgressHUD:(MBProgressHUD *)progressHUD string:(NSString *)string
{
    progressHUD.detailsLabelText = string;
    progressHUD.detailsLabelFont = [UIFont systemFontOfSize:14];;
    progressHUD.mode = MBProgressHUDModeText;
    [progressHUD showAnimated:YES whileExecutingBlock:^{
        
        sleep(1.5);
    } completionBlock:^{
        
        [progressHUD removeFromSuperview];
    }];
}

- (MBProgressHUD *)showLoading:(NSString *)string
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.view];
    if (!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
    }
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.detailsLabelText = string;
    progressHUD.detailsLabelFont = [UIFont systemFontOfSize:11];;
    [progressHUD show:YES];
    
    return progressHUD;
}

- (MBProgressHUD *)showLoadingAddNavView:(NSString *)string
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.navigationController.view];
    if (!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:progressHUD];
    }
    [self showLoadingWithProgressHUD:progressHUD string:string];
    
    return progressHUD;
}

- (MBProgressHUD *)showLoadingAddWindow:(NSString *)string
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.view.window];
    if (!progressHUD)
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:progressHUD];
    }
    [self showLoadingWithProgressHUD:progressHUD string:string];
    
    return progressHUD;
}

- (void)showLoadingWithProgressHUD:(MBProgressHUD *)progressHUD string:(NSString *)string
{
    progressHUD.detailsLabelText = string;
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.detailsLabelFont = [UIFont systemFontOfSize:14];;
    [progressHUD show:YES];
}

- (void)hideProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)hideProgressHUDAddNavView
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)hideProgressHUDAddWindow
{
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}

@end
