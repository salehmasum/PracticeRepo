//
//  EventWhosComingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/3.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventWhosComingVC.h"
#import "ProfileModel.h"
#import "ChildrenModel.h"
#import "EditChildrenVC.h"
#import "EventReviewBookingVC.h"
@interface EventWhosComingVC (){
}

@end

@implementation EventWhosComingVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]]; 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.plusBtn.hidden = YES;
    _childrens = [NSMutableSet set];
   
    [self initUI];
} 

- (void)initUI{
    self.lbLocation.text = [self dateAndTime];//[NSString stringWithFormat:@"Hosted by %@",((EventModel *)self.item).userName];
    
    [self.requestBtn setImage:[UIImage imageNamed:@"join-group-button"] forState:UIControlStateNormal];
    [self.requestBtn setImage:[UIImage imageNamed:@"join-group-button-disabled"] forState:UIControlStateDisabled]; 
    
    
    self.lbPrice.attributedText = [self attributedStringFrom:self.desc];
}


- (NSString *)dateAndTime{
    if ([((EventModel *)self.item).startDateStr containsString:@" • "] && [((EventModel *)self.item).endDateStr containsString:@" • "] ) {
        NSString *endStr = [((EventModel *)self.item).endDateStr componentsSeparatedByString:@" • "][1]; 
        return [NSString stringWithFormat:@"%@-%@",((EventModel *)self.item).startDateStr,endStr];
    }
    
    return [NSString stringWithFormat:@"%@-%@",((EventModel *)self.item).startDateStr,((EventModel *)self.item).endDateStr];
}
- (NSString *)priceStr{
    return ((EventModel *)self.item).listingHeadline;
}
- (NSString *)locationStr{
    return ((EventModel *)self.item).listingHeadline;
}
- (NSString *)desc{ 
    return [NSString stringWithFormat:@"%@ %@",((EventModel *)self.item).listingHeadline,((EventModel *)self.item).ageRange];
}
- (NSMutableAttributedString *)attributedStringFrom:(NSString *)str{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:((EventModel *)self.item).listingHeadline];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(16)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:@"$"];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(14)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:((EventModel *)self.item).ageRange];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(13)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TX_RGB(136, 136, 136)
                    range:range];
    return attrStr;
}

-(void)requestBookingChild
{
    EventModel *eventModel = (EventModel *)(self.item);
    __weak typeof(self) weakself = self;
    NSArray *array = @[self.booking.startDate,
                       self.booking.endDate]; 
    NSDictionary *dic = @{@"listingId":eventModel.idValue,
                          @"listingType":@"2",
                          @"startDate":self.booking.startDate,
                          @"endDate":self.booking.endDate
                          };
    [ShareCareHttp POST:@"/v1/booking/me/children/list" withParaments:dic withSuccessBlock:^(id response) {
        
         
        NSMutableArray *temp = [NSMutableArray array];
        //USERDEFAULT_SET(@"userName", model.fullName.length?model.fullName:response[@"userName"]);
         
        {
            //添加自己
            ChildrenModel *child = [[ChildrenModel alloc] init];
            child.fullName = kUSER_USERNAME;
            child.childIconPath = kUSER_USERICON;
            child.timePeriod = self.booking.timePeriod; 
            [temp addObject:child];
            [_childrens addObject:child];
        }
        
        
        for (NSDictionary *dic in response) { 
            ChildrenModel *child = [ChildrenModel modelWithDictionary:dic];
            child.timePeriod = self.booking.timePeriod;
            
            if (child.childStatus.integerValue == ChildStateConfirmed || child.childStatus.integerValue == ChildStateBusy) {
                child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateBusy];
            }else{
                NSInteger ageValue = [[child.age componentsSeparatedByString:@"yrs"].firstObject integerValue];
                if (![self vailableAge:ageValue withRangeStr:eventModel.ageRange]) {
                    
                    child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateCheckAgeRange];
                }else{
                    
                    child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateAvailable];
                }
            }
             
            [temp addObject:child];
        }
        if (temp.count == 0) {
        //    [self addChildren];
        }
        
        weakself.dataSource = temp;
        [weakself.tableView reloadData];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
    }];
}
- (BOOL)vailableAge:(NSInteger)age withRangeStr:(NSString *)ageRange{
     
    NSInteger rangeAge = [[[ageRange componentsSeparatedByString:@"yrs"] firstObject] integerValue];
    
    if ([ageRange containsString:@"over"] && age>=rangeAge) {
        return YES;
    }
    
    if ([ageRange containsString:@"under"] && age<=rangeAge) {
        return YES;
    }
    
    return NO;
}

- (void)addChildren{
    NewChildrenTableVC *childrenVC = [[NewChildrenTableVC alloc] initWithStyle:UITableViewStyleGrouped];
    childrenVC.childrens = [NSMutableArray array];
    [self.navigationController pushViewController:childrenVC animated:YES];
}
//- (void)addChild{
//    __block typeof(self) weakeSelf = self;
//    EditChildrenVC *editChildrenVC = [[EditChildrenVC alloc] init];
//    editChildrenVC.childBlock = ^(ChildrenModel *child) {
////        [weakeSelf.childrens addObject:child];
////        [weakeSelf.tableView reloadData];
//    };
//    [self.navigationController pushViewController:editChildrenVC animated:YES];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                           forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    ChildrenModel *children = self.dataSource[indexPath.row];
    children.isMyChild = YES;
    cell.child = children;
    cell.lbAge.text = children.fullName;
    cell.minBtn.userInteractionEnabled = NO;
    cell.minBtn.hidden = ![_childrens containsObject:children];
    [cell.minBtn setImage:[UIImage imageNamed:@"tick"] forState:UIControlStateNormal];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row) {
        //event预定，父母必须参加，且不能取消
        ChildrenModel *child = self.dataSource[indexPath.row]; 
        if (child.state ==ChildStateAvailable) { 
            WhosComingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([_childrens containsObject:self.dataSource[indexPath.row]]) {
                cell.minBtn.hidden = YES; 
                
                [_childrens removeObject:self.dataSource[indexPath.row]];
            }else{
                
                if (self.booking.remainingPlace>_childrens.count) {
                    cell.minBtn.hidden = NO;
                    ChildrenModel *child = self.dataSource[indexPath.row]; 
                    [_childrens addObject:child];
                }
            }
            self.requestBtn.enabled = _childrens.count>1;
            
            
        }
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (IBAction)requestToBook:(id)sender {
    if ([_childrens containsObject:self.dataSource[0]]) {
        self.booking.adultPrice = ((EventModel *)self.item).adult;
    }else{
        self.booking.adultPrice = @"0";
    }
    self.booking.whoIsComings = [_childrens allObjects];
    self.booking.peopleNums = [NSString stringWithFormat:@"%ld",_childrens.count];
    if ([((EventModel *)self.item).child floatValue]==0 && [self.booking.adultPrice floatValue]==0) {
        
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your event attendance has been confirmed." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            [weakSelf sendRequest];
        }];
        [alertController addAction:CancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self showReviewBooking];
    }
    
}

- (void)sendRequest{
    __weak typeof(self) weakself = self; 
    NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.booking convertToDictionary]];
    
    
    NSString *startDate = dic[@"startDate"];
    NSString *endDate = dic[@"endDate"];
    [dic setObject:[startDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] forKey:@"startDate"];
    [dic setObject:[endDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] forKey:@"endDate"];
   // NSDictionary *dic= [self.booking convertToDictionary];
    NSLog(@"%@",dic);//return;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    [ShareCareHttp POST:API_BOOKING_APPOINT withParaments:dic withSuccessBlock:^(id response) { 
        NSLog(@"%@",response);
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [weakself.navigationController popToRootViewControllerAnimated:YES]; 
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
    }];
    
}

- (void)showReviewBooking{
    EventReviewBookingVC *bookingDetail=[[EventReviewBookingVC alloc] initWithNibName:@"ReviewBookingVC" bundle:nil];
    bookingDetail.item = self.item;
    bookingDetail.booking = self.booking;
    [self.navigationController pushViewController:bookingDetail animated:YES];
}

@end
