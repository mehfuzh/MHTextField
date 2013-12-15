//
// Created by Fabrice Armisen on 12/9/13.
//


#import "DayMonthDatePickView.h"

// Identifiers of components
#define DAY ( 0 )
#define MONTH ( 1 )

@implementation DayMonthDatePickView {

    NSArray *_monthNames;
    NSArray *_monthDayCounts;
}


- (id)init {
    self = [super init];
    if (self) {
        [self setup];


    }

    return self;
}

- (void)setup {
    self.delegate = self;
    self.dataSource = self;

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    _monthNames =  [dateFormatter standaloneMonthSymbols];
    _monthDayCounts = @[@(31), @(29), @(31), @(30), @(31), @(30), @(31), @(31), @(30), @(31), @(30), @(31)];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    [self selectDay:day andMonth:month];
    self.showsSelectionIndicator = YES;
}

- (void)selectDay:(NSInteger)day andMonth:(NSInteger)month {
    NSUInteger daysCount = [self daysCountForMonth:month];
    [self selectRow:((INT16_MAX/(2*daysCount))*daysCount) + day - 1 inComponent:DAY animated:NO];
    [self selectRow:((INT16_MAX/(2*12))*12) + month - 1 inComponent:MONTH animated:NO];
}



#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return INT16_MAX;
    /*if (MONTH == component) {
        return 12 * 2;
    } else {
        return [self daysCountForMonth:[self selectedMonth]] * 2;
    }*/
}

- (NSUInteger) selectedMonth {
    int selectedMonthIndex = [self selectedRowInComponent:MONTH] % 12;
    if ( -1 == selectedMonthIndex) {
        selectedMonthIndex = 0;
    }
    return (NSUInteger) (selectedMonthIndex + 1);
}

- (NSUInteger)daysCountForMonth:(int)month {
    return (NSUInteger) [_monthDayCounts[(NSUInteger) month - 1] intValue];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (MONTH == component) {
        return _monthNames[(NSUInteger) row % 12 ];
    } else {
        return [NSString stringWithFormat:@"%d", (row % [self daysCountForMonth:[self selectedMonth]]) + 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (MONTH == component) {
        [pickerView reloadComponent:DAY];
    }
}


@end