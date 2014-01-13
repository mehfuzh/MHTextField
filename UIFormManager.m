//
// Created by Fabrice Armisen on 1/10/14.
//

#import "UIFormManager.h"
#import "MHTextField.h"
#import "CDatePickerViewEx.h"
#import "DayMonthDatePickView.h"
#import "NSDate+Year.h"
#import "Validator.h"
#import "ValidationManager.h"
#import "UITextField+ExtraProperties.h"


@implementation UIFormManager {

    CGSize _keyboardSize;
    CGPoint _keyboardOrigin;
    MHTextField *_currentField;
    BOOL _keyboardIsShown;
    BOOL _isToolBarCommand;
    CGFloat _savedContainerY;
    NSArray *_textFields;
    BOOL _isDoneCommand;
    UIToolbar *_toolbar;
    UIBarButtonItem *_previousBarButton;
    UIBarButtonItem *_nextBarButton;

    ValidationManager *_validationManager;
}



- (id)initWithValidationManager:(ValidationManager *)validationManager {
    self = [super init];
    if (self) {
        _validationManager = validationManager;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        // set style
        [_toolbar setBarStyle:UIBarStyleDefault];

        _previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousButtonIsClicked:)];
        _nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonIsClicked:)];

        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonIsClicked:)];

        NSArray *barButtonItems = @[_previousBarButton, _nextBarButton, flexBarButton, doneBarButton];

        _toolbar.items = barButtonItems;




        
        

    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentField = (MHTextField *) textField;

    if (_currentField.type == DATE_FIELD) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

        if (textField.text && ![textField.text isEqualToString:@""]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/YY"];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [datePicker setDate:[dateFormatter dateFromString:textField.text]];
        }
        [textField setInputView:datePicker];
    } else if (_currentField.type == MONTH_YEAR_FIELD) {
        CDatePickerViewEx *datePicker = [[CDatePickerViewEx alloc] initWithYearsFrom:1901 to:[[NSDate date] year] - 13];

        if (textField.text && ![textField.text isEqualToString:@""]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [dateFormatter setLocale:locale];
            [dateFormatter setDateFormat:MONTH_YEAR_FORMAT];
            [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
            //[dateFormatter setDateStyle:kCFDateFormatterNoStyle];
            NSDate *date = [dateFormatter dateFromString:textField.text];
            [datePicker selectDate:date];
        }
        [textField setInputView:datePicker];
    } else if (_currentField.type == DAY_MONTH_FIELD) {
        //UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        DayMonthDatePickView *picker = [[DayMonthDatePickView alloc] init];
        [picker selectDayMonthFromString:textField.text];
        [textField setInputView:picker];
    }
    if ( _currentField.disabled ) {
        _currentField = nil;
    } else {
        [self setBarButtonForField:_currentField];
        _currentField.inputAccessoryView = _toolbar;
    }

    return !_currentField.disabled;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    MHTextField *mhTextField = (MHTextField *) textField;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    MHTextField *mhTextField = (MHTextField *) textField;

    BOOL valid = [_validationManager validate:textField];
    textField.backgroundColor = valid ? [UIColor whiteColor] : [UIColor redColor];


    //_textField = nil;

    if (mhTextField.type == DATE_FIELD && [textField.text isEqualToString:@""]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

        [dateFormatter setDateFormat:@"MM/dd/YY"];
        [textField setText:[dateFormatter stringFromDate:[NSDate date]]];
    } else if (mhTextField.type == MONTH_YEAR_FIELD) {
        CDatePickerViewEx *datePicker = (CDatePickerViewEx *) textField.inputView;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:MONTH_YEAR_FORMAT];
        [textField setText:[dateFormatter stringFromDate:[datePicker date]]];

    } else if (mhTextField.type == DAY_MONTH_FIELD) {
        DayMonthDatePickView *datePicker = (DayMonthDatePickView *) textField.inputView;
        [textField setText:[datePicker selectedDayMonthString]];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    MHTextField *mhTextField = (MHTextField *) textField;
    return mhTextField.maxLength == -1 || [mhTextField.text length] + [string length] - range.length <= mhTextField.maxLength;

}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification {

    NSDictionary *info = [notification userInfo];

    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    _keyboardSize = [aValue CGRectValue].size;
    _keyboardOrigin = [aValue CGRectValue].origin;

    [self scrollToField:_currentField];

    _keyboardIsShown = YES;

}

- (void)keyboardWillHide:(NSNotification *)notification {

    NSTimeInterval duration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration animations:^{
        if (!_isToolBarCommand) {
            UIView *container = _currentField.superview;
            if ([container isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *) container setContentOffset:CGPointMake(0, _savedContainerY) animated:YES];
            } else if ([container.superview isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *) container.superview setContentOffset:CGPointMake(0, _savedContainerY) animated:YES];
            } else {
                CGRect frame = container.frame;
                frame.origin.y = _savedContainerY;
                container.frame = frame;
            }
        } else {
            _isToolBarCommand = NO;
        }
    }];

    _keyboardIsShown = NO;

}

- (void)scrollToField:(MHTextField *)field {

    UIView *container = field.superview;
    if ([container.superview isKindOfClass:[UIScrollView class]]) {
        container = container.superview;
    }
    CGRect visibleRect = container.frame;
    visibleRect.size.height -= _keyboardOrigin.y - visibleRect.origin.y;
    CGRect absoluteVisibleRect = [container.superview convertRect:visibleRect toView:nil];

    CGPoint absoluteOrigin = [field.superview convertPoint:field.frame.origin toView:nil];
    if (!CGRectContainsPoint(absoluteVisibleRect, absoluteOrigin)) {
        float dy = _keyboardOrigin.y - absoluteOrigin.y - field.frame.size.height;
        if ([container isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *) container;
            _savedContainerY = scrollView.contentOffset.y;
            [scrollView setContentOffset:CGPointMake(0, _savedContainerY - dy) animated:YES];
        } else {
            CGRect frame = container.frame;
            _savedContainerY = frame.origin.y;
            frame.origin.y += dy;
            container.frame = frame;
        }
    }


}

- (void)previousButtonIsClicked:(id)sender {
    NSInteger tagIndex = _currentField.tag;

    MHTextField *textField = [_textFields objectAtIndex:(NSUInteger) --tagIndex];

    while (!textField.isEnabled && tagIndex > 0) {
        textField = [_textFields objectAtIndex:(NSUInteger) --tagIndex];
    }
    _isToolBarCommand = YES;
    //[_currentField resignFirstResponder];
    [textField becomeFirstResponder];
    [self scrollToField:textField];
}

- (void)nextButtonIsClicked:(id)sender {
    NSInteger tagIndex = _currentField.tag;

    MHTextField *textField = [_textFields objectAtIndex:(NSUInteger) ++tagIndex];

    while (!textField.isEnabled && tagIndex < [_textFields count] - 1) {
        textField = [_textFields objectAtIndex:(NSUInteger) ++tagIndex];
    }
    _isToolBarCommand = YES;
    //[_currentField resignFirstResponder];
    [textField becomeFirstResponder];
    [self scrollToField:textField];
}

- (void)doneButtonIsClicked:(id)sender {
    _isDoneCommand = YES;
    _isToolBarCommand = YES;
    [_currentField resignFirstResponder];
    _currentField = nil;

}


- (void)setBarButtonForField:(MHTextField *)textField {

    BOOL previousBarButtonEnabled = NO;
    BOOL nexBarButtonEnabled = NO;

    for (unsigned int index = 0; index < [_textFields count]; index++) {
        UITextField *field = [_textFields objectAtIndex:index];

        if (index < textField.tag) {
            previousBarButtonEnabled |= field.isEnabled;
        }
        else if (index > textField.tag) {
            nexBarButtonEnabled |= field.isEnabled;
        }
    }

    _previousBarButton.enabled = previousBarButtonEnabled;
    _nextBarButton.enabled = nexBarButtonEnabled;
}


- (void)setTextFields:(NSArray *)textFields {
   _textFields = textFields;
    int index = 0;
   for ( MHTextField *mhTextField in textFields) {
       mhTextField.tag = index++;
       mhTextField.delegate = self;
   }
}


- (BOOL)validateAll {
    return [_validationManager validateAll:^(UITextField *textField, BOOL valid) {
        textField.backgroundColor = valid ? [UIColor whiteColor] : [UIColor redColor];
    }];
}
@end