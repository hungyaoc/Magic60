//
//  ViewController.m
//  MagiNo
//
//  Created by Jeff Chen on 5/31/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewCtrl.h"
#import "HelpViewCtrl.h"

BOOL bFull = NO;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // check if lock
    buyCtrl = [[BuyViewCtrl alloc] init];
    buyCtrl.delegate2 = self;
    bFull = [buyCtrl checkUnlock];
    
    //self.btnUpgrade.hidden = bFull;
}

-(void)upgradeFinish
{
    bFull = YES;
    self.btnUpgrade.hidden = YES;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thank You!", nil)
                                                    message:NSLocalizedString(@"The transaction is done.", nil)
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goPlay:(id)sender
{
    PlayViewCtrl* dlg = [[PlayViewCtrl alloc] init];
    
    [self presentViewController:dlg animated:YES completion:nil];
    
}

- (IBAction)goHelp:(id)sender
{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    HelpViewCtrl* ctrl = [story instantiateViewControllerWithIdentifier:@"HelpViewCtrl"];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    
    [self presentViewController:nav animated:YES completion:nil];
}

-(IBAction)goUpgrade:(id)sender
{
    [buyCtrl goBuy:nil];
}


- (void)viewDidUnload {
    [self setMyTitle:nil];
    [self setBtnUpgrade:nil];
    [super viewDidUnload];
}
@end
