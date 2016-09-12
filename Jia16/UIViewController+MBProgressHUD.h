//
//  UIViewController+MBProgressHUD.h
//  
//
//  Created by zuoteng on 14/12/10.
//  Copyright (c) 2014年 zuoteng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface UIViewController (MBProgressHUD)

/**
 *  展示提示语，add在self.view
 *
 *  @param string 提示语
 *
 *  @return MBProgressHUD对象
 */
- (MBProgressHUD *)showAlertWords:(NSString *)string;
/**
 *  展示提示语，add在self.view
 *
 *  @param string 提示语
 *
 *  @param times   时间
 *
 *  @return MBProgressHUD对象
 */
- (MBProgressHUD *)showAlertWords:(NSString *)string time:(int)times;

/**
 *  展示提示语，add在navigationController.view
 *
 *  @param string 提示语
 *
 *  @return MBProgressHUD对象
 */
- (MBProgressHUD *)showAlertWordsAddNavView:(NSString *)string;


- (MBProgressHUD *)showLoadingAddWindow:(NSString *)string;

/**
 *  展示指定progressHUD提示语
 */
- (void)showAlertWordsWithProgressHUD:(MBProgressHUD *)progressHUD string:(NSString *)string;

/**
 *  展示加载框，add在self.view
 *
 *  @param string 提示语
 *
 *  @return MBProgressHUD对象
 */
- (MBProgressHUD *)showLoading:(NSString *)string;

/**
 *  展示加载框，add在navigationController.view
 *
 *  @param string 提示语
 *
 *  @return MBProgressHUD对象
 */
- (MBProgressHUD *)showLoadingAddNavView:(NSString *)string;

/**
 *  展示指定progressHUD加载框
 */
- (void)showLoadingWithProgressHUD:(MBProgressHUD *)progressHUD string:(NSString *)string;

/**
 *  隐藏，add在self.view
 */
- (void)hideProgressHUD;

/**
 *  隐藏，add在navigationController.view
 */
- (void)hideProgressHUDAddNavView;

- (void)hideProgressHUDAddWindow;

@end
