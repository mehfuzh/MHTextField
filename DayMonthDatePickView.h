//
// Created by Fabrice Armisen on 12/9/13.
//
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


@interface DayMonthDatePickView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>
- (NSString *)selectedDayMonthString;

- (void)selectDayMonthFromString:(NSString *)monthDayString;
@end