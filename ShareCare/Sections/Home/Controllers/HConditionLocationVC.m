//
//  HConditionLocationVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/10.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HConditionLocationVC.h"
#import "UIViewController+GooglePlace.h"

#define CUSTOM_SEARCHBAR_HEIGHT 93
@interface HConditionLocationVC ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate>{
    BOOL shouldShowSearchResults;
    __weak IBOutlet UILabel *_locationLabel;
    CGFloat _keyboardHeight;
    CLLocationCoordinate2D _coodinate;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *searchBar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSMutableArray * locationArray; 
@property (nonatomic, strong) NSMutableArray * filteredArray;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, retain) GMSPlacesClient *placesClient;

@end

@implementation HConditionLocationVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (_locationLabel.text.length) {
//        [self.delegate conditionLocationAddress:_locationLabel.text lat:0 lon:0];
//    }
    [SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self currentAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
        _coodinate = coordinate;
        _locationLabel.text = address;
    }];
}
 
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 80)];
        UIImageView *ic = [[UIImageView alloc] initWithFrame:CGRectMake(18, 19, 22, 22)];
        ic.image = [UIImage imageNamed:@"location-icon-blue"];
        [_headerView addSubview:ic];
        
        UIButton *nearbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nearbyBtn.frame = CGRectMake(54, 0, 200, 60);
        [nearbyBtn setTitle:@"Nearby" forState:UIControlStateNormal];
        [nearbyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        nearbyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        nearbyBtn.titleLabel.font = TX_BOLD_FONT(16);
        [nearbyBtn addTarget:self action:@selector(selectedNearby:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:nearbyBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 60, 200, 20)];
        label.textColor = TX_RGB(112, 112, 112);
        label.font = TX_BOLD_FONT(15);
        label.text = @"RECENT SEARCHES";
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // _tableView.backgroundColor = [UIColor clearColor]; 
    [self.view addSubview:_tableView];
    
    _tableView.frame = CGRectMake(0, self.searchBar.frame.size.height, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-SYSTEM_NAVIGATIONBAR_HEIGHT);
    _tableView.alpha = 0;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self headerView];
    self.locationArray = [NSMutableArray arrayWithArray:[self locationHistory]];
   // self.view.backgroundColor = [UIColor clearColor];
  //  [self configureSearchController];
    
    [self.view addSubview:self.shadowView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:_tableView];
    
    _coodinate =CLLocationCoordinate2DMake(kUSER_COORDINATE_LATITUDE, kUSER_COORDINATE_LONGITUDE);
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{}
 
- (NSMutableArray *)locationArray {
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[];
    }
    return _titleArray;
}

- (UIView *)searchBar{
    if (!_searchBar) {
         
        _searchBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0-CUSTOM_SEARCHBAR_HEIGHT*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, CUSTOM_SEARCHBAR_HEIGHT*TX_SCREEN_OFFSET)];
        _searchBar.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20+(CUSTOM_SEARCHBAR_HEIGHT-44-20)/2, TX_SCREEN_WIDTH-30,44*TX_SCREEN_OFFSET)];
        imageView.image = [UIImage imageNamed:@"search-bar"]; 
        [_searchBar addSubview:imageView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+40, CGRectGetMinY(imageView.frame), TX_SCREEN_WIDTH-30-40-80, 44)];
        [_textField setAutocorrectionType:UITextAutocorrectionTypeNo]; 
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone]; 
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChangedValue:) forControlEvents:UIControlEventEditingChanged];
        [_searchBar addSubview:_textField];

        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(TX_SCREEN_WIDTH-100, 20+(CUSTOM_SEARCHBAR_HEIGHT-44-20)/2, 100, 44)];
        [cancelBtn addTarget:self action:@selector(searchCanceled:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBar addSubview:cancelBtn];
 }       
            
    return _searchBar;

}

- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0;
    }
    return _shadowView;
}

- (GMSPlacesClient*)placesClient { 
    if (!_placesClient) { 
        _placesClient = [[GMSPlacesClient alloc]init];
    } 
    return _placesClient;
}
- (void)configureSearchController {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"";
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
}
- (IBAction)inputTextAction:(id)sender {
    
    [self.textField becomeFirstResponder];
    self.navigationController.navigationBarHidden = YES;
    _tableView.frame = CGRectMake(0, CUSTOM_SEARCHBAR_HEIGHT*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-CUSTOM_SEARCHBAR_HEIGHT);
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.searchBar.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, CUSTOM_SEARCHBAR_HEIGHT*TX_SCREEN_OFFSET);
        self.shadowView.alpha = 0.3;
        _tableView.alpha = 1;
    }];
    
    
}
- (void)searchCanceled:(id)sender{
    [self.textField resignFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.searchBar.frame = CGRectMake(0, 0-CUSTOM_SEARCHBAR_HEIGHT*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, CUSTOM_SEARCHBAR_HEIGHT*TX_SCREEN_OFFSET);
        self.shadowView.alpha = 0;
        _tableView.alpha = 0;
    }];
}

- (void)textFieldDidChangedValue:(UITextField *)textField{
    [self requestGooglePlaceForKey:textField.text];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    shouldShowSearchResults = YES;
    [self.tableView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    shouldShowSearchResults = NO;
    
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.tableView.alpha = 0; 
        _searchController.searchBar.alpha = 0;
    }completion:^(BOOL finished) {
        self.tableView.frame = CGRectMake(0, SYSTEM_NAVIGATIONBAR_HEIGHT, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-SYSTEM_NAVIGATIONBAR_HEIGHT);
    }];
    
    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (!shouldShowSearchResults) {
        shouldShowSearchResults = YES;
        [self.tableView reloadData];
    }
    [self.searchController.searchBar resignFirstResponder];
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString * searchString = searchController.searchBar.text; 
    [self requestGooglePlaceForKey:searchString];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   self.locationArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"place_cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];   
        cell.textLabel.font = TX_BOLD_FONT(16);
        cell.detailTextLabel.font = TX_FONT(13);
        cell.detailTextLabel.numberOfLines = 2;
    }
     
    NSDictionary *dict = self.locationArray[indexPath.row];
    cell.textLabel.text = dict[@"PrimaryText"];
    cell.detailTextLabel.text = dict[@"FullText"]; 
    cell.imageView.image = self.textField.text.length?[UIImage imageNamed:@"location-icon-blue"]:[UIImage imageNamed:@"clock"];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.locationArray[indexPath.row]; 
    _locationLabel.text  = dict[@"PrimaryText"];
    
    
    if ([[dict allKeys] containsObject:@"lat"]) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate conditionLocationAddress:dict[@"PrimaryText"] 
                                                lat:[dict[@"lat"] doubleValue]
                                                lon:[dict[@"lon"] doubleValue]];
    }else{
         [SVProgressHUD showWithStatus:TEXT_LOADING];
         [self lookUpPlace: dict];  
    }
   

   
}

#pragma mark - UIbutton Action
- (IBAction)selectedAnywhere:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate conditionLocationAnywhere];
}
- (IBAction)selectedNearby:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate conditionLocationNearby];
}



#pragma mark - google place delegate
- (void)requestGooglePlaceForKey:(NSString *)key{
    
    if (key.length == 0) {
        [self.locationArray removeAllObjects];
        self.tableView.tableHeaderView = [self headerView];
        self.locationArray = [NSMutableArray arrayWithArray:[self locationHistory]];
       // [self.locationArray removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    //测试
    
    self.tableView.tableHeaderView = [UIView new];
    [self.locationArray removeAllObjects];
    [self.tableView reloadData];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    filter.country = GOOGLE_PLACE_COUNTRY;
    [self.placesClient autocompleteQuery:key
                                  bounds:nil
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                     
                                    
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        return;
                                    }
                                     
                                    [self.locationArray removeAllObjects];
                                    
                                    for (GMSAutocompletePrediction* result in results) {
                                         
                                        NSLog(@"___________________________________");
                                        NSLog(@"%@",result.attributedFullText.string);
                                        NSLog(@"%@",result.attributedSecondaryText.string);
                                        NSLog(@"%@",result.attributedPrimaryText.string);
                                        [self.locationArray addObject:@{@"placeId":result.placeID,
                                                                        @"PrimaryText":result.attributedPrimaryText.string,
                                                                        @"FullText":result.attributedFullText.string}];
                                        
                                        
                                    }
                                    
                                     [self.tableView reloadData];
                                }];

}

- (void)lookUpPlace:(NSDictionary *)location{
  //  NSString *placeID = @"ChIJV4k8_9UodTERU5KXbkYpSYs";
    
    
    __weak typeof(self) weakSelf= self;
    
    [_placesClient lookUpPlaceID:location[@"placeId"] callback:^(GMSPlace *place, NSError *error) {
       
        CLLocationCoordinate2D tempCoordinate = CLLocationCoordinate2DMake(0, 0);
        NSString *address = @"";
        if (place != nil) {
            NSLog(@"Place name %@", place.name); 
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place placeID %@", place.placeID);
            NSLog(@"Place attributions %@", place.attributions);
            NSLog(@"Place coordinate (%f,%f)", place.coordinate.latitude,place.coordinate.longitude);
            
            tempCoordinate = place.coordinate;
            
            
            for (GMSAddressComponent *component in place.addressComponents) {
                NSLog(@"%@   %@",component.type,component.name);
                
                if ([component.type isEqualToString:@"street_number"]) {
                    address = [NSString stringWithFormat:@"%@",component.name]; 
                }
                if ([component.type isEqualToString:@"route"]) {
                    address = [NSString stringWithFormat:@"%@ %@",address,component.name]; 
                }
                
                if ([component.type isEqualToString:@"locality"] && address.length==0) {
                    address = [NSString stringWithFormat:@"%@ %@",address,component.name]; 
                }
            }
            
            
        } else {
            NSLog(@"No place details");
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:location];
        [dic setObject:[NSString stringWithFormat:@"%f",tempCoordinate.latitude] forKey:@"lat"];
        [dic setObject:[NSString stringWithFormat:@"%f",tempCoordinate.longitude] forKey:@"lon"];
        [weakSelf save:dic];
        
        [weakSelf.navigationController popViewControllerAnimated:NO];
        [weakSelf.delegate conditionLocationAddress:address 
                                                lat:tempCoordinate.latitude 
                                                lon:tempCoordinate.longitude];
    }];
}

//搜索记录
- (void)save:(NSDictionary *)location{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"location.plist"]; 
    
    NSMutableSet *set = [NSMutableSet setWithArray:[self locationHistory]];
    [set addObject:location]; 
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[set allObjects]];
    
    if (![[[array reverseObjectEnumerator] allObjects] writeToFile:plistPath atomically:YES]) {
        NSLog(@"历史数据保存失败");
    }
} 
- (NSArray *)locationHistory{ 
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"location.plist"]; 
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    return array?[[array reverseObjectEnumerator] allObjects]:@[];
}
@end
