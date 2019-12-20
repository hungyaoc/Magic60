//
//  HelpViewCtrl.m
//  MagiNo
//
//  Created by Jeff on 6/9/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//

#import "HelpViewCtrl.h"

@interface HelpViewCtrl ()

@end

@implementation HelpViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"How to Play";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goClose:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
