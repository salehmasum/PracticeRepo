//
//  BaseVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/9.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMSegmentManager.h"
#import "NavigationMenuView.h"

@interface BaseVC : UIViewController<UIScrollViewDelegate,UINavigationMenuDelegate,MLMSegmentScrollDelegate,MLMSegmentHeadDelegate>{
    NSInteger _currentSelectedIndex;
    NSArray *list;
}
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property (nonatomic, strong) UIView *contentView;  
@property (nonatomic, strong) UIViewController *currentVC; 


@property (strong, nonatomic) NavigationMenuView *navMenu;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *viewControllers;

- (NSArray *)vcArr;

- (MenuType)menuType;
- (NSString *)navTitle;
- (NSArray *)menuItems;
- (void)showVc:(NSInteger)index;

- (void)fitFrameForChildViewController:(UIViewController *)chileViewController;
@end
