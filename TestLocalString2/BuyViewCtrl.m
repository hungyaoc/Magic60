//
//  BuyViewCtrl.m
//  River2
//
//  Created by Chen Hung-Yao on 3/3/12.
//  Copyright (c) 2012 magtek. All rights reserved.
//

#import "BuyViewCtrl.h"

#define kMyFeatureIdentifier    @"com.jeff.magino.upgrade"

extern BOOL bFull;

@implementation BuyViewCtrl
@synthesize btnBuy;
@synthesize delegate2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBtnBuy:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)goBuy:(id)sender 
{
    // check if full version
    if(bFull == YES)
        return;
    
    btnBuy.enabled = NO;
    
    // checking
    if ([SKPaymentQueue canMakePayments])
    {
        productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject: kMyFeatureIdentifier]];
        productRequest.delegate = self;
        [productRequest start];
    }
    else
    {
        // error
        NSLog(@"parent control is enable");
    }
}

- (IBAction)goClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark
#pragma mark in app purchase

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray* productArray = response.products;
    
    int count = (int)[productArray count];
    
    // populate UI
    if(count > 0)
    {
        //debug
        myProduct = [productArray objectAtIndex:0];
        if (myProduct)
        {
            NSLog(@"Product title: %@" ,        myProduct.localizedTitle);
            NSLog(@"Product description: %@" ,  myProduct.localizedDescription);
            NSLog(@"Product price: %@" ,        myProduct.price);
            NSLog(@"Product id: %@" ,           myProduct.productIdentifier);
        }
        
        //
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:myProduct.localizedTitle
                                                        message:myProduct.localizedDescription
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel" 
                                              otherButtonTitles:@"Buy", @"Restore", nil];
        
        [alert show];
    }
    else
    {
        NSLog(@"no sale data!");
    }
    
    btnBuy.enabled = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        // cancel
        return;
    }
    else
    {
        // agree to purchase
        payment = [SKPayment paymentWithProduct:myProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    btnBuy.enabled = YES;
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.payment.productIdentifier];
    
    bFull = YES;
    [self saveUnlockFile];
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    // notify parent
    if(delegate2)
    {
        [delegate2 upgradeFinish];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//=== step 9
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    //[self recordTransaction: transaction];
    //[self provideContent: transaction.originalTransaction.payment.productIdentifier];
    
    bFull = YES;
    [self saveUnlockFile];
        
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    // notify parent
    if(delegate2)
    {
        [delegate2 upgradeFinish];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//=== step 10
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
        NSString* msg = @"transaction fail!";
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    //[self dismissModalViewControllerAnimated:YES];
}


-(BOOL)checkUnlock
{
    NSString* docPath = [self getDocPath];
	NSString* FullPath = [NSString stringWithFormat:@"%@/unlock.txt", docPath];
	
	//debug
	//NSLog(@"%@", FullPath);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:FullPath];
}

-(NSString*)getDocPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	return documentsDirectoryPath;
}


-(void)saveUnlockFile
{
    NSString* docPath = [self getDocPath];
	NSString* FullPath = [NSString stringWithFormat:@"%@/unlock.txt", docPath];
	
    if(bFull)
    {
        NSString* str = [NSString stringWithFormat:@"YES"];
        [str writeToFile:FullPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

@end
