//
//  CreateEventVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CreateEventVC.h"
#import "ZPicker.h"
#import "InputInfoVC.h"
#import "UIViewController+GooglePlace.h"

@interface CreateEventVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSArray *_priceSource;
    NSArray *_ageRangeSource;
    
    NSDate *_startDate;
    NSDate *_endDate;
}

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITextField *tfHeadline;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfAboutEvent;
@property (weak, nonatomic) IBOutlet UITextField *tfWhereMeet;
@property (weak, nonatomic) IBOutlet UILabel *lbStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lbEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lbAdult;
@property (weak, nonatomic) IBOutlet UILabel *lbChild;
@property (weak, nonatomic) IBOutlet UILabel *lbConcession;
@property (weak, nonatomic) IBOutlet UITextField *tfMaxAttendees;
@property (weak, nonatomic) IBOutlet UITextField *tfAgeRange;
@property (weak, nonatomic) IBOutlet UILabel *lbAbout;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CreateEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [NSMutableArray array];
    self.event = [[EventModel alloc] init]; 
    
    NSMutableArray *temp1 = [NSMutableArray array];
    for (NSInteger index=100; index>0; index--) {
        [temp1 addObject:[NSString stringWithFormat:@"$%ld",index]];
    }
    [temp1 addObject:@"FREE"];
    
    NSMutableArray *temp2 = [NSMutableArray array];
    NSInteger decimal = 95;
    for (NSInteger index=20; index>0; index--) {
        [temp2 addObject:[NSString stringWithFormat:@".%02ld",decimal]];
        decimal -= 5;
    }
    [temp2 addObject:@""];
    
    _priceSource = @[temp1,temp2];
    
    NSMutableArray *ages = [NSMutableArray array];
    for (NSInteger index=15; index>=4; index--) {
        [ages addObject:[NSString stringWithFormat:@"%ldyrs",index]];
    }
    _ageRangeSource = @[ages,@[@"and under",@"and over"]];
    
    _tfMaxAttendees.delegate = self;
}


- (EventModel *)event{
    _event.listingHeadline = _tfHeadline.text;
    _event.eventDescription = _lbAbout.text;
    _event.maximumAttendees = _tfMaxAttendees.text;
    return _event;
}
#pragma mark - 视图控制器的触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController start touch...");
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (IBAction)editAboutEvent:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    __weak typeof(self) weakSelf = self;
    InputInfoVC *vc = [[InputInfoVC alloc] init]; 
    vc.careType = AboutContentTypeCreateEvent;
    vc.contentTitle = @"About your Event";
    vc.content = self.lbAbout.text;
    vc.inputBlock = ^(NSString *text) {
        NSLog(@"text:%@",text);  
        weakSelf.lbAbout.text = text;
        weakSelf.event.eventDescription = text;
    };
    [self.navigationController pushViewController:vc animated:NO];
}
- (IBAction)modifyStartTime:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    
    [ZPicker showDateAndTimePickerTitle:@"Choose Date & Time" 
                                minDate:[NSDate date] 
                                maxDate:_endDate 
                                   done:^(id object, NSDate *one, NSDate *two) {
                                       weakSelf.lbStartTime.text = object;
                                       weakSelf.event.startDate = [Util yyyyMMddHHmmss:one];
                                       
                                       _startDate = one;
                                       
                                   }];
    
}
- (IBAction)modifyEndTime:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ZPicker showDateAndTimePickerTitle:@"Choose Date & Time" 
                                minDate:_startDate 
                                maxDate:nil 
                                   done:^(id object, NSDate *one, NSDate *two) {
                                       weakSelf.lbEndTime.text = object;
                                       weakSelf.event.endDate = [Util yyyyMMddHHmmss:one];
                                       
                                       _endDate = one;
                                       
                                   }];
}
- (IBAction)modifyAdult:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ZPicker showPickerTitle:@"Select Pricing" 
                  dataSource:_priceSource 
                  pickerType:ZPickerTypePrice 
                        done:^(id object) {
                            weakSelf.lbAdult.text = object;
                            weakSelf.event.adult = object;
                        }];
}
- (IBAction)modifyPrice:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ZPicker showPickerTitle:@"Select Pricing" 
                  dataSource:_priceSource 
                  pickerType:ZPickerTypePrice 
                        done:^(id object) {
                            weakSelf.lbChild.text = object;
                            weakSelf.event.child = object;
                        }];
}
- (IBAction)modifyConcession:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ZPicker showPickerTitle:@"Select Pricing" 
                  dataSource:_priceSource 
                  pickerType:ZPickerTypePrice 
                        done:^(id object) {
                            weakSelf.lbConcession.text = object;
                            weakSelf.event.concession = object;
                        }];
}

- (IBAction)modifyMaxAttendees:(id)sender {
    //    __weak typeof(self) weakSelf = self;
    //    [ZPicker showPickerTitle:@"" dataSource:@[] done:^(id object) {
    //        
    //    }];
}
- (IBAction)modifyAgeRange:(id)sender {
    __weak typeof(self) weakSelf = self;
    [ZPicker showPickerTitle:@"" 
                  dataSource:_ageRangeSource 
                  pickerType:ZPickerTypeAgeRange 
                        done:^(id object) {
                            weakSelf.tfAgeRange.text = object;
                            weakSelf.event.ageRange = object;
                        }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"place_cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];   
        cell.textLabel.font = TX_BOLD_FONT(16);
        cell.detailTextLabel.font = TX_FONT(13);
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = dict[@"PrimaryText"];
    cell.detailTextLabel.text = dict[@"FullText"]; 
    cell.imageView.image = [UIImage imageNamed:@"location-icon-blue"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    _tfAddress.text = dict[@"FullText"];
    _tableView.hidden = YES;
    self.event.address = dict[@"FullText"];
}
- (GMSPlacesClient*)placesClient { 
    if (!_placesClient) { 
        _placesClient = [[GMSPlacesClient alloc]init];
    } 
    return _placesClient;
}


- (IBAction)addressDetail:(id)sender {
    [self GMSAutocompleteFilterType:kGMSPlacesAutocompleteTypeFilterNoFilter address:^(NSString *address, CLLocationCoordinate2D coordinate) {
        
        _lbAddress.hidden = NO; 
        _lbAddress.text = [address componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
        _event.address = address;
        _event.addressDetail =address;
        _event.addressLat = coordinate.latitude;
        _event.addressLon = coordinate.longitude;
    }];
}

- (IBAction)whereToMeetDetail:(id)sender {
    [self GMSAutocompleteFilterType:kGMSPlacesAutocompleteTypeFilterNoFilter address:^(NSString *address, CLLocationCoordinate2D coordinate) {
        
        _tfWhereMeet.text = [address componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
        _event.whereToMeet = address;
        _event.whereToMeetDetail =address;
        _event.whereToMeetLat = coordinate.latitude;
        _event.whereToMeetLon = coordinate.longitude;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"0"] && [textField.text isEqualToString:@""]) {
        textField.text = @"";
        return NO;
    }
    
    if(textField.text.length>2 && string.length>0){
        return NO;
    }else {
        return YES;
    }
}

@end

