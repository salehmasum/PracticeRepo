//
//  GooglePlaceAddressVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/5.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface GooglePlaceAddressVC : UIViewController

@property (nonatomic, strong) GMSAutocompleteResultsViewController *resultsViewController;
@property (nonatomic, strong) UISearchController *searchController;
@end
