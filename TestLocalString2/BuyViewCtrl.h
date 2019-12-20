//
//  BuyViewCtrl.h
//  River2
//
//  Created by Chen Hung-Yao on 3/3/12.
//  Copyright (c) 2012 magtek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@protocol BuyViewCtrlDelegate
-(void)upgradeFinish;
@end

@interface BuyViewCtrl : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>
{
    SKProductsRequest* productRequest;
    SKPayment* payment;
    
    SKProduct* myProduct;
    
}

@property (retain, nonatomic) id<BuyViewCtrlDelegate>delegate2;
@property (retain, nonatomic) IBOutlet UIButton *btnBuy;

- (IBAction)goBuy:(id)sender;
- (IBAction)goClose:(id)sender;

//=== unlock
-(NSString*)getDocPath;
-(void)saveUnlockFile;
-(BOOL)checkUnlock;

- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction:   (SKPaymentTransaction *)transaction;
- (void) restoreTransaction:  (SKPaymentTransaction *)transaction;

@end
