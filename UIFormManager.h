//
// Created by Fabrice Armisen on 1/10/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHTextField.h"

@class Validator;
@class ValidationManager;

@interface UIFormManager : NSObject<UITextFieldDelegate>

- (id)initWithValidationManager:(ValidationManager *)validationManager;

- (void)setTextFields:(NSArray *)textFields;

- (BOOL)validateAll;
@end