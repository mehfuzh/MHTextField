//
//  MHSignupViewController.m
//  MHTextField
//
//  Created by Mehfuz Hossain on 2/27/14.
//  Copyright (c) 2014 Mehfuz Hossain. All rights reserved.
//

#import "MHSignupViewController.h"

@interface MHSignupViewController ()

@end

@implementation MHSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];
    
    // iOS 7
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeTop];
	
    [_emailTextField setRequired:YES];
    [_emailTextField setEmailField:YES];
    [_passwordTextField setRequired:YES];
    [_ageTextField setDateField:YES];

}

- (IBAction)createAccount:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Do something interesting!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    if (![self validateInputInView:self.view]){
        
        [alertView setMessage:@"Invalid information please review and try again!"];
        [alertView setTitle:@"Login Failed"];
    }
    
    [alertView show];
}


- (BOOL)validateInputInView:(UIView*)view
{
    for(UIView *subView in view.subviews){
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[DemoTextField class]]){
            if (![(MHTextField*)subView validate]){
                return NO;
            }
        }
    }
    
    return YES;
}


@end
