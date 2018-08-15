//
//  GooglePlaceAddressVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/5.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "GooglePlaceAddressVC.h"

@interface GooglePlaceAddressVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,GMSAutocompleteResultsViewControllerDelegate>{
}


@property (nonatomic, strong) GMSPlacesClient *placesClient;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@end

@implementation GooglePlaceAddressVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataSource = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 250, 50)];
    
    [subView addSubview:self.searchController.searchBar];
    [self.searchController.searchBar sizeToFit];
    [self.view addSubview:subView];
    
    [self performSelector:@selector(searchBarBecomeFirstResponder) withObject:nil afterDelay:0.8];
    
    
    // When UISearchController presents the results view, present it in
    // this view controller, not one further up the chain.
    self.definesPresentationContext = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    // This makes the view area include the nav bar even though it is opaque.
    // Adjust the view placement down.
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
}
- (UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc]
                             initWithSearchResultsController:self.resultsViewController];
        _searchController.searchResultsUpdater = self.resultsViewController;
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (GMSAutocompleteResultsViewController *)resultsViewController{
    if (!_resultsViewController) {
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterAddress; 
        filter.country = GOOGLE_PLACE_COUNTRY;
        
        _resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
        _resultsViewController.delegate = self;
        _resultsViewController.autocompleteFilter = filter;
    }
    return _resultsViewController;
}

- (void)searchBarBecomeFirstResponder{
    [_searchController.searchBar becomeFirstResponder];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (GMSPlacesClient*)placesClient { 
    if (!_placesClient) { 
        _placesClient = [[GMSPlacesClient alloc]init];
    } 
    return _placesClient;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
  //  [self requestGooglePlaceForKey:searchText];
}


#pragma mark - google place delegate
- (void)requestGooglePlaceForKey:(NSString *)key{ 
    __weak typeof(self) weakSelf = self;
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress; 
    filter.country = GOOGLE_PLACE_COUNTRY;
    [self.placesClient autocompleteQuery:key
                                  bounds:nil
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                    
                                    weakSelf.dataSource = [NSMutableArray array];
                                    weakSelf.tableView.hidden = !results.count;
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                       // return;
                                    } 
                                    
                                    for (GMSAutocompletePrediction* result in results) {
                                        
                                        NSLog(@"___________________________________");
                                        NSLog(@"%@",result.attributedFullText.string);
                                        NSLog(@"%@",result.attributedSecondaryText.string);
                                        NSLog(@"%@",result.attributedPrimaryText.string);
                                       
                                        [weakSelf.dataSource addObject:@{@"placeId":result.placeID,
                                                                         @"PrimaryText":result.attributedPrimaryText,
                                                                         @"FullText":result.attributedFullText}];
                                        
                                        
                                    } 
                                    [weakSelf.tableView reloadData];
                                }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"place_cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];   
//        cell.textLabel.font = TX_BOLD_FONT(16);
//        cell.detailTextLabel.font = TX_FONT(13);
//        cell.detailTextLabel.numberOfLines = 2;
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.attributedText = dict[@"PrimaryText"];
    cell.detailTextLabel.attributedText = dict[@"FullText"]; 
    cell.imageView.image = [UIImage imageNamed:@"location-icon-blue"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
    // Handle the user's selection.
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}
    
- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}
    
    // Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictionsForResultsController:
    (GMSAutocompleteResultsViewController *)resultsController {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    
- (void)didUpdateAutocompletePredictionsForResultsController:
    (GMSAutocompleteResultsViewController *)resultsController {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
@end
