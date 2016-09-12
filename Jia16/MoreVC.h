//
//  MoreVC.h
//  Jia16
//
//  Created by Ares on 16/7/29.
//  Copyright © 2016年 Ares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreVC : UIViewController

- (IBAction)LoginClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
- (IBAction)investMakrSure:(id)sender;
- (IBAction)ContactUS:(id)sender;
- (IBAction)GestureClick:(id)sender;
- (IBAction)aboutClick:(id)sender;

@end
