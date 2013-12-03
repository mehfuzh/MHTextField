//
//  MHViewController.h
//  MHTextField
//
//  Created by Mehfuz Hossain on 12/3/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTextField.h"

@interface MHViewController : UIViewController
@property (strong, nonatomic) IBOutlet MHTextField *emailTextField;
@property (strong, nonatomic) IBOutlet MHTextField *passwordTextField;
@property (strong, nonatomic) IBOutlet MHTextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet MHTextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet MHTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet MHTextField *ageTextField;
@property (strong, nonatomic) IBOutlet MHTextField *zipTextField;

@end
