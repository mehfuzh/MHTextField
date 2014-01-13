//
// Created by Fabrice Armisen on 1/12/14.
//

#import "Validator.h"
#import "NSString+CJStringValidator.h"
#import "MHTextField.h"
#import "UITextField+ExtraProperties.h"


@interface Validator ()
@property(nonatomic, copy) BOOL (^validatationBlock)();
@property(nonatomic, copy) BOOL (^unlessBlock)();
@end

@implementation Validator {

}

+ (Validator *)emailValidatorFor:(UITextField *)field {    
    Validator* validator = [[Validator alloc] initWithTextField:field];
    validator.validatationBlock = ^ BOOL () {
        return [field.text isEmail];
    };
    return validator;
}

+ (Validator *)presenceValidatorFor:(UITextField *)field {
    Validator* validator = [[Validator alloc] initWithTextField:field];
    validator.validatationBlock = ^ BOOL () {
        return ![field.text isEmpty];
    };
    return validator;
}

+ (Validator *)lenghtValidatorFor:(UITextField *)field between:(unsigned int)min and:(unsigned int)max {
    Validator* validator = [[Validator alloc] initWithTextField:field];
    field.minLength = min;
    field.maxLength = max;
    validator.validatationBlock = ^ BOOL () {
        return [field.text isMinLength:min] && [field.text isMaxLength:min];
    };
    return validator;
}


- (id)initWithTextField:(UITextField *)textField {
    self = [super init];
    if (self) {
        _textField = textField;
    }

    return self;
}

+ (Validator *)matchingValidatorFor:(UITextField *)firstField and:(UITextField *)secondField {
    Validator* validator = [[Validator alloc] initWithTextField:firstField];
    validator.validatationBlock = ^ BOOL () {
        return [firstField.text isEqualToString:secondField.text];
    };
    return validator;
}


- (Validator *)unless:(BOOL (^)())unlessBlock {
    self.unlessBlock = unlessBlock;
    return self;
}

- (BOOL)validate {

    if ( nil != _unlessBlock) {
        return _unlessBlock() || _validatationBlock();
    } else {
        return _validatationBlock();
    }
}

@end