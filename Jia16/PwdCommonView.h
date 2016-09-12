//
//  PwdCommonView.h
//  ZhuoJinFu
//
//  Created by 李雪海 on 16/5/6.
//  Copyright © 2016年 dimeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PwdCommonViewDelegate;


@interface PwdCommonView : UIView
@property (nonatomic, weak) id<PwdCommonViewDelegate> delegate;

@property (nonatomic, weak) UITextField *passWordField;

@property (nonatomic, copy) NSString *delPwd;

@property (nonatomic, assign) BOOL isOldUserInvest; // 老用户账户余额投资

@property (nonatomic,strong) NSDictionary *bidParams;
- (void)showTransPasswdView:(NSInteger)type params:(NSDictionary *)params;

@end


@protocol PwdCommonViewDelegate <NSObject>


- (void)clickDeterBtn:(PwdCommonView*)view;

- (void)clickForgetPasswd:(PwdCommonView*)view;

- (void)clickFindJYPasswd:(PwdCommonView*)view;

@end
