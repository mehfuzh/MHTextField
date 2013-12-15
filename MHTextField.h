//
//  MHTextField.h
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHTextField;

@protocol MHTextFieldDelegate <NSObject>

typedef enum {
    DATE_FIELD,
    MONTH_YEAR_FIELD,
    DAY_MONTH_FIELD,
    EMAIL_FIELD
} FieldType;

@required
- (MHTextField*) textFieldAtIndex:(int)index;
- (int) numberOfTextFields;

@end

@interface MHTextField : UITextField<UITextFieldDelegate>

@property (nonatomic) BOOL required;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) id<MHTextFieldDelegate> textFieldDelegate;
@property(nonatomic) FieldType type;

- (BOOL) validate;

@end
