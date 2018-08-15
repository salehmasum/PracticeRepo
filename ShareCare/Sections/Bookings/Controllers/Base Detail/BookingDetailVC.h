//
//  BookingDetailVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHInfiniteScrollView.h"
#import "BookingModel.h"
#import "HelpAndSupportVC.h"
#import "BookingCancelCell.h"
#import "BookingAmountCell.h"
#import "BookingAddressCell.h"
#import "BookingMessageCell.h"
#import "EventCancelCell.h"
#import "WhosComingCell.h"
#import "UIViewController+GooglePlace.h"
/*
 header:图片、发布者信息
 section=0:时间列表
 section=1:地址列表
 section=2:text:Who's Coming?
 section=3:参加的小孩
 section=4:支付信息（Amount、Booking Code）
 section=5:与发布者联系（Message）
 section=6:取消booking操作
 section=7:取消Event(免费)操作
 footer:Customer support
 */
typedef enum : NSUInteger {
    SectionTypeTIMES = 0,
    SectionTypeADDRESS = 1,
    SectionTypeWHOSCOIMG = 2,
    SectionTypeCHILDRENS = 3,
    SectionTypePAYINFO = 4,
    SectionTypeMESSAGE = 5,
    SectionTypeCANCELBOOKING = 6,
    SectionTypeCANCELEVENT = 7,
} SectionType;
 

@protocol BookingStateDidChangedDelegate <NSObject>

- (void)booking:(BookingModel *)booking atIndex:(NSInteger)row;

@end

@interface BookingDetailVC : UITableViewController<ContactSharecarerDelegate>

@property (strong, nonatomic) BookingModel *booking;
@property (strong, nonatomic) NSString *bookingId;
@property (assign, nonatomic) NSInteger row;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headViewLine;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnDecline;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) BHInfiniteScrollView *infinitePageView;
@property (strong, nonatomic) UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbCareType;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (assign, nonatomic) BookingState bookingState;
@property (assign, nonatomic) id<BookingStateDidChangedDelegate> delegate;

- (void)reloadData;
- (void)updateUI;
- (UIColor *)titleColor;
- (void)showCancelAlert;

- (IBAction)accept:(id)sender ;
- (IBAction)decline:(id)sender ;
- (void)cacncel:(id)sender ;
- (void)requestBookingChild:(NSString *)listId careType:(NSString *)type;
@end
