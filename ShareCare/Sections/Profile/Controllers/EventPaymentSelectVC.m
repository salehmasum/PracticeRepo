//
//  EventPaymentSelectVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventPaymentSelectVC.h"
#import "EventPaymentDetailsVC.h"

#import "BraintreePayPal.h"
#import "BraintreeCard.h"
#import "AddPaypalmethodVC.h"


@interface EventPaymentSelectVC ()<BTViewControllerPresentingDelegate,BTAppSwitchDelegate>

@property (strong, nonatomic)BTAPIClient *braintreeClient;

@end

@implementation EventPaymentSelectVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
#ifdef DEBUG 
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:BRAINTREE_Sandbox_Tokenization_key];
#else 
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:BRAINTREE_Production_Tokenization_key];
#endif
    
  
    
}
- (IBAction)addPaypal:(id)sender { 
    
    CreditCardModel *card = [[CreditCardModel alloc] init];
    card.cardType = @"2";
    AddPaypalmethodVC *detail = [[AddPaypalmethodVC alloc] init];
    detail.card = card;
    detail.isEdit = NO;
    [self.navigationController pushViewController:detail animated:YES];
    
//    // Start the Checkout flow
//    BTPayPalRequest *request = [[BTPayPalRequest alloc] initWithAmount:@"1.00"];
//    
//    [self startPayPalCheckout:request];
    
}
- (IBAction)addCreditCard:(id)sender {
    CreditCardModel *card = [[CreditCardModel alloc] init];
    card.cardType = @"0";
    
     EventPaymentDetailsVC *guidVc = [[EventPaymentDetailsVC alloc] init];
    guidVc.card = card;
     [self.navigationController pushViewController:guidVc animated:YES];
    
    /*
    BTCardClient *cardClient = [[BTCardClient alloc] initWithAPIClient:self.braintreeClient];
    BTCard *card = [[BTCard alloc] initWithNumber:@"4111111111111111"
                                  expirationMonth:@"12"
                                   expirationYear:@"2018"
                                              cvv:nil];
    [cardClient tokenizeCard:card
                  completion:^(BTCardNonce *tokenizedCard, NSError *error) {
                      // Communicate the tokenizedCard.nonce to your server, or handle error
                      
                      NSLog(@"nonce=%@",tokenizedCard.nonce);
                  }];
    
     */
    
}

- (void)startPayPalCheckout:(BTPayPalRequest *)paypalRequest {
    BTPayPalDriver *paypalDriver = [[BTPayPalDriver alloc] initWithAPIClient:self.braintreeClient];
    paypalDriver.viewControllerPresentingDelegate = self;
    paypalDriver.appSwitchDelegate = self; // Optional
    
    [paypalDriver requestOneTimePayment:paypalRequest
                             completion:^(BTPayPalAccountNonce *tokenizedPayPalAccount, NSError *error) {
                                 if (tokenizedPayPalAccount) {
                                     NSLog(@"Got a nonce! %@\nemail:%@", tokenizedPayPalAccount.nonce,tokenizedPayPalAccount.email);
                                     BTPostalAddress *address = tokenizedPayPalAccount.billingAddress;
                                     NSLog(@"Billing address:\n%@\n%@\n%@ %@\n%@ %@", address.streetAddress, address.extendedAddress, address.locality, address.region, address.postalCode, address.countryCodeAlpha2);
                                 } else if (error) {
                                     // Handle error
                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                     NSLog(@"ERROR %@", error.localizedDescription);
                                 } else {
                                     // User canceled
                                     [SVProgressHUD showErrorWithStatus:@"User canceled"];
                                 }
                             }];
}

#pragma mark - BTViewControllerPresentingDelegate

// Required
- (void)paymentDriver:(id)paymentDriver
requestsPresentationOfViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Required
- (void)paymentDriver:(id)paymentDriver
requestsDismissalOfViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BTAppSwitchDelegate

// Optional - display and hide loading indicator UI
- (void)appSwitcherWillPerformAppSwitch:(id)appSwitcher {
    [self showLoadingUI];
    
    // You may also want to subscribe to UIApplicationDidBecomeActiveNotification
    // to dismiss the UI when a customer manually switches back to your app since
    // the payment button completion block will not be invoked in that case (e.g.
    // customer switches back via iOS Task Manager)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLoadingUI:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)appSwitcherWillProcessPaymentInfo:(id)appSwitcher {
    [self hideLoadingUI:nil];
}

#pragma mark - Private methods

- (void)showLoadingUI {
    [SVProgressHUD showWithStatus:TEXT_LOADING];
}

- (void)hideLoadingUI:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [SVProgressHUD dismiss];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
