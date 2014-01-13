//
//  MHTextField.h
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

#define MONTH_YEAR_FORMAT @"MMMM yyyy"

typedef enum {
    UNKNOW_FIELD_TYPE,
    DATE_FIELD,
    MONTH_YEAR_FIELD,
    DAY_MONTH_FIELD,
    EMAIL_FIELD
} FieldType;

@required
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;

@end

@interface MHTextField : UITextField {
    int _maxCharactersCount;
}

@property (nonatomic) BOOL required;
@property (nonatomic) FieldType type;
@property(nonatomic) int maxCharactersCount;
@property(nonatomic) BOOL disabled;

@end
