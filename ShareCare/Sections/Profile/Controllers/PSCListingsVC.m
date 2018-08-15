//
//  PSCListingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PSCListingsVC.h"
#import "CreateShareCareVC.h"
#import "ShareCareModel.h"
#import "EventModel.h"
#import "BabysittingModel.h"
#import "UIViewController+Create.h"
#import "HBaseDetailVC.h"
#import "HShareCareDetailVC.h"
#import "HBabysittingDetailVC.h"
#import "HEventDetailVC.h"
#import "PSCListingsDetailVC.h"
#import "PBSListingsDetailVC.h"
#import "PEListingsDetailVC.h"
@interface PSCListingsVC ()<BookingStateDidChangedDelegate>{
    NSString *_today;//2018-01-01
}
@end

@implementation PSCListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.tableView.tableFooterView = [UIView new];
 //   self.tableView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-NAVIGATION_MENU_HEIGHT-80);
     
}

- (void)resetUI{
    
    //获取系统当前时间  
    NSDate *currentDate = [NSDate date];   
    NSDateFormatter *dateFormatter = [Util dateFormatter];   
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];   
    _today = [dateFormatter stringFromDate:currentDate];  
    
    
    [self.footerView removeFromSuperview];
    if (self.dataSource.count) {
        self.tableView.tableHeaderView = [UIView new];
        
//        [self.footerView removeFromSuperview];
//        self.footerView.center = CGPointMake(self.footerView.center.x, TX_SCREEN_HEIGHT-NAVIGATION_MENU_HEIGHT-40);
//        [self.view addSubview:self.footerView];
        
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 100)];
        [self.view addSubview:self.footerView];
        self.footerView.center = CGPointMake(TX_SCREEN_WIDTH/2, CGRectGetMaxY(self.tableView.frame)-40);
    }else{
        
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = self.footerView;
    }
//    if (self.dataSource.count<=2) { 
//        self.tableView.tableFooterView = self.footerView;
//    }else{
//        [self.view addSubview:self.footerView];
//    }
//    self.tableView.tableFooterView = self.footerView;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [super scrollViewDidScroll:scrollView];
//    self.footerView.hidden = YES;
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.footerView.hidden = NO;
//    self.footerView.center = CGPointMake(self.footerView.center.x, scrollView.contentOffset.y-40);
//}

- (NSString *)headerTitleText{
    return @"You don’t have any listings!";
}
- (NSString *)headerDescText{
    return @"Make money by renting out your extra space on EleCare. You’ll also get to meet amazing parents from around your area! ";
}
- (NSString *)api{
    return API_SHARECARE_MYSELF_LIST;
}

- (id)convertObjectWithObject:(id)object{
    return [ShareCareModel modelWithDictionary:object];
}



- (void)post:(id)sender{
    
    [self verifyChildrenLicenseForType:0 pass:nil];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpcomingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upcoming" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.moreButton.hidden= YES;
    ShareCareModel *sharecare = self.dataSource[indexPath.row];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(sharecare.thumbnail)] 
                  placeholderImage:kDEFAULT_IMAGE];
    cell.lbCaretype.text = @"EleCare";
    // cell.lbDate
    cell.lbAddress.text = [sharecare.address stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","];
    cell.lbTime.text = sharecare.headline;
    cell.lbDate.textAlignment = NSTextAlignmentRight;
    cell.lbDate.text = [NSString stringWithFormat:@"$%@/day",sharecare.moneyPerDay];
    cell.imgState.image = BOOKING_IMAGE_STATE(sharecare.shareCareStatus.integerValue);//[self checkAvailableTime:sharecare.availableTime];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    __weak typeof(self) weakSelf = self; 
//    HBaseDetailVC *presentViewController ;// 
//    id object = self.dataSource[indexPath.row];
//    if ([object isKindOfClass:[ShareCareModel class]]) {
//        presentViewController = [HShareCareDetailVC new];
//    }else if ([object isKindOfClass:[BabysittingModel class]]){ 
//        presentViewController = [HBabysittingDetailVC new];
//    }else if ([object isKindOfClass:[EventModel class]]){ 
//        presentViewController = [HEventDetailVC new];
//    } 
//    presentViewController.item = object; 
//    presentViewController.hidesBottomBarWhenPushed = YES; 
//    presentViewController.favoriteBlock = ^(id obj,BOOL isFavorite) { 
//        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:obj];
//        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    };
//    [self.navigationController pushViewController:presentViewController animated:YES];
    
    PSCListingsDetailVC *presentViewController ;// 
    id object = self.dataSource[indexPath.row];
    if ([object isKindOfClass:[ShareCareModel class]]) { 
        presentViewController = [[PSCListingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
    }else if ([object isKindOfClass:[BabysittingModel class]]){ 
        presentViewController = [[PBSListingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
    }else if ([object isKindOfClass:[EventModel class]]){ 
        presentViewController = [[PEListingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
    } 
    presentViewController.item = object; 
    presentViewController.hidesBottomBarWhenPushed = YES; 
    presentViewController.delegate = self;
    presentViewController.cancelListingBlock = ^(id object) {
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:object];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:presentViewController animated:YES];
}

- (void)booking:(BookingModel *)booking atIndex:(NSInteger)row{
    [self loadPage:0];
}

- (UIImage *)checkAvailableTime:(NSString *)availableTime{
    NSArray *times = [availableTime componentsSeparatedByString:@","];
    
    
    if ([times containsObject:_today]) {
        return BOOKING_IMAGE_STATE(BookingStateRUNNING);
    }  
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:times];
    [tempArr addObject:_today];
    NSArray *array = [tempArr sortedArrayUsingSelector:@selector(compare:)];  
    NSInteger index = [array indexOfObject:_today];
  //  NSLog(@"array:%@,index=%ld", array,index);  
    if (index >=times.count) {
        
        return BOOKING_IMAGE_STATE(BookingStateCURRENTLY_NOT_RUNNING);
    }
    
    
    return BOOKING_IMAGE_STATE(BookingStateRUNNING);
} 



@end
