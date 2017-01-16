//
//  ZWIntroductionViewController
//  DiMeng
//
//  Created by panqiang on 15/6/16.
//  Copyright (c) 2015年 dimeng. All rights reserved.
//

#import "ZWIntroductionViewController.h"

@interface ZWIntroductionViewController () <UIScrollViewDelegate>
{
    UIButton  *btn1;
    UIButton *btn2;

}
@property (nonatomic, strong) NSArray *imageViews;

@property (nonatomic, assign) NSInteger centerPageIndex;

@end

@implementation ZWIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(mainWidth * 4, mainHeight);
        self.scrollView.delegate = self;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
    }
    
    if (!self.pageControl) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 80, 10)];
        self.pageControl.center = CGPointMake(mainWidth/2, mainHeight - 30);
        self.pageControl.currentPageIndicatorTintColor=Color_Macro(227,129,15, 1);
        self.pageControl.pageIndicatorTintColor=Color_Macro(255, 225, 196, 1);
        self.pageControl.numberOfPages = 4;
    

        
         [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];  //用户点击UIPageControl的响应函数

        [self.view addSubview:self.pageControl];
    }
//
    self.imageViews = @[@"guide1",@"guide2",@"guide3",@"guide4"];
    
    for (NSInteger i = 0 ; i < self.imageViews.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth * i, 0, mainWidth, mainHeight)];
        imageView.image = [UIImage imageNamed:self.imageViews[i]];
        imageView.userInteractionEnabled = YES;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(mainWidth -65, 25, 50, 50);
//        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(closeLaunch) forControlEvents:UIControlEventTouchUpInside];
//        button.imageEdgeInsets=UIEdgeInsetsMake(0, 10, 10, 10);
//        
//        [imageView addSubview:button];
        
        
        
        [self.scrollView addSubview:imageView];
        
        if (i == 3) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, mainWidth, mainHeight/2);
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 4;
           [button addTarget:self action:@selector(closeLaunch) forControlEvents:UIControlEventTouchUpInside];
           [imageView addSubview:button];
            
//            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//            button1.frame = CGRectMake(0, mainHeight/2, mainWidth, mainHeight/2);
//            button1.clipsToBounds = YES;
//            button1.layer.cornerRadius = 4;
//            button1.center = CGPointMake(mainWidth / 2, mainHeight - 80);
//            [button1 addTarget:self action:@selector(goResiter) forControlEvents:UIControlEventTouchUpInside];
//            [imageView addSubview:button1];
        }
    }
    
    btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(110,mainHeight*3.05/4, 200, 44);
    btn1.center=CGPointMake(self.view.center.x, btn1.center.y);
    btn1.layer.borderWidth=0.5;
    btn1.layer.borderColor=Color_Macro(192,88,122,1).CGColor;
    btn1.layer.cornerRadius=5;
    btn1.layer.masksToBounds=YES;
    btn1.backgroundColor=[UIColor whiteColor];
    [btn1 setTitle:@"注册领680元" forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [btn1 setTitleColor:Color_Macro(192,88,122,1) forState:UIControlStateNormal];
    btn1.hidden=YES;
    [btn1 addTarget:self action:@selector(goResiter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    btn2=[UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame=CGRectMake(110,CGRectGetMaxY(btn1.frame)+5, 200, 44);
    btn2.center=CGPointMake(self.view.center.x, btn2.center.y);
    btn2.hidden=YES;
    btn2.layer.cornerRadius=5;
    btn2.layer.masksToBounds=YES;
    btn2.layer.borderWidth=0.5;
    btn2.layer.borderColor=Color_Macro(91,150,137,1).CGColor;
    btn2.backgroundColor=[UIColor whiteColor];
      [btn2.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [btn2 setTitle:@"直接进入" forState:UIControlStateNormal];
    [btn2 setTitleColor:Color_Macro(91,150,137,1) forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(closeLaunch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / mainWidth;
    if(self.pageControl.currentPage==3)
    {
    
        btn1.hidden=NO;
        btn2.hidden=NO;
    
    }
    else
    {
        btn1.hidden=YES;
        btn2.hidden=YES;
    
    }
}



- (void)pageTurn:(UIPageControl*)sender
{

    CGSize viewSize = self.scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
}





#pragma mark - Action

- (void)closeLaunch
{
    self.didSelectedEnter();
}

-(void)goResiter
{
       self.didRegister();

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
