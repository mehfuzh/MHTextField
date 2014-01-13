//
// Created by Fabrice Armisen on 1/12/14.
//

#import <Foundation/Foundation.h>


@interface Validator : NSObject
@property(nonatomic, readonly) UITextField *textField;

+ (Validator *)emailValidatorFor:(UITextField *)field;
+ (Validator *)presenceValidatorFor:(UITextField *)field;
+ (Validator *)lenghtValidatorFor:(UITextField *)field between:(unsigned int)min and:(unsigned int)max;

- (Validator *) unless:(BOOL (^)())unlessBlock;

+ (Validator *)matchingValidatorFor:(UITextField *)field and:(UITextField *)and;

- (BOOL)validate;

@end