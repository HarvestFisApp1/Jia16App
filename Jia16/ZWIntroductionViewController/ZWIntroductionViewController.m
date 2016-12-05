//
//  ZWIntroductionViewController
//  DiMeng
//
//  Created by panqiang on 15/6/16.
//  Copyright (c) 2015年 dimeng. All rights reserved.
//

#import "ZWIntroductionViewController.h"

@interface ZWIntroductionViewController () <UIScrollViewDelegate>

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
    
//    if (!self.pageControl) {
//        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 80, 10)];
//        self.pageControl.center = CGPointMake(mainWidth/2, mainHeight - 30);
//        self.pageControl.currentPageIndicatorTintColor=Color_Macro(177, 214, 46, 1);
//        self.pageControl.pageIndicatorTintColor=Color_Macro(65, 140, 159, 1);
//        self.pageControl.numberOfPages = 3;
//        [self.view addSubview:self.pageControl];
//    }
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
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(0, mainHeight/2, mainWidth, mainHeight/2);
            button1.clipsToBounds = YES;
            button1.layer.cornerRadius = 4;
            button1.center = CGPointMake(mainWidth / 2, mainHeight - 80);
            [button1 addTarget:self action:@selector(goResiter) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button1];
        }
    }
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
