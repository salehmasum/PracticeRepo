//
//  PBSListingsDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2018/5/15.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "PBSListingsDetailVC.h"
#import "BabysittingModel.h"

@interface PBSListingsDetailVC ()

@property (strong, nonatomic) BabysittingModel *babysitter;
@end

@implementation PBSListingsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem; 
    
}

- (void)loadData:(id)listing{
    
    
    BabysittingModel *model = (BabysittingModel *)listing;
    self.booking = [[BookingModel alloc] init]; 
    self.booking.bookingStatus = model.babysittingStatus;
    self.booking.shareIcon = model.photosPath;
    self.booking.careType = @"1";
    self.booking.totalPrice = model.chargePerHour;
    self.booking.pubUserName = model.userName;
    self.booking.pubUserIcon = model.userIcon;
    self.booking.shareAddress = model.address;
    self.booking.addressLat = model.addressLat;
    self.booking.addressLon = model.addressLon;
    self.booking.typeId = model.idValue;
    [self reloadData];
    
    [self requestBookingChild:[NSString stringWithFormat:@"%@",model.idValue] careType:@"1"];
 //   self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"booking" withString:@"listing"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    if (section == SectionTypeCANCELBOOKING) {
        if (((BabysittingModel *)self.item).babysittingStatus.integerValue==4) {
            return 1;
        }
        return 0;
    }  
   
    return [super tableView:tableView numberOfRowsInSection:section];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

 
@end
