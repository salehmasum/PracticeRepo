//
//  HBaseDetailVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>  
#import "CheckAvailabilityView.h"
#import "ReportAlertView.h"
#import "ReviewsViewController.h"
#import "CheckAvailabilityVC.h"
#import "SKFPreViewNavController.h"
#import "ShareCareModel.h"
#import "AgeRangeModel.h"
#import "EventModel.h"
#import "CredentialsModel.h"
typedef void(^JPNoParaBlock)(void);
typedef void(^JPContainIDBlock)(id);

typedef void(^FavoriteAddOrRemoveBlock)(id obj,BOOL isFavorite);

@interface HBaseDetailVC : UIViewController<ContactSharecarerDelegate>
@property (strong, nonatomic) BHInfiniteScrollView* infinitePageView;
@property (strong, nonatomic) CheckAvailabilityView *checkAvailabilityView;
@property (strong, nonatomic) ReportAlertView *reportAlert;
@property (strong, nonatomic) UITableView* tableView;

@property(strong, nonatomic) FavoriteAddOrRemoveBlock favoriteBlock;
/** coverImage */
@property(nonatomic, strong)UIImage *coverImage;

/** 进入出现动画 */
@property(nonatomic, strong)JPNoParaBlock fadeBlock;

/** 关闭动画 */
@property(nonatomic, strong)JPContainIDBlock closeBlock;

- (void)checkAvailabilityClick:(id)sender;
- (void)requestDetails;

@property(nonatomic, strong)NSString *idValue;
@property(nonatomic, assign)UserRoleType roleType;
@property(nonatomic, assign)BOOL isFavorite;
@property(nonatomic, strong)id item;

@property(nonatomic, strong)NSString *thumbnail;
@property(nonatomic, strong)NSString *headline;
@property(nonatomic, strong)NSString *typeString;
@property(nonatomic, strong)NSString *address;
@property(nonatomic, strong)NSString *dateAndTime;
@property(nonatomic, strong)NSString *about;
@property(nonatomic, strong)NSString *userIcon;
@property(nonatomic, strong)NSString *userName;
@property(nonatomic, strong)NSString *accountId;
@property(nonatomic, assign)CGFloat totalStarRating;
@property(nonatomic, strong)NSArray *photos;
@property(nonatomic, strong)NSArray *reviewDtoList;
@property(nonatomic, strong)NSMutableArray *childrens;
@property(nonatomic, strong)NSAttributedString *aboutAttributedString;
@property(nonatomic, strong)AgeRangeModel *ageRangeModel;
@property(nonatomic, strong)CredentialsModel *credentialsModel;
 
@property (nonatomic,strong) UIBarButtonItem *favoriteBtn;
@end
