//
//  MHDisaledFieldViewController.h
//  MHTextField
//
//  Created by Mehfuz Hossain on 2/27/14.
//  Copyright (c) 2014 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"

@interface MHDisaledFieldViewController : UIViewController
@property (strong, nonatomic) IBOutlet DemoTextField *emailTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *firstnameTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *lastnameTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *passwordTextField;

@end
