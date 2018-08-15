//
//  PEListingsDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2018/5/15.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "PEListingsDetailVC.h"
#import "EventModel.h"
@interface PEListingsDetailVC ()

@property (strong, nonatomic) EventModel *event;
@end

@implementation PEListingsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
    
}

- (void)loadData:(id)listing{
    
    EventModel *model = (EventModel *)listing;
    self.booking = [[BookingModel alloc] init]; 
    self.booking.bookingStatus = model.eventStatus;
    self.booking.shareIcon = model.imagePath;
    self.booking.careType = @"2";
    self.booking.totalPrice = @"0";
    self.booking.pubUserName = model.userName;
    self.booking.pubUserIcon = model.userIcon;
    self.booking.shareAddress = model.address;
    self.booking.addressLat = model.addressLat;
    self.booking.addressLon = model.addressLon; 
    self.booking.whereToMeet = model.whereToMeet;
    self.booking.whereToMeetLat = model.whereToMeetLat;
    self.booking.whereToMeetLon = model.whereToMeetLon;
    self.booking.typeId = model.idValue;
    [self reloadData];
    
    [self requestBookingChild:[NSString stringWithFormat:@"%@",model.idValue] careType:@"2"];
   
 //   self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@" attendance" withString:@""];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
    if (section == SectionTypeCANCELBOOKING) {
        return 0;
    }
    if (section == SectionTypeCANCELEVENT) {
        if (((EventModel *)self.item).eventStatus.integerValue==4) {
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
