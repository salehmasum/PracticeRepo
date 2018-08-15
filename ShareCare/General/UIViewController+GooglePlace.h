//
//  UIViewController+GooglePlace.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>

typedef void(^GooglePlaceBlock)(NSString *address,CLLocationCoordinate2D coordinate);

@interface UIViewController (GooglePlace)<GMSAutocompleteViewControllerDelegate>

- (void)requestDirectiondestination:(CLLocationCoordinate2D)destination;

- (void)GMSAutocompleteAddress:(GooglePlaceBlock)addressBlock;
- (void)GMSAutocompleteFilterType:(GMSPlacesAutocompleteTypeFilter)type address:(GooglePlaceBlock)addressBlock;

- (void)currentAddress:(GooglePlaceBlock)addressBlock;

@end
