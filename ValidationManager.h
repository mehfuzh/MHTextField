//
// Created by Fabrice Armisen on 1/12/14.
//

#import <Foundation/Foundation.h>

@class Validator;


@interface ValidationManager : NSObject


- (void)addValidator:(Validator *)validator;

- (BOOL)validate:(UITextField *)field;

- (BOOL)validateAll:(void (^)(UITextField *, BOOL))pFunction;
@end