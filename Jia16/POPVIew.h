//
//  POPVIew.h
//  ZhuoJinFu
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 dimeng. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol popViewDelegate <NSObject>

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface POPVIew : UIView

@property  (nonatomic,assign) id<popViewDelegate>  delegate;

-(void)show;

-(instancetype)initWithText:(NSString *)title Message:(NSString *)message leftButton:(NSString*)leftBtn rightBtn:(NSString *)rightBtn;


@end