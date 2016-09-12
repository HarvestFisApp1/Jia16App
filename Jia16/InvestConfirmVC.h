//
//  InvestConfirmVC.h
//  Jia16
//
//  Created by Ares on 16/8/4.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestConfirmVC : UIViewController

@property (nonatomic,copy)  NSString *userId;
@property (nonatomic,copy)  NSString *subjectid;
@property (nonatomic,copy)  NSString *titleName;
@property (nonatomic,copy)  NSArray *vouchers;
@property (nonatomic,assign)  double  amount;
@property (nonatomic,assign)   BOOL    canVoucher;
@property  (nonatomic,assign)  double voucherAmount;
@property (nonatomic,copy)    NSString *linkUrl;
@property (nonatomic,copy)   NSString *pdfUrl;


@end
