//
//  MHDisaledFieldViewController.m
//  MHTextField
//
//  Created by Mehfuz Hossain on 2/27/14.
//  Copyright (c) 2014 Mehfuz Hossain. All rights reserved.
//

#import "MHDisaledFieldViewController.h"

@interface MHDisaledFieldViewController ()

@end

@implementation MHDisaledFieldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];
   
    [_firstnameTextField setText:@"Jon"];
    [_lastnameTextField setText:@"Doe"];
    
    [_firstnameTextField setEnabled:NO];
    [_lastnameTextField setEnabled:NO];
}

@end
