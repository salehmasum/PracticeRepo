//
//  UIViewController+AddressBook.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UIViewController+AddressBook.h"
/// iOS 9前的框架  
#import <AddressBook/AddressBook.h>  
#import <AddressBookUI/AddressBookUI.h>  
/// iOS 9的新框架  
#import <ContactsUI/ContactsUI.h> 
#import "objc/runtime.h"

static  char blockKey;
@interface UIViewController()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>{ 
}
@property (nonatomic,copy)AddressBookBlock addressBookBlock;
@end


@implementation UIViewController (AddressBook)


- (void)showAddressBookSelected:(AddressBookBlock)contact{
    self.addressBookBlock = [contact copy];
    
    __block typeof(self) weakeSelf = self;
    ///获取通讯录权限，调用系统通讯录  
    [self CheckAddressBookAuthorization:^(bool isAuthorized , bool isUp_ios_9) {  
        if (isAuthorized) {   
            [weakeSelf callAddressBook];
        }else {  
            [weakeSelf showAlert]; 
        }  
    }];   
} 
#pragma mark-set
-(void)setAddressBookBlock:(AddressBookBlock)addressBookBlock{    
    objc_setAssociatedObject(self, &blockKey, addressBookBlock,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
#pragma mark-get
- (AddressBookBlock )addressBookBlock{    
    return objc_getAssociatedObject(self, &blockKey); 
}
- (void)showAlert{
    NSString *message = [NSString stringWithFormat:@"Grant %@ access to your mobile contacts from \"Settings\"->\"Privacy\"->\"Contacts\"",kAPPNAME];
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"Warning" 
                                          message:message 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakeSelf goSystemSetting];
    }]; 
    [alertController addAction:cancelAction];
    [alertController addAction:settingAction]; 
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)goSystemSetting{
   [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:root=ACCOUNT_SETTINGS"]];
}
- (void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized , bool isUp_ios_9))block {  
    if (IOS9) {  
        CNContactStore * contactStore = [[CNContactStore alloc]init];  
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {  
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {  
                if (error)  
                {  
                    NSLog(@"Error: %@", error);  
                }  
                else if (!granted)  
                {  
                    
                    block(NO,YES);  
                }  
                else  
                {  
                    block(YES,YES);  
                }  
            }];  
        }  
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized){  
            block(YES,YES);  
        }  
        else {  
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");  
            block(NO,NO);  
        }  
    }else {  
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);  
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();  
        
        if (authStatus == kABAuthorizationStatusNotDetermined)  
        {  
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {  
                dispatch_async(dispatch_get_main_queue(), ^{  
                    if (error)  
                    {  
                        NSLog(@"Error: %@", (__bridge NSError *)error);  
                    }  
                    else if (!granted)  
                    {  
                        
                        block(NO,NO);  
                    }  
                    else  
                    {  
                        block(YES,NO);  
                    }  
                });  
            });  
        }else if (authStatus == kABAuthorizationStatusAuthorized)  
        {  
            block(YES,NO);  
        }else {  
            NSLog(@"请到设置>隐私>通讯录打开本应用的权限设置");  
            
            block(NO,NO);  
        }  
    }  
}  

- (void)callAddressBook{  
    if (IOS9) {  
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];  
        contactPicker.delegate = self;  
        contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];  
//        if ([contactPicker.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
//            [contactPicker.navigationController.navigationBar setBarTintColor:COLOR_BACK_BLUE];
//            [contactPicker.navigationController.navigationBar setTranslucent:NO];
//            [contactPicker.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
//        }else{
//            [contactPicker.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
//        } 
//        
//        [contactPicker.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
//        [contactPicker.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
        
        
        [self presentViewController:contactPicker animated:YES completion:nil];  
    }else {  
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];  
        peoplePicker.peoplePickerDelegate = self;  
        [self presentViewController:peoplePicker animated:YES completion:nil];  
        
    }  
} 


#pragma mark -- CNContactPickerDelegate  
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {  
    if ([contactProperty respondsToSelector:@selector(value)]) {
        CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;  
        NSString *name = [NSString stringWithFormat:@"%@ %@ %@",contactProperty.contact.givenName,contactProperty.contact.familyName,contactProperty.contact.nameSuffix];           
        if ([phoneNumber respondsToSelector:@selector(stringValue)]){
            NSString *phone = phoneNumber.stringValue;
            self.addressBookBlock(name,phone);
        }
    } 
    
    [self dismissViewControllerAnimated:YES completion:^{  
        
        
    }];   
}  

#pragma mark -- ABPeoplePickerNavigationControllerDelegate  
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {  
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);  
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);  
    CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef,index);  
    CFStringRef anFullName = ABRecordCopyCompositeName(person);  
    
    [self dismissViewControllerAnimated:YES completion:^{  
        
        NSString *name = [NSString stringWithFormat:@"%@",anFullName];   
        NSString *phone = (__bridge NSString*)value;    
        self.addressBookBlock(name,phone);
    }];   
}  





@end
