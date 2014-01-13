//
// Created by Fabrice Armisen on 1/12/14.
//

#import "ValidationManager.h"
#import "Validator.h"
#import "MHTextField.h"


@implementation ValidationManager {

    NSMutableArray *_validators;
    NSMutableArray *_textFields;
}
- (id)init {
    self = [super init];
    if (self) {
        _validators = [NSMutableArray array];
        _textFields = [NSMutableArray array];
    }

    return self;
}

- (void)addValidator:(Validator *)validator {
    [_validators addObject:validator];
    [_textFields addObject:validator.textField];
}

- (BOOL)validate:(UITextField *)field {
    unsigned int errorsCount = 0;
    for (Validator *validator in _validators) {
        if (validator.textField == field) {
            errorsCount +=  [validator validate] ? 0 : 1;
        }
    }
    return  errorsCount == 0;
}


- (BOOL)validateAll:(void (^)(UITextField *, BOOL)) block {
    unsigned int errorsCount = 0;
    for (UITextField *textField in _textFields) {
        BOOL valid = [self validate:textField];
        errorsCount += valid ? 0 : 1;
        if (block) {
            block(textField, valid);
        }
    }
    return errorsCount == 0;
}



@end