//
// Created by Fabrice Armisen on 1/13/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MHTextField.h"

@interface UITextField (ExtraProperties)
@property (nonatomic) int minLength;
@property (nonatomic) int maxLength;
@property (nonatomic) FieldType type;
@property (nonatomic, readonly) BOOL disabled;


@end