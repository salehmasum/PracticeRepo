//
//  UIViewController+GooglePlace.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UIViewController+GooglePlace.h"
#import "objc/runtime.h"
#import <MapKit/MapKit.h>

static  char blockKey;
@interface UIViewController()

@property (nonatomic,copy)GooglePlaceBlock addressBlock;

@end


@implementation UIViewController (GooglePlace)



-(void)setAddressBlock:(GooglePlaceBlock)addressBlock
{
    objc_setAssociatedObject(self, &blockKey, addressBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(GooglePlaceBlock)addressBlock{
    return objc_getAssociatedObject(self, &blockKey);
}

 

- (void)currentAddress:(GooglePlaceBlock)addressBlock{
    [self setAddressBlock:addressBlock];
    
    
    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error==nil && placeLikelihoodList != nil) {
            for (GMSPlaceLikelihood *hood in placeLikelihoodList.likelihoods) {
                NSLog(@"------%@   %@",hood.place.name,hood.place.formattedAddress);
            }
            
            
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {                
                NSString *address = @"";
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
                
                
                addressBlock(address, place.coordinate);
                
                USERDEFAULT_COORDINATE_SET(place.coordinate);
            }else{
                addressBlock(@"", CLLocationCoordinate2DMake(kUSER_COORDINATE_LATITUDE, kUSER_COORDINATE_LONGITUDE));
            }
        }else{
            addressBlock(@"", CLLocationCoordinate2DMake(kUSER_COORDINATE_LATITUDE, kUSER_COORDINATE_LONGITUDE));
        }
    }];
    
    
}


//https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood4&key=YOUR_API_KEY


- (void)requestDirectionOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}
- (void)requestDirectiondestination:(CLLocationCoordinate2D)destination{
    
    [self requestDirectionOrigin:CLLocationCoordinate2DMake(kUSER_COORDINATE_LATITUDE, kUSER_COORDINATE_LONGITUDE) destination:destination];
    
    
   // NSString *api = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=-27.466609,143.027462&destination=-33.928318,151.233067&key=%@",GOOGLE_WEB_DIRECTIONS_KEY];
    
    //    
    //    [[AFHTTPSessionManager manager] GET:api 
    //                             parameters:nil 
    //                               progress:^(NSProgress * _Nonnull downloadProgress) {
    //                                   
    //                               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //                                   NSLog(@"%@",responseObject);
    //                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { 
    //                                   
    //                                   
    //                               }];
    
}
- (void)GMSAutocompleteAddress:(GooglePlaceBlock)addressBlock{ 
    [self GMSAutocompleteFilterType:kGMSPlacesAutocompleteTypeFilterAddress address:addressBlock];
}

- (void)GMSAutocompleteFilterType:(GMSPlacesAutocompleteTypeFilter)type address:(GooglePlaceBlock)addressBlock{
    
    [self setAddressBlock:addressBlock];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = type;//kGMSPlacesAutocompleteTypeFilterAddress;//kGMSPlacesAutocompleteTypeFilterEstablishment;//kGMSPlacesAutocompleteTypeFilterAddress;//; 
    filter.country = GOOGLE_PLACE_COUNTRY;
    
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.autocompleteFilter = filter;
    acController.delegate = self; 
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place formattedAddress %@", place.formattedAddress);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    NSLog(@"Place coordinate (%f,%f)", place.coordinate.latitude,place.coordinate.longitude);
    
    NSMutableArray *array = [NSMutableArray array];
    NSString *country = @"";
    for (GMSAddressComponent *gmsAddress in place.addressComponents) {
        if(![gmsAddress.type isEqualToString:@"country"]){
           // [string appendString:gmsAddress.name];
            [array addObject:gmsAddress.name];
        }else{
            country = gmsAddress.name;
        }
    }
    
    NSLog(@"【%@】",[array componentsJoinedByString:@","]);
    NSString *loca = @"";
    for (GMSAddressComponent *component in place.addressComponents) {
        NSLog(@"%@   %@",component.type,component.name);
        if (loca.length==0 && [component.type isEqualToString:@"administrative_area_level_2"]) {
            loca = component.name;
            continue;
        }
    
    }
    NSString *address = @"";
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
    
    __weak typeof(self) weakSelf= self;
    [self dismissViewControllerAnimated:YES completion:^{
       // weakSelf.addressBlock([place.formattedAddress stringByReplacingOccurrencesOfString:country withString:@""], place.coordinate);
        NSString *result = [NSString stringWithFormat:@"%@%@%@",place.formattedAddress,ADDRESS_SEPARATED_STRING,loca];
       
        weakSelf.addressBlock(result, place.coordinate);
        
        NSLog(@"============%@",result);
    }];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", [error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}
// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}
// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}





@end

