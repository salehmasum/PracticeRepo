//
//  CreateEventsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CreateEventsVC.h"
#import "CreateEventVC.h"

@interface CreateEventsVC (){
    CreateEventVC *_detail;
}

@end

@implementation CreateEventsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.tableView.tableFooterView = [CreateEventVC new].view;
    
//    self.navigationController.navigationBar.translucent = NO;
//    //  _searchController.hidesNavigationBarDuringPresentation = NO;
//    
//    // This makes the view area include the nav bar even though it is opaque.
//    // Adjust the view placement down.
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    _detail = [CreateEventVC new];
    
    [self addChildViewController:_detail];
    self.tableView.tableFooterView  = _detail.view; 

}
- (SourceType)sourceType{
    return SourceTypePhotoLibrary;
}
- (NSString *)actionsheetTitle{
    return @"Upload a photo that showcases your Event";
}

- (void)save:(id)sender{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _detail.event.eventStatus = @"4";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_detail.event convertToDictionary]];  
    [dic setObject:_detail.event.addressDetail forKey:@"address"];
    [dic setObject:_detail.event.whereToMeetDetail forKey:@"whereToMeet"];
    NSLog(@"%@",dic);//return; 
    if ([self checkAvilibity:dic]){  
        [dic removeObjectForKey:@"imagePath"];
        [ShareCareHttp upload:API_EVENT_SAVE withParaments:dic photos:self.photos uploadProgressBlock:^(float progress) {
            NSLog(@"%f",progress);
            [SVProgressHUD showProgress:progress];
        } withSuccessBlock:^(id response) {
         //   [self submissionSuccessful];
            SET_AUTOM_REFRESH_HOME(2, YES);
            [SVProgressHUD showSuccessWithStatus:@"Create successed"];
             [self.navigationController popViewControllerAnimated:YES];
        } withFailureBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}
- (void)saveTest:(id)sender{
    if (self.requestIndex < kMAX_SELECTED_PHOTOS) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; 
        EventModel *testModel = [[EventModel alloc] init];
        
        NSString *content = CONTENT_TERMS_AND_CONDITINONS;
        testModel.listingHeadline = [NSString stringWithFormat:@"Event %@",[content substringWithRange:NSMakeRange(arc4random()%100+100, 30)]];
        testModel.eventDescription =  [NSString stringWithFormat:@"%@",[content substringWithRange:NSMakeRange(arc4random()%300, arc4random()%500+500)]];
        
        NSString *dateStr = [NSString stringWithFormat:@"2018-%02u-%02u",arc4random()%4+7,arc4random()%27+1];
        testModel.startDate = [NSString stringWithFormat:@"%@T%02u:30:00",dateStr,8+arc4random()%4];
        testModel.endDate =   [NSString stringWithFormat:@"%@T%02u:30:00",dateStr,14+arc4random()%3];
        testModel.adult = @"0";//[NSString stringWithFormat:@"%.2f",(arc4random()%1000+100)/100.0];
        testModel.child = @"0";//[NSString stringWithFormat:@"%.2f",(arc4random()%1000+100)/100.0];
        testModel.concession = @"0";//[NSString stringWithFormat:@"%.2f",(arc4random()%1000+100)/100.0];
        testModel.maximumAttendees = [NSString stringWithFormat:@"%d",arc4random()%20+10];
        testModel.ageRange = [NSString stringWithFormat:@"%dyrs and %@",arc4random()%12+2,arc4random()%2?@"under":@"over"];
        testModel.address = @"Xi'an, Shaanxi Province, China.";
        testModel.whereToMeet = @"Technology Road 37,High-tech District ,Xi'an";
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[testModel convertToDictionary]];
        
        [dic setObject:[NSString stringWithFormat:@"32.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10] forKey:@"addressLat"];
        [dic setObject:[NSString stringWithFormat:@"108.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10] forKey:@"addressLon"];
        
        [dic setObject:[NSString stringWithFormat:@"32.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10] forKey:@"whereToMeetLat"];
        [dic setObject:[NSString stringWithFormat:@"108.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10] forKey:@"whereToMeetLon"];
        [dic setObject:@"4" forKey:@"eventStatus"]; 
        
        NSLog(@"%@",dic);//return; 
        if ([self checkAvilibity:dic]){  
            [dic removeObjectForKey:@"imagePath"];
            NSArray *testPhotoArr = @[self.photos[self.requestIndex]];
            [ShareCareHttp upload:API_EVENT_SAVE withParaments:dic photos:testPhotoArr uploadProgressBlock:^(float progress) {
                NSLog(@"%f",progress);
                [SVProgressHUD showProgress:progress];
            } withSuccessBlock:^(id response) {
                if (self.requestIndex >= kMAX_SELECTED_PHOTOS-1) {
                    [SVProgressHUD showSuccessWithStatus:@"Save successed"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    self.requestIndex++;
                    [self saveTest:nil];
                }
                SET_AUTOM_REFRESH_HOME(2, YES);
            } withFailureBlock:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }}
}



- (BOOL)checkAvilibity:(NSDictionary *)parameter{
    if (self.photos.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please Take/Choose photos!"];return NO;
    }
    if (![parameter[@"address"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Envalid Address"];
    }
    if (![parameter[@"listingHeadline"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Listing Headline!"];return NO;
    }
    if (![parameter[@"startDate"] length] || ![parameter[@"endDate"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Please select date and time!"];return NO;
    } 
    if (![parameter[@"eventDescription"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid About your event!"];return NO;
    }
    if (![parameter[@"ageRange"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Age Range!"];return NO;
    }
    if (![parameter[@"maximumAttendees"] length] || ![parameter[@"maximumAttendees"] integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid maximumAttendees!"];return NO;
    }  
    if (![parameter[@"adult"] length] ||
        ![parameter[@"child"] length] ||
        ![parameter[@"concession"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Price/Admission!"];return NO;
    } 
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
