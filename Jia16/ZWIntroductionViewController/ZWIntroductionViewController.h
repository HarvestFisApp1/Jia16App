//
//  ZWIntroductionViewController
//  DiMeng
//
//  Created by panqiang on 15/6/16.
//  Copyright (c) 2015年 dimeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedEnter)();

@interface ZWIntroductionViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

@end
