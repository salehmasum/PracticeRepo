//
//  BabysittingWhosComingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/8.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BabysittingWhosComingVC.h"
#import "BabysittingReviewBookingVC.h"
#import "ProfileModel.h"
@interface BabysittingWhosComingVC ()

@end

@implementation BabysittingWhosComingVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self initUI];
} 

- (void)initUI{
    self.lbTitle.text = @"Who is the booking for?";
    [self.requestBtn setImage:[UIImage imageNamed:@"next-enabled"] forState:UIControlStateNormal];
    [self.requestBtn setImage:[UIImage imageNamed:@"next-disabled"] forState:UIControlStateDisabled]; 
    self.lbLocation.text = [NSString stringWithFormat:@"Hosted by %@",((BabysittingModel *)self.item).userName];
    
    if ([((BabysittingModel *)self.item) respondsToSelector:@selector(chargePerHour)]) { 
        self.lbPrice.text = [NSString stringWithFormat:@"$%@/hr",((BabysittingModel *)self.item).chargePerHour];
    }
}


- (void)requestBookingChild{
    __weak typeof(self) weakself = self;  
    NSArray *array = @[self.booking.startDate,
                       self.booking.endDate]; 
    
    BabysittingModel *model = (BabysittingModel *)self.item;
    NSDictionary *dic = @{@"listingId":model.idValue,
                          @"listingType":@"1",
                          @"startDate":self.booking.startDate,
                          @"endDate":self.booking.endDate
                          };
    [ShareCareHttp POST:@"/v1/booking/me/children/list" withParaments:dic withSuccessBlock:^(id response) {
        
         
        NSMutableArray *temp = [NSMutableArray array];
        
        for (NSDictionary *dic in response) { 
            ChildrenModel *child = [ChildrenModel modelWithDictionary:dic]; 
            if (child.childStatus.integerValue == ChildStateConfirmed || child.childStatus.integerValue == ChildStateBusy) {
                child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateBusy];
            }else{
                NSInteger ageValue = [[child.age componentsSeparatedByString:@"yrs"].firstObject integerValue];
                if (![self vailableAge:ageValue withRange:model.babyAgeRangeModel]) {
                    
                    child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateCheckAgeRange];
                }else{
                    
                    child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateAvailable];
                }
            }
            [temp addObject:child];
        }
        weakself.dataSource = temp;
        [weakself.tableView reloadData];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
    }];
}

- (BOOL)vailableAge:(NSInteger)age withRange:(AgeRangeModel *)ageRange{
    if (ageRange.age0_1 && age<=1) {
        return YES;
    }
    if (ageRange.age1_2 && age>=1 && age<=2) {
        return YES;
    } 
    if (ageRange.age2_3 && age>=2 && age<=3) {
        return YES;
    } 
    if (ageRange.age3_5 && age>=3 && age<=5) {
        return YES;
    } 
    if (ageRange.age5 && age>=5) {
        return YES;
    }  
    return NO;
}

- (NSString *)dateAndTime{ 
    return [NSString stringWithFormat:@"Hosted by %@",((BabysittingModel *)self.item).userName];
}

- (NSString *)priceStr{
    return [NSString stringWithFormat:@"%@/hr",((BabysittingModel *)self.item).chargePerHour];;
}
- (NSString *)locationStr{
    return ((BabysittingModel *)self.item).headLine;
}
- (NSString *)desc{
    return [NSString stringWithFormat:@"%@ %@",((BabysittingModel *)self.item).chargePerHour,((BabysittingModel *)self.item).headLine];
}
- (IBAction)requestToBook:(id)sender {
    
    NSMutableArray *temp = [NSMutableArray array];
    for (ChildrenModel *child in [self.childrens allObjects]) {
        child.timePeriod=self.booking.timePeriod;
        [temp addObject:child];
    }
    
    self.booking.whoIsComings = temp;
  //  self.booking.stayDays = @"1";
    
    BabysittingReviewBookingVC *bookingDetail=[[BabysittingReviewBookingVC alloc] initWithNibName:@"ReviewBookingVC" bundle:nil];
    bookingDetail.item = self.item;
    bookingDetail.booking = self.booking;
    [self.navigationController pushViewController:bookingDetail animated:YES];
     
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChildrenModel *child = self.dataSource[indexPath.row];
    
    if (child.state == ChildStateAvailable) { 
    
    WhosComingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.childrens containsObject:child]) {
        cell.minBtn.hidden = YES;
        [self.childrens removeObject:child];
    }else{
        
        cell.minBtn.hidden = NO;
        [self.childrens addObject:child];
    }
    self.requestBtn.enabled = self.childrens.count; 
    }
}
@end
