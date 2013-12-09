#import <UIKit/UIKit.h>

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;

- (void)selectDate:(NSDate *)date;

- (id)initWithYearsFrom:(NSInteger)from to:(NSInteger)to;

- (void)setDate:(NSDate *)date;
@end