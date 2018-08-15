//
//  CreateBabySittingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CreateBabySittingVC.h"
#import "CreateBabysittingCell.h"
#import "WeekdayCell.h"
#import "WeekdayTimeModel.h"
#import "InputInfoVC.h"
#import <GooglePlaces/GooglePlaces.h>
#import "UIViewController+GooglePlace.h"

@interface CreateBabySittingVC (){
    WeekdayTimeModel *_availableTime;
    BabysittingModel *_babysitting;
    CLLocationCoordinate2D _coodinate;
    
    
}

@end

@implementation CreateBabySittingVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self currentAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
        _coodinate = coordinate;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CreateBabysittingCell class]) bundle:nil ] forCellReuseIdentifier:@"CreateBabysittingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WeekdayCell class]) bundle:nil ] forCellReuseIdentifier:@"WeekdayCell"];
    _babysitting = [[BabysittingModel alloc] init];
    _availableTime =[[WeekdayTimeModel alloc] init];
    _coodinate = CLLocationCoordinate2DMake(kUSER_COORDINATE_LATITUDE, kUSER_COORDINATE_LONGITUDE);
    
    
    self.warninglabel.text = @"This should be a picture of the carer";
   
}
- (SourceType)sourceType{
    return SourceTypePhotoLibrary;
}
- (NSString *)actionsheetTitle{
    return @"Upload a photo that advertises\nyour Babysitting Service";
}

- (void)save:(id)sender{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    CreateBabysittingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary *dic = @{@"accountId":@"",
                          @"createTime":[Util getCurrentTime],
                          @"id":@"",
                          @"photosPath":@"",
                          @"updateTime":[Util getCurrentTime],
                          @"availableTime": [Util convertToJSONStringFrom:[_availableTime convertToDictionary]],
                          @"headLine": cell.tfHeadline.text,
                          @"chargePerHour": cell.tfPerday.text,
                          @"photoNumPerDay": cell.tfPhotoCount.text,
                          @"aboutMe":cell.lbAbout.text,
                          @"credentials":[Util convertToJSONStringFrom:[cell.credentialsModel convertToDictionary]],
                          @"babyAgeClassify":@"",
                          @"babyAgeRange":[Util convertToJSONStringFrom:[cell.ageRangeModel convertToDictionary]],
                          @"addressLon":[NSString stringWithFormat:@"%.6f",_coodinate.longitude],
                          @"addressLat":[NSString stringWithFormat:@"%.6f",_coodinate.latitude],
                          @"babysittingStatus":@"4"
                          };
    
    NSLog(@"%@",dic);//return;
    
    if ([self checkAvilibity:dic]){  
         
        [ShareCareHttp upload:API_BABYSITTING_SAVE withParaments:dic photos:self.photos uploadProgressBlock:^(float progress) {
            NSLog(@"%f",progress);
            [SVProgressHUD showProgress:progress];
        } withSuccessBlock:^(id response) { 
            SET_AUTOM_REFRESH_HOME(1, YES);
            [SVProgressHUD showSuccessWithStatus:@"Create successed"];
            [self.navigationController popViewControllerAnimated:YES];
        } withFailureBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}
- (void)saveTest:(id)sender{ 
    if (self.requestIndex < kMAX_SELECTED_PHOTOS) {
        
        NSString *content = CONTENT_TERMS_AND_CONDITINONS;
 
        
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    CreateBabysittingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary *dic = @{@"availableTime": [Util convertToJSONStringFrom:[_availableTime convertToDictionary]],
                          @"headLine": [NSString stringWithFormat:@"Babysitting %@",[content substringWithRange:NSMakeRange(arc4random()%100+100, 30)]],
                          @"chargePerHour": [NSString stringWithFormat:@"%.2f",(arc4random()%1000+100)/100.0],
                          @"photoNumPerDay": [NSString stringWithFormat:@"%d",arc4random()%4+2],
                          @"aboutMe":[NSString stringWithFormat:@"%@",[content substringWithRange:NSMakeRange(arc4random()%300, arc4random()%500+500)]],
                          @"credentials":[Util convertToJSONStringFrom:[cell.credentialsModel convertToDictionary]],
                          @"babyAgeRange":[Util convertToJSONStringFrom:[cell.ageRangeModel convertToDictionary]],
                          @"addressLon":[NSString stringWithFormat:@"32.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10],
                          @"addressLat":[NSString stringWithFormat:@"108.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10],
                          @"babysittingStatus":@"4"
                          };
    NSLog(@"%@",dic);//return;
    
    if ([self checkAvilibity:dic]){  
        NSArray *testPhotoArr = @[self.photos[self.requestIndex]];
        
        [ShareCareHttp upload:API_BABYSITTING_SAVE withParaments:dic photos:testPhotoArr uploadProgressBlock:^(float progress) {
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
            SET_AUTOM_REFRESH_HOME(1, YES);
        } withFailureBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }}
}

- (BOOL)checkAvilibity:(NSDictionary *)parameter{
    
    if (self.photos.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please Take/Choose photos!"];return NO;
    }
    if (![parameter[@"headLine"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Listing Headline!"];return NO;
    }
    if (![parameter[@"aboutMe"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid About your Babysitting!"];return NO;
    }
    if (![parameter[@"chargePerHour"] length]) {
        [SVProgressHUD showErrorWithStatus:@"How much charge per hour?"];return NO;
    }
    if (![parameter[@"photoNumPerDay"] length] || ![parameter[@"photoNumPerDay"] integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"How many photos per day?"];return NO;
    } 
    
    

    
    CreateBabysittingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.ageRangeModel.age0_1 ==NO &&
        cell.ageRangeModel.age1_2 ==NO &&
        cell.ageRangeModel.age2_3 ==NO &&
        cell.ageRangeModel.age3_5 ==NO &&
        cell.ageRangeModel.age5 ==NO
        ) {
        [SVProgressHUD showErrorWithStatus:@"Select which ages youre able to provide care for"];return NO;
    }
    if (cell.credentialsModel.nonsmoker ==NO &&
        cell.credentialsModel.drivers ==NO &&
        cell.credentialsModel.havecar ==NO &&
        cell.credentialsModel.cleaning ==NO &&
        cell.credentialsModel.anphylaxis ==NO &&
        cell.credentialsModel.firstaid ==NO &&
        cell.credentialsModel.cooking ==NO &&
        cell.credentialsModel.tutoring ==NO
        ) {
        [SVProgressHUD showErrorWithStatus:@"Select your Credentials"];return NO;
    }
    if (_availableTime.mon.length == 0 &&
        _availableTime.tues.length == 0 &&
        _availableTime.wed.length == 0 &&
        _availableTime.thur.length == 0 &&
        _availableTime.fri.length == 0 &&
        _availableTime.sat.length == 0 &&
        _availableTime.sun.length == 0
        ) {
        [SVProgressHUD showErrorWithStatus:@"Set up Availability!"];return NO;
    }
    
    return YES;
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+7;//星期
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        return 36*TX_SCREEN_OFFSET;
    } 
    return 936*1*TX_SCREEN_OFFSET;//TX_SCREEN_HEIGHT-SYSTEM_NAVIGATIONBAR_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
 //   __weak typeof(self) weakSelf = self;
    if (indexPath.row) {
        WeekdayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekdayCell" forIndexPath:indexPath];
        cell.icon.image=[Util weekDayImageAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        return cell;
    }else{
        __weak typeof(self) weakSelf = self;
        CreateBabysittingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreateBabysittingCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.editAboutBlock = ^{
                [weakSelf editAbout];
            };
        //    cell.addressBlock = ^(NSString *text) {
        //        [weakSelf requestGooglePlaceForKey:text];
        //    };
        //    cell.addressEditStateBlock = ^(BOOL begin) {
        //        if (begin) {
        //            weakSelf.offset_x = [NSString stringWithFormat:@"%f",280*TX_SCREEN_OFFSET]; 
        //            
        //        }else{
        //            weakSelf.offset_x = [NSString stringWithFormat:@"%f",120*TX_SCREEN_OFFSET];
        //        }
        //    };
        return cell;
    }
    
}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row) {
        WeekdayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [ZPicker showStartEndDatePickerTitle:@"Time" done:^(id object) {
            NSLog(@"%@",object);
            NSString *desc  = [NSString stringWithFormat:@"%@ - %@",object[@"start"],object[@"end"]];
            cell.lbTime.text = desc;
            [weakSelf resetAvailableTimeAtIndex:indexPath.row string:desc];
        }];
    }
}
- (void)editAbout{
    CreateBabysittingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    InputInfoVC *vc = [[InputInfoVC alloc] init]; 
    vc.careType = AboutContentTypeCreateBabysitting;
    vc.contentTitle = @"About your Babysitting";
    vc.content = cell.lbAbout.text;
    vc.inputBlock = ^(NSString *text) {
        NSLog(@"text:%@",text);  
        cell.lbAbout.text = text;
    };
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)resetAvailableTimeAtIndex:(NSInteger)index string:(NSString *)string{
    switch (index) {
        case 1:
            _availableTime.mon = string;
            break;
        case 2:
            _availableTime.tues = string;
            break;
            
        case 3:
            _availableTime.wed = string;
            break;
            
        case 4:
            _availableTime.thur = string;
            break;
            
        case 5:
            _availableTime.fri = string;
            break;
            
        case 6:
            _availableTime.sat = string;
            break;
            
        case 7:
            _availableTime.sun = string;
            break;
            
            
        default:
            break;
    }
}

@end
