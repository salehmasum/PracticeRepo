//
//  BaseVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/9.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()<UIGestureRecognizerDelegate>{
    NSInteger _animationIndex;
}
@end

@implementation BaseVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
  //  [self.view addSubview:self.scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO; 
    _animationIndex = 0;
    
    [self.view addSubview:self.navMenu];
    
//    [self addChildVC];
    [self setSegmentPageView];   
    
//    UIViewController *controller = self.vcArr.firstObject; 
//    if ([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {  
//        controller.navigationController.interactivePopGestureRecognizer.enabled = YES;  
//        controller.navigationController.interactivePopGestureRecognizer.delegate = self;  
//    }   
   // self.navigationController.interactivePopGestureRecognizer.delegate = self.vcArr.firstObject;
    
//    UIViewController *controller = self.vcArr.firstObject; 
//    UIScreenEdgePanGestureRecognizer *left2rightSwipe = [[UIScreenEdgePanGestureRecognizer alloc]  
//                                                         initWithTarget:self  
//                                                         action:@selector(didPanToPop:)];   
//    [left2rightSwipe setEdges:UIRectEdgeLeft];  
//    [controller.view addGestureRecognizer:left2rightSwipe];  
    
}
//- (void)didPanToPop:(id)gesture{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    return YES;
//}

- (void)setSegmentPageView{
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 55*TX_SCREEN_OFFSET+24*iSiPhoneX , SCREEN_WIDTH, 40) titles:self.menuItems headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutDefault];
    _segHead.delegate = self;
    _segHead.fontScale = 1;
    _segHead.fontSize = 14;
    _segHead.lineScale = 1;
    [self setHeadStyle];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)-49) vcOrViews:[self vcArr]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 0;
    _segScroll.backgroundColor = COLOR_WHITE;
    _segScroll.segDelegate = self;
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

- (void)animationEndIndex:(NSInteger)index{
    
}

- (void)didSelectedIndex:(NSInteger)index{
    
}

- (void)setHeadStyle{
    _segHead.lineColor = [UIColor colorWithRed:69/255.0f green:174/255.0f blue:1 alpha:1];
    _segHead.selectColor = [UIColor colorWithRed:69/255.0f green:174/255.0f blue:1 alpha:1];
    _segHead.deSelectColor = [UIColor colorWithRed:69/255.0f green:174/255.0f blue:1 alpha:1];
    self.segHead.headColor = [UIColor clearColor];
}



- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVIGATION_MENU_HEIGHT, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-( NAVIGATION_MENU_HEIGHT+MAIN_TABBAR_HEIGHT))];
        _contentView.backgroundColor = [UIColor clearColor]; 
        
        NSLog(@"contentView tabBar.isHidden %i",self.tabBarController.tabBar.isHidden);
    }
    return _contentView;
}


- (NSArray *)menuItems{
    return @[];
}
- (void)setUpFirstContentView{
    
   // [self addChildVC];
    
    _currentSelectedIndex = 0;  
    UIViewController *vc = self.childViewControllers[0];
    //调整子视图控制器的Frame已适应容器View  
    [self fitFrameForChildViewController:vc];  
    self.currentVC = vc;
    //设置默认显示在容器View的内容  
    [self.contentView addSubview:self.currentVC.view];
}

- (NavigationMenuView *)navMenu{
    if (!_navMenu) {
        _navMenu = [[NavigationMenuView alloc] init];
        _navMenu.type = [self menuType];
        _navMenu.title = [self navTitle];
        _navMenu.textColor = [self textColor];
        _navMenu.titleColor = [self titleColor];
        _navMenu.backgroundColor = [self bgColor];
        _navMenu.dataSource = @[];//[self menuItems];
        _navMenu.delegate = self;

    }
    return _navMenu;
}
 
- (MenuType)menuType{
    return MenuTypeNav;
}
- (UIColor *)titleColor{
    return COLOR_BLUE;
}
- (UIColor *)textColor{
    return COLOR_BLUE;
}
- (UIColor *)bgColor{
    return COLOR_WHITE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (void)navigaitonMenudidSelectedAtIndex:(NSInteger)index{
//    [self showVc:index];
    
    if (_currentSelectedIndex != index) {
        _currentSelectedIndex = index;
        
        UIViewController *newVC = self.childViewControllers[index];
        [self fitFrameForChildViewController:newVC];  
        [self transitionFromOldViewController:_currentVC toNewViewController:newVC]; 
        
    }
   
}
 

/**
 *  显示控制器的view
 *
 *  @param index 选择第几个
 *
 */
- (void)showVc:(NSInteger)index {
    CGFloat offsetX = index * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    UIViewController *vc = self.childViewControllers[index];
    // 判断控制器的view有没有加载过,如果已经加载过,就不需要加载
    if (vc.isViewLoaded) return;
    [self.scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, TX_SCREEN_WIDTH, CGRectGetHeight(self.scrollView.frame)); 
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_MENU_HEIGHT, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-( NAVIGATION_MENU_HEIGHT+MAIN_TABBAR_HEIGHT))];
        _scrollView.delegate = self;
        // 开启分页
        _scrollView.pagingEnabled = YES;
        // 没有弹簧效果
        _scrollView.bounces = NO;
        // 隐藏水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO; 
     //   _scrollView.scrollEnabled = NO;
        
        
       
    }
    return _scrollView;
}



- (void)fitFrameForChildViewController:(UIViewController *)chileViewController{  
    CGRect frame = self.contentView.frame;  
    frame.origin.y = 0;  
    chileViewController.view.frame = frame;  
}  

//转换子视图控制器  
- (void)transitionFromOldViewController:(UIViewController *)oldViewController 
                    toNewViewController:(UIViewController *)newViewController{  
  

    [self transitionFromViewController:oldViewController 
                      toViewController:newViewController 
                              duration:0.3 
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil 
                            completion:^(BOOL finished) {  
                                if (finished) {  
                                    [newViewController didMoveToParentViewController:self];  
                                    _currentVC = newViewController;  
                                }else{  
                                    _currentVC = oldViewController;  
                                }  
                            }];  
    
     



}  

//移除所有子视图控制器  
- (void)removeAllChildViewControllers{  
    for (UIViewController *vc in self.childViewControllers) {  
        [vc willMoveToParentViewController:nil];  
        [vc removeFromParentViewController];  
    }  
} 

@end
