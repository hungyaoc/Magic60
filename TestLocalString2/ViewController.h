//
//  ViewController.h
//  MagiNo
//
//  Created by Jeff Chen on 5/31/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyViewCtrl.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <BuyViewCtrlDelegate>
{
    BuyViewCtrl* buyCtrl;
}

@property (strong, nonatomic) IBOutlet UILabel *myTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnUpgrade;

-(IBAction)goPlay:(id)sender;
-(IBAction)goUpgrade:(id)sender;

@end
