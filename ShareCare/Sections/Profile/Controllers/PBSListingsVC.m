//
//  PBSListingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PBSListingsVC.h"
#import "CreateBabySittingVC.h"
#import "BabysittingModel.h"
#import "UIViewController+Create.h"

@interface PBSListingsVC ()

@end

@implementation PBSListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSString *)headerTitleText{
    return @"You don’t have any listings!";
}
- (NSString *)headerDescText{
    return @"Make money by renting out your extra space on EleCare. You’ll also get to meet amazing parents from around your area! ";
}
- (NSString *)api{
    return API_BABYSITTING_MYSELF_LIST;
}
- (id)convertObjectWithObject:(id)object{
    return [BabysittingModel modelWithDictionary:object];
}
- (void)post:(id)sender{
    
    [self verifyChildrenLicenseForType:1 pass:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpcomingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upcoming" forIndexPath:indexPath];
    
    // Configure the cell...
    
    BabysittingModel *babysitting = self.dataSource[indexPath.row];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(babysitting.thumbnail)] 
                  placeholderImage:kDEFAULT_IMAGE];
     cell.lbCaretype.text = @"Babysitting";
    // cell.lbDate
    cell.lbAddress.text = babysitting.headLine;
    cell.lbTime.text = babysitting.aboutMe;
    cell.lbDate.textAlignment = NSTextAlignmentRight;
    cell.lbDate.text = [NSString stringWithFormat:@"$%@/hr",babysitting.chargePerHour];
    //  [cell configStartDate:sharecare. endDate:sharecare.endDate]; 
    cell.imgState.image = BOOKING_IMAGE_STATE(babysitting.babysittingStatus.integerValue);
    cell.moreButton.hidden = YES;
    return cell;
}
@end
