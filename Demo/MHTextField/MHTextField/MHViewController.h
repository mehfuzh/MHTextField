//
//  MHViewController.h
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"

@interface MHViewController : UIViewController
@property (strong, nonatomic) IBOutlet DemoTextField *emailTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *ageTextField;
@property (strong, nonatomic) IBOutlet DemoTextField *zipTextField;
- (IBAction)createAccount:(id)sender;

@end
