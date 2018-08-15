//
//  CreateShareCareVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseCreateVC.h"
#import <GooglePlaces/GooglePlaces.h>
#import "UIViewController+GooglePlace.h"

@interface CreateShareCareVC : BaseCreateVC

@property (nonatomic, strong) NSMutableArray * locationArray; 
@property (nonatomic, retain) GMSPlacesClient *placesClient;
@end
