//
//  HomeVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HomeVC.h" 

#import "HConditionLocationVC.h"
#import "HConditionTypeVC.h"
#import "HConditionCalendarVC.h"
#import "HomeTableViewVC.h"
#import "PopularTableVC.h"
#import "HShareCareTableVC.h"
#import "HBabysittingTableVC.h"
#import "HEventTableVC.h"
#import "CreateShareCareVC.h"
#import "CreateBabySittingVC.h"
#import "CreateEventsVC.h"
#import "UIViewController+Create.h"

@interface HomeVC ()<ConditonSelectedDelegate,UIScrollViewDelegate,HomeTableViewDidScrollDelegate>{
    
    BOOL _open;
    
    PopularTableVC  *_popularVC;
    HShareCareTableVC *_shareCareVC;
    HBabysittingTableVC *_babySittingVC;
    HEventTableVC *_eventsVC;
    
    NSInteger _selectIndex;
    
}


@property(nonatomic, strong)UITableView *tableView;
//@property(nonatomic, strong)UIScrollView *scrollView; 
@property(nonatomic, strong)UIView *headerView;
@end

@implementation HomeVC 
@synthesize viewControllers = _viewControllers;

//@synthesize navMenu = _navMenu;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:YES animated:YES]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"-----------");
    
    if (IS_AUTOM_REFRESH_POPULAR && _selectIndex==0) {
        [_popularVC loadPage:0];
        SET_AUTOM_REFRESH_POPULAR(NO); 
    }
    if (IS_AUTOM_REFRESH_HOME(0) && _selectIndex==1) {
        [_shareCareVC loadPage:0];
        SET_AUTOM_REFRESH_HOME(0, NO);
    }
    if (IS_AUTOM_REFRESH_HOME(1) && _selectIndex==2) {
        [_babySittingVC loadPage:0];
        SET_AUTOM_REFRESH_HOME(1, NO);
    }
    if (IS_AUTOM_REFRESH_HOME(2) && _selectIndex==3) {
        [_eventsVC loadPage:0];
        SET_AUTOM_REFRESH_HOME(2, NO);
    }
    
}

- (void)viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _locationType = 0;
    _careType = -1;
    _timeType = 0;
    self.conditionEnable = YES;
    self.addressLon = kUSER_COORDINATE_LONGITUDE;
    self.addressLat = kUSER_COORDINATE_LATITUDE;
    _time = @"0";
    _selectIndex = 0;
    
    NSLog(@"搜索条件初始化");
     
    if (SCREEN_WIDTH<=375.0) {
        self.segHead.frame = CGRectMake(5, 70*TX_SCREEN_OFFSET+24*iSiPhoneX, SCREEN_WIDTH-5, 40);
    }else{
        
        self.segHead.frame = CGRectMake(0, 70*TX_SCREEN_OFFSET+24*iSiPhoneX, SCREEN_WIDTH-5, 40);
    }self.segHead.frame = CGRectMake(0, 70*TX_SCREEN_OFFSET+24*iSiPhoneX, SCREEN_WIDTH-5, 40);
    self.segScroll.frame =CGRectMake(0, CGRectGetMaxY(self.segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.segHead.frame)-49);
    [self.segScroll setContentSize:CGSizeMake([self vcArr].count *self.segScroll.frame.size.width,0)];
    
   // self.segScroll.delegate = self;
     
    self.navMenu.shadowView.hidden = YES;
}
- (void)setHeadStyle{
    self.segHead.lineColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.segHead.selectColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.segHead.deSelectColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.segHead.headColor = [UIColor clearColor];   
}
 
- (MenuType)menuType{
    return MenuTypeSearch;
}
- (UIColor *)textColor{
    return COLOR_WHITE;
}
- (UIColor *)bgColor{
    return COLOR_BLUE;
}

- (NSString *)navTitle{
    return CustomLocalizedString(@"", @"home");
}

- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"POPULAR", @"home"),
             CustomLocalizedString(@"ELECARE", @"home"),
             CustomLocalizedString(@"BABYSITTING", @"home"),
             CustomLocalizedString(@"EVENTS", @"home")
             ];
} 


- (void)didSelectedIndex:(NSInteger)index{
    _selectIndex = index;
    
    if (index==1 && _shareCareVC.dataSource.count==0 && _shareCareVC.isViewLoaded) {
        [_shareCareVC loadPage:0];
    }
    if (index==2 && _babySittingVC.dataSource.count==0 && _babySittingVC.isViewLoaded) {
        [_babySittingVC loadPage:0];
    }
    if (index==3 && _eventsVC.dataSource.count==0 && _eventsVC.isViewLoaded) {
        [_eventsVC loadPage:0];
    }
    
}

#pragma mark --------------------------------------------------
#pragma mark Setup


- (NSArray *)vcArr{
    if (!_popularVC) {
        self.addressLon = kUSER_COORDINATE_LONGITUDE;
        self.addressLat = kUSER_COORDINATE_LATITUDE;
        _popularVC = [[PopularTableVC alloc] init];
        _popularVC.delegate = self;
        _popularVC.searchCondition = self.searchCondition;
    }
    
    
    if (!_shareCareVC) {
        _shareCareVC = [[HShareCareTableVC alloc] init];
        _shareCareVC.delegate = self;
        _shareCareVC.searchCondition = self.searchCondition;
    }
    
    if (!_babySittingVC) {
        _babySittingVC = [[HBabysittingTableVC alloc] init];
        _babySittingVC.delegate = self;
        _babySittingVC.searchCondition = self.searchCondition;
    }
    
    if (!_eventsVC) {
        _eventsVC = [[HEventTableVC alloc] init];
        _eventsVC.delegate = self;
        _eventsVC.searchCondition = self.searchCondition;
    }

    return @[_popularVC,_shareCareVC,_babySittingVC,_eventsVC];
}
 
//向上滚动，收缩搜索栏
- (void)homeTableViewDidScrollUpwardDirection{
    if(_open)[self.navMenu closeAction:nil];
}
#pragma mark --------------------------------------------------
#pragma mark UINavigationMenuDelegate

- (void)navigaitonMenuDidChangeStatus:(BOOL)open{
    _open = open;
    [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION animations:^{ 
        
        CGRect rect = self.navMenu.frame;
        rect.size.height = NAVIGATION_SEARCH_MENU_HEIGHT+CONDITION_VIEW_HEIGHT*(open);
        self.navMenu.frame = rect;
        
        
        self.segHead.frame = CGRectMake(0, (70+open*135)*TX_SCREEN_OFFSET+24*iSiPhoneX , SCREEN_WIDTH, 40);
        self.segScroll.frame =CGRectMake(0, CGRectGetMaxY(self.segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.segHead.frame)-49);
    } ];
}
- (void)navigaitonMenuDidSelectedItemType:(MenuSelectedItemType)type{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    switch (type) {
        case MenuSelectedItemTypeLocation:
        {
            HConditionLocationVC *locationVC = [sb instantiateViewControllerWithIdentifier:@"HConditionLocationVC"];
            locationVC.hidesBottomBarWhenPushed = YES;
            locationVC.delegate =self;
            [self.navigationController pushViewController:locationVC animated:YES];
        }
            break;
        case MenuSelectedItemTypeCategory:
        {
            HConditionTypeVC *typeVC = [sb instantiateViewControllerWithIdentifier:@"HConditionTypeVC"];
            typeVC.hidesBottomBarWhenPushed = YES;
            typeVC.delegate =self;
            [self.navigationController pushViewController:typeVC animated:YES];
        }
            break;
        case MenuSelectedItemTypeCalendar:
        {
            HConditionCalendarVC *calendarVC = [sb instantiateViewControllerWithIdentifier:@"HConditionCalendarVC"];
            calendarVC.hidesBottomBarWhenPushed = YES;
            calendarVC.delegate =self;
            [self.navigationController pushViewController:calendarVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)navigaitonMenuAddListAction{
      
    
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:nil 
                                          message:nil 
                                          preferredStyle:UIAlertControllerStyleActionSheet]; 
     
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sharecareAction = [UIAlertAction actionWithTitle:@"Create EleCare Listing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf createShareCare:@"ShareCare Listing"];
    }];
    
    UIAlertAction *babySittingAction = [UIAlertAction actionWithTitle:@"Create BabySitting Listing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf createBabysittings:@"BabySitting Listing"];
    }];
    
    UIAlertAction *eventAction = [UIAlertAction actionWithTitle:@"Create Event Listing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf createEvents:@"Event Listing"];
    }]; 
    [alertController addAction:cancelAction];
    [alertController addAction:sharecareAction];
    [alertController addAction:babySittingAction];
    [alertController addAction:eventAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
 

- (void)createShareCare:(NSString *)text{
    
    [self verifyChildrenLicenseForType:0 pass:nil];
}

- (void)createBabysittings:(NSString *)text{
    
    [self verifyChildrenLicenseForType:1 pass:nil];
}

- (void)createEvents:(NSString *)text{
    [self verifyChildrenLicenseForType:2 pass:nil];
}


- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, CONDITION_VIEW_HEIGHT)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}
- (void)openMenuFromffset:(CGFloat)offset{
    _open = YES;
    NSLog(@"end open=YES %f",offset);
    
    
    [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION animations:^{ 
        
        CGRect rect = self.tableView.frame;
        rect.origin.y = CONDITION_VIEW_HEIGHT+NAVIGATION_MENU_HEIGHT;
        self.tableView.frame = rect;
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    } completion:^(BOOL finished) { 
        
        _tableView.clipsToBounds = NO; 
    }];

}

- (void)closeMenuFromOffset:(CGFloat)offset animation:(BOOL)animated{
    NSLog(@"end open=NO %f",offset);
    _open = NO;
    if (animated) {
        
        [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION*animated animations:^{ 
            
            CGRect rect = self.tableView.frame;
            rect.origin.y =  NAVIGATION_MENU_HEIGHT;
            self.tableView.frame = rect;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } completion:^(BOOL finished) { 
            
            _tableView.clipsToBounds = YES;
        }];

    }else{
        
        CGRect rect = self.tableView.frame;
        rect.origin.y =  NAVIGATION_MENU_HEIGHT;
        self.tableView.frame = rect;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        _tableView.clipsToBounds = YES;

          }
          
}
          


//@property(assign,nonatomic) int locationType;//0->nearby 1->anywhere 2->location
//@property(assign,nonatomic) double addressLon;
//@property(assign,nonatomic) double addressLat;
//@property(assign,nonatomic) int careType;
//@property(assign,nonatomic) BOOL conditionEnable;
//@property(strong,nonatomic) NSString *time;
//time，例如：2017-12-04T15:00:00，传0时表示Anytime，tonight：传当天下午18:00:00


#pragma mark ConditonSelectedDelegate

//位置选择
- (void)conditionLocationAnywhere{
    self.navMenu.locationLabel.text = CustomLocalizedString(@"Anywhere", @"home");
    _locationType = 1;
    _conditionEnable = YES;
    [self updateSearchBar];
}

- (void)conditionLocationNearby{
    self.navMenu.locationLabel.text = CustomLocalizedString(@"Nearby", @"home");
    _locationType = 0;
    _conditionEnable = YES; 
    self.addressLon = kUSER_COORDINATE_LONGITUDE;
    self.addressLat = kUSER_COORDINATE_LATITUDE;
    [self updateSearchBar];
}

- (void)conditionLocationAddress:(NSString *)address lat:(double)lat lon:(double)lon{
    self.navMenu.locationLabel.text = address;//CustomLocalizedString(address, @"home");
    _locationType = 2;
    _addressLat = lat;
    _addressLon = lon;
    _address = address;
    _conditionEnable = YES;
    [self updateSearchBar];
}


//服务类型选择
- (void)conditionType:(ShareCareType)type{
    switch (type) {
        case ShareCareTypeShareCare:
            self.navMenu.typeLabel.text = CustomLocalizedString(@"EleCare", @"home");
            [self.segScroll setContentOffset:CGPointMake(TX_SCREEN_WIDTH*1,0) animated:YES];
            [self.segHead setSelectIndex:1];
            _careType = 0;
            break;
        case ShareCareTypebabySittings:
            self.navMenu.typeLabel.text = CustomLocalizedString(@"Babysitting", @"home");
            [self.segScroll setContentOffset:CGPointMake(TX_SCREEN_WIDTH*2,0) animated:YES];
            [self.segHead setSelectIndex:2];
            _careType = 1;
            break;
        case ShareCareTypeEvents:
            self.navMenu.typeLabel.text = CustomLocalizedString(@"Events", @"home");
            [self.segScroll setContentOffset:CGPointMake(TX_SCREEN_WIDTH*3,0) animated:YES];
            [self.segHead setSelectIndex:3];
            _careType = 2;
            break;
            
        default:
            break;
    }
     
    _conditionEnable = YES;
    [self updateSearchBar];
}


//时间选择
- (void)conditionAnyTime{
    self.navMenu.timeLabel.text = CustomLocalizedString(@"Anytime", @"home");
    
    _time = @"0";
    _timeType = 0;
    _conditionEnable = YES;
    _isTonight = NO;
    [self updateSearchBar];
}

- (void)conditionTonight{
    self.navMenu.timeLabel.text = CustomLocalizedString(@"Tonight", @"home");
    
    _time = [NSString stringWithFormat:@"%@T18:00:00",[Util getCurrentTime]];
    _timeType = 1;
    _conditionEnable = YES;
    _isTonight = YES;
    [self updateSearchBar];
}

- (void)conditionSelectedTime:(NSString *)timeString andDate:(NSDate *)date{
   // self.navMenu.timeLabel.text = timeString;
    _time = timeString;
    _timeType = 2;
    _conditionEnable = YES;
    _isTonight = NO;
    [self updateSearchBar];
}
- (void)conditionSelectedYear:(NSInteger)year month:(NSInteger)mongth day:(NSInteger)day{
    self.navMenu.timeLabel.text = [NSString stringWithFormat:@"%ld/%ld/%ld",day,mongth,year]; 
}
- (NSDictionary *)searchCondition{
    NSLog(@"搜索条件");
    /*
     增加isTonight字段：
     1、如果是sharecare，那么tonight和日期统一为yyyy-MM-dd
     2、如果是event, 那么tonight和日期统一为yyyy-MM-ddTHH:mm:ss
     3、如果是babysitting，那么tonight和日期统一为yyyy-MM-dd
     */
    NSString *timeStr = self.time?self.time:@"0";
    if (self.careType == 2) {
        if (timeStr.length == 10) {
            timeStr = [NSString stringWithFormat:@"%@T00:00:00",timeStr];
        }
    }else{
        if (timeStr.length == 19) {
            timeStr = [[timeStr componentsSeparatedByString:@"T"] firstObject];
        }
    }
    
    
    return @{@"locationType":[NSString stringWithFormat:@"%d",self.locationType],
             @"addressLat":[NSString stringWithFormat:@"%f",self.addressLat],
             @"addressLon":[NSString stringWithFormat:@"%f",self.addressLon],
             @"careType":[NSString stringWithFormat:@"%d",self.careType==-1?0:self.careType],
             @"time":timeStr,
             @"conditionEnable":@(self.conditionEnable),
             @"isTonight":self.isTonight?@"ture":@"false"}; 
}



- (void)updateSearchBar{
    
    _conditionEnable = YES;
    NSString *locationStr;
    switch (_locationType) {
        case 0:
            locationStr = @"Nearby";
            break;
        case 1:
            locationStr = @"Anywhere";
            break;
        case 2:
            locationStr = self.navMenu.locationLabel.text;//@"Location";
            break;
            
        default:
            break;
    }
    
    NSString *careTyeStr;
    switch (_careType) {
        case 0:
            careTyeStr = @"EleCare";
            break;
        case 1:
            careTyeStr = @"Babysitting";
            break;
        case 2:
            careTyeStr = @"Event";
            break;
            
        default:
            careTyeStr = @"Popular";
            break;
    }
    NSString *timeStr;
    switch (_timeType) {
        case 0:
            timeStr = @"Anytime";
            break;
        case 1:
            timeStr = @"Tonight";
            break;
        case 2:
            timeStr = _time;
            break;
            
        default:
            break;
    }

    self.navMenu.searchLabel.text = [NSString stringWithFormat:@"%@ · %@ · %@",locationStr,careTyeStr, self.navMenu.timeLabel.text];
    
    NSLog(@"~~~~~~~~~~~~~~~~~~~~~~`");
    
    switch (_careType) {
        case 0:
            _shareCareVC.searchCondition = self.searchCondition;
            
            _shareCareVC.conditionEnable = YES; 
            _popularVC.conditionEnable = NO;
            _babySittingVC.conditionEnable = NO;
            _eventsVC.conditionEnable = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadShareCarePage" object:self.searchCondition];
            [self.segHead setSelectIndex:1];
            break;
        case 1:
            _babySittingVC.searchCondition = self.searchCondition;
            
            _shareCareVC.conditionEnable = NO; 
            _popularVC.conditionEnable = NO;
            _babySittingVC.conditionEnable = YES;
            _eventsVC.conditionEnable = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadBabysittingPage" object:self.searchCondition];
            [self.segHead setSelectIndex:2];
            break;
        case 2:
            _eventsVC.searchCondition = self.searchCondition;
            
            _shareCareVC.conditionEnable = NO; 
            _popularVC.conditionEnable = NO;
            _babySittingVC.conditionEnable = NO;
            _eventsVC.conditionEnable = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadEventPage" object:self.searchCondition];
            [self.segHead setSelectIndex:3];
            break;
            
        default:
            _popularVC.searchCondition = self.searchCondition;
            
            _shareCareVC.conditionEnable = NO; 
            _popularVC.conditionEnable = YES;
            _babySittingVC.conditionEnable = NO;
            _eventsVC.conditionEnable = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadPopularPage" object:self.searchCondition];
            [self.segHead setSelectIndex:0];
            break;
    }
     
}


@end
