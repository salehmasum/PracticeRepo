//
//  CreateShareCareVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CreateShareCareVC.h"
#import "CreateShareCareInfoCell.h"
#import "createShareCareCalendarCell.h"
#import "InputInfoVC.h"
@interface CreateShareCareVC (){
    NSMutableArray *_selectedDays;
    NSMutableDictionary *_parameter;
    NSString *_elecareAddress;
}

@end

@implementation CreateShareCareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CreateShareCareInfoCell class]) bundle:nil ] forCellReuseIdentifier:@"createsharecare"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([createShareCareCalendarCell class]) bundle:nil ] forCellReuseIdentifier:@"createsharecarecalendar"];
    
    _elecareAddress = @"";
    _parameter = [NSMutableDictionary dictionary];
    _selectedDays = [NSMutableArray array];
    
}
- (SourceType)sourceType{
    return SourceTypeCameraOrPhotoLibrary;
}
- (NSString *)actionsheetTitle{
    return @"Upload 5 photos of your EleCare Home";
}
#pragma mark - request


- (void)save:(id)sender{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    CreateShareCareInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDictionary *dic = @{@"address": _elecareAddress,
                          @"availableTime": [_selectedDays componentsJoinedByString:@","],
                          @"childrenNums": [NSNumber numberWithInteger:cell.childrens],
                          @"headline": cell.tfHeadline.text,
                          @"moneyPerDay": cell.tfPerday.text,
                          @"photosPerDay": cell.tfPhotoCount.text,
                          @"shareCareContent": cell.lbAbout.text,
                          @"addressLat": [NSString stringWithFormat:@"%.6f",cell.lat],
                          @"addressLon": [NSString stringWithFormat:@"%.6f",cell.lon],
                          @"babyAgeRange":[Util convertToJSONStringFrom:[cell.ageRangeModel convertToDictionary]],
                          @"credentials":[Util convertToJSONStringFrom:[cell.credentialsModel convertToDictionary]],
                          @"shareCareStatus":@"4"
                          };
    
    NSLog(@"%@",dic);
    if ([self checkAvilibity:dic]){ 
        
        [ShareCareHttp upload:API_SHARECARE_SAVE withParaments:dic photos:self.photos uploadProgressBlock:^(float progress) {
            NSLog(@"%f",progress);
            [SVProgressHUD showProgress:progress];
        } withSuccessBlock:^(id response) {
            
            SET_AUTOM_REFRESH_HOME(0, YES); 
            [SVProgressHUD showSuccessWithStatus:@"Create successed"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } withFailureBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
    
}


- (void)saveTest:(id)sender{
    
    if (self.requestIndex < self.photos.count) {
        
        
        NSString *content = CONTENT_TERMS_AND_CONDITINONS;
        
        NSMutableArray *mutabArr = [NSMutableArray array];
        NSInteger count = arc4random()%6+30;
        for (NSInteger index= 0; index<count; index++) {
            [mutabArr addObject:[NSString stringWithFormat:@"2018-%02u-%02u",arc4random()%5+4,arc4random()%27+1]];
        }
        //[NSString stringWithFormat:@"%.2f",(arc4random()%1000+100)/100.0]
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        CreateShareCareInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSDictionary *dic = @{@"address": @"Xi'an, Shaanxi Province, China.",
                              @"availableTime": [mutabArr componentsJoinedByString:@","],
                              @"childrenNums": @"3",
                              @"headline": [NSString stringWithFormat:@"EleCare %@",[content substringWithRange:NSMakeRange(arc4random()%100+100, 30)]],
                              @"moneyPerDay": @"0.01",
                              @"photosPerDay": [NSString stringWithFormat:@"%d",arc4random()%4+2],
                              @"shareCareContent": [NSString stringWithFormat:@"%@",[content substringWithRange:NSMakeRange(arc4random()%300, arc4random()%500+500)]],
                              @"addressLat": [NSString stringWithFormat:@"32.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10],
                              @"addressLon": [NSString stringWithFormat:@"108.%d%d%d%d%d%d",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10],
                              @"babyAgeRange":[Util convertToJSONStringFrom:[cell.ageRangeModel convertToDictionary]],
                              @"credentials":[Util convertToJSONStringFrom:[cell.credentialsModel convertToDictionary]],
                              @"shareCareStatus":@"4"
                              };
        
        NSLog(@"%@",dic); 
        
        
        if ([self checkAvilibity:dic]){ 
            
            NSArray *testPhotoArr = @[self.photos[self.requestIndex]];
            [ShareCareHttp upload:API_SHARECARE_SAVE withParaments:dic photos:testPhotoArr uploadProgressBlock:^(float progress) {
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
                
                SET_AUTOM_REFRESH_HOME(0, YES);
                
            } withFailureBlock:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }
        
        
    }
    
}



- (BOOL)checkAvilibity:(NSDictionary *)parameter{
    if (self.photos.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please Take/Choose photos!"];return NO;
    }
    if (![parameter[@"headline"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Listing Headline!"];return NO;
    }
    if (![parameter[@"address"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid address!"];return NO;
    }
    if (![parameter[@"shareCareContent"] length]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid About your ShareCare!"];return NO;
    }
    if (![parameter[@"moneyPerDay"] length]) {
        [SVProgressHUD showErrorWithStatus:@"How much charge per day?"];return NO;
    }
    if (![parameter[@"photosPerDay"] length] || ![parameter[@"photosPerDay"] integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"How many photos per day?"];return NO;
    } 
    
    
    CreateShareCareInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.ageRangeModel.age0_1 ==NO  &&
        cell.ageRangeModel.age1_2 ==NO  &&
        cell.ageRangeModel.age2_3 ==NO  &&
        cell.ageRangeModel.age3_5 ==NO  &&
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
    
    if (_selectedDays.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"Set up Availability!"];return NO;
    }
    return YES;
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 1148*TX_SCREEN_OFFSET;
    }
    return 330*1*TX_SCREEN_OFFSET;//TX_SCREEN_HEIGHT-SYSTEM_NAVIGATIONBAR_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        __weak typeof(self) weakSelf = self;
        CreateShareCareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createsharecare" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.editAboutBlock = ^{
            [weakSelf editAbout];
        };
        cell.addressBlock = ^(NSString *text) {
            [weakSelf requestGooglePlaceForKey:text];
        };
        cell.addressEditStateBlock = ^(BOOL begin) {
            if (begin) {
                weakSelf.offset_x = [NSString stringWithFormat:@"%f",280*TX_SCREEN_OFFSET]; 
               
            }else{
                weakSelf.offset_x = [NSString stringWithFormat:@"%f",120*TX_SCREEN_OFFSET];
            }
        };
        return cell;
    }else{
        
        createShareCareCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"createsharecarecalendar" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectedDayBlock = ^(NSString *day) {
            [_selectedDays addObject:day];
        };
        cell.deSelectedDayBlock = ^(NSString *day) {
            [_selectedDays removeObject:day];
        };
        
        return cell;
    } 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

- (void)editAbout{
    CreateShareCareInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    InputInfoVC *vc = [[InputInfoVC alloc] init]; 
    vc.careType = AboutContentTypeCreateShareCare;
    vc.contentTitle = @"About your EleCare";
    vc.content = cell.lbAbout.text;
    vc.inputBlock = ^(NSString *text) {
        NSLog(@"text:%@",text);  
        cell.lbAbout.text = text;
    };
    [self.navigationController pushViewController:vc animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

- (GMSPlacesClient*)placesClient { 
    if (!_placesClient) { 
        _placesClient = [[GMSPlacesClient alloc]init];
    } 
    return _placesClient;
}
- (NSMutableArray *)locationArray {
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}
#pragma mark - google place delegate
- (void)requestGooglePlaceForKey:(NSString *)key{ 
    CreateShareCareInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
   
    [self GMSAutocompleteAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
        _elecareAddress = address;
        cell.lbAddress.hidden = NO; 
        cell.lbAddress.text =  [address componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
        
        cell.lat = coordinate.latitude;//[NSString stringWithFormat:@"%f",coordinate.latitude];
        cell.lon = coordinate.longitude;//[NSString stringWithFormat:@"%f",coordinate.longitude];
    }];
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
