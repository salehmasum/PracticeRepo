//
//  CreateEventVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventModel.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
//#import "GooglePlaceAddressVC.h"
#import "UIViewController+GooglePlace.h"


@interface CreateEventVC : UIViewController<GMSAutocompleteViewControllerDelegate>
@property (nonatomic, retain) GMSPlacesClient *placesClient;
@property (strong, nonatomic) EventModel *event;

@end
