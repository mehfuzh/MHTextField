//
//  MHTextField.m
//
//  Created by Mehfuz Hossain on 4/11/13.
//  Copyright (c) 2013 Mehfuz Hossain. All rights reserved.
//

#import "MHTextField.h"
#import "CDatePickerViewEx.h"
#import "NSDate+Year.h"
#import "DayMonthDatePickView.h"
#import "UIFormManager.h"


@interface MHTextField () {
    UITextField *_textField;
}

@property(nonatomic) BOOL invalid;


@end

@implementation MHTextField

@synthesize required;
//@synthesize toolbar;
@synthesize invalid;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self setup];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {

    //[self setTintColor:[UIColor blackColor]];


}


- (void)datePickerValueChanged:(id)sender {
    UIDatePicker *datePicker = (UIDatePicker *) sender;

    NSDate *selectedDate = datePicker.date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YY"];

    [_textField setText:[dateFormatter stringFromDate:selectedDate]];
}



- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];

    if (!enabled)
        [self setBackgroundColor:[UIColor lightGrayColor]];
}


@end
