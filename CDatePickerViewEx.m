#import "CDatePickerViewEx.h"


// Identifiers of components
#define MONTH ( 0 )
#define YEAR ( 1 )


// Identifies for component views
#define LABEL_TAG 43


@interface CDatePickerViewEx()

@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

- (NSArray *)nameOfYearsFrom:(NSInteger)from to:(NSInteger)to;
-(NSArray *)nameOfMonths;
-(CGFloat)componentWidth;

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected;
-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;

- (NSIndexPath *)pathForDate:(NSDate *)date;
-(NSInteger)bigRowMonthCount;
-(NSInteger)bigRowYearCount;

- (NSString *)monthNameForDate:(NSDate *)date;

- (NSString *)yearNameForDate:(NSDate *)date;

@end



@implementation CDatePickerViewEx

const NSInteger bigRowCount = 1000;
const NSInteger minYear = 2008;
const NSInteger maxYear = 2030;
const CGFloat rowHeight = 44.f;
const NSInteger numberOfComponents = 2;

@synthesize months;
@synthesize years = _years;





- (id)init {
    self = [super init];
    if (self) {
        self.months = [self nameOfMonths];
        self.years = [self nameOfYearsFrom:minYear to:maxYear];

        self.delegate = self;
        self.dataSource = self;

        [self selectDate:[NSDate date]];
    }

    return self;
}

- (id)initWithYearsFrom:(NSInteger)from to:(NSInteger)to {
    self = [super init];
    if (self) {
        self.months = [self nameOfMonths];
        self.years = [self nameOfYearsFrom:from to:to];

        self.delegate = self;
        self.dataSource = self;

        [self selectDate:[NSDate date] ];
    }

    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];

    self.months = [self nameOfMonths];
    self.years = [self nameOfYearsFrom:0 to:0];

    self.delegate = self;
    self.dataSource = self;

    [self selectDate:[NSDate date] ];
}



-(NSDate *)date
{
    NSInteger monthCount = [self.months count];
    NSString *month = [self.months objectAtIndex:(NSUInteger) ([self selectedRowInComponent:MONTH] % monthCount)];

    NSInteger yearCount = [self.years count];
    NSString *year = [self.years objectAtIndex:(NSUInteger) ([self selectedRowInComponent:YEAR] % yearCount)];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; [formatter setDateFormat:@"MMMM:yyyy"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, year]];
    return date;
}

#pragma mark - UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView
           viewForRow: (NSInteger)row
         forComponent: (NSInteger)component
          reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        NSString *monthName = [self.months objectAtIndex:(NSUInteger) (row % monthCount)];
        NSString *currentMonthName = [self monthNameForDate:nil ];
        if([monthName isEqualToString:currentMonthName])
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger yearCount = [self.years count];
        NSString *yearName = [self.years objectAtIndex:(NSUInteger) (row % yearCount)];
        NSString *currenrYearName  = [self yearNameForDate:nil ];
        if([yearName isEqualToString:currenrYearName])
        {
            selected = YES;
        }
    }

    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent: component selected: selected];
    }

    returnView.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowHeight;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowYearCount];
}

#pragma mark - Util
-(NSInteger)bigRowMonthCount
{
    return [self.months count]  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
    return [self.years count]  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = [self.months count];
        return [self.months objectAtIndex:(NSUInteger) (row % monthCount)];
    }
    NSInteger yearCount = [self.years count];
    return [self.years objectAtIndex:(NSUInteger) (row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component selected:(BOOL)selected
{
    CGRect frame = CGRectMake(0.f, 0.f, [self componentWidth],rowHeight);

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = (NSTextAlignment) UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = selected ? [UIColor blueColor] : [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:18.f];
    label.userInteractionEnabled = NO;

    label.tag = LABEL_TAG;

    return label;
}

-(NSArray *)nameOfMonths
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    return [dateFormatter standaloneMonthSymbols];
}

- (NSArray *)nameOfYearsFrom:(NSInteger)from to:(NSInteger)to {
    NSMutableArray *years = [NSMutableArray array];

    for(NSInteger year = from; year <= to; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%i", year];
        [years addObject:yearStr];
    }
    return years;
}

- (void)selectDate:(NSDate *)date {
    NSIndexPath* pathForDate = [self pathForDate:date];
    [self selectRow: pathForDate.row
        inComponent: MONTH
           animated: NO];

    [self selectRow: pathForDate.section
        inComponent: YEAR
           animated: NO];

    self.showsSelectionIndicator = YES;
}

- (NSIndexPath *)pathForDate:(NSDate*) date {
    CGFloat row = 0.f;
    CGFloat section = 0.f;

    NSString *month = [self monthNameForDate:date ];
    NSString *year  = [self yearNameForDate:date ];

    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            //row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }

    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            //section = section + [self bigRowYearCount] / 2;
            break;
        }
    }

    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSString *)monthNameForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

- (NSString *)yearNameForDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:date];
}


@end