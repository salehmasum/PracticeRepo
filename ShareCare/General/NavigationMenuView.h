//
//  NavigationMenuView.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuType){
    MenuTypeNav,
    MenuTypeSearch,
    MenuTypePushView
};

typedef NS_ENUM(NSInteger, MenuSelectedItemType){
    MenuSelectedItemTypeLocation,
    MenuSelectedItemTypeCategory,
    MenuSelectedItemTypeCalendar
};


@protocol UINavigationMenuDelegate <NSObject>

//选中第几个菜单
- (void)navigaitonMenudidSelectedAtIndex:(NSInteger)index;
@optional
- (void)navigaitonMenuDidChangeStatus:(BOOL)open;
- (void)navigaitonMenuDidSelectedItemType:(MenuSelectedItemType)type; 

//Create 
- (void)navigaitonMenuAddListAction;

@end

typedef void(^BackActionBlock)(void);

@interface NavigationMenuView : UIView 


@property (assign, nonatomic) MenuType type;

@property (strong, nonatomic) UILabel *searchLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIView   *contentView;
@property (strong, nonatomic) NSArray  *dataSource;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor  *textColor;  
@property (strong, nonatomic) UIColor  *titleColor;  
@property (assign, nonatomic) CGFloat offset;

@property (strong, nonatomic) UIImageView *shadowView;

@property (assign, nonatomic) id<UINavigationMenuDelegate>delegate;
 

//- (instancetype)initWithType:(MenuType)type;

- (void)openAction:(id)sender;
- (void)closeAction:(id)sender;

- (void)setBackImage:(UIImage *)image action:(BackActionBlock)backBlock;

@end

 
