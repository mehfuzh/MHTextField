//
// Created by Fabrice Armisen on 1/13/14.
//

#import <objc/runtime.h>
#import "UITextField+ExtraProperties.h"

static char minLengthKey;
static char maxLengthKey;
static char typeKey;


@implementation UITextField (ExtraProperties)

- (int)minLength {
    NSNumber *value = objc_getAssociatedObject(self, &minLengthKey);
    return nil == value ? -1 : [value intValue];
}

- (void)setMinLength:(int)minLength {
    objc_setAssociatedObject(self, &minLengthKey, [NSNumber numberWithInt:minLength], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (int)maxLength {
    NSNumber *value = objc_getAssociatedObject(self, &maxLengthKey);
    return nil == value ? -1 : [value intValue];
}

- (void)setMaxLength:(int)maxLength {
    objc_setAssociatedObject(self, &maxLengthKey, [NSNumber numberWithInt:maxLength], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FieldType)type {
    NSNumber *value = objc_getAssociatedObject(self, &typeKey);
    return  (nil == value ? UNKNOW_FIELD_TYPE : (FieldType) [value intValue]);
}

- (void)setType:(FieldType)type {
    objc_setAssociatedObject(self, &typeKey, [NSNumber numberWithInt:type], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disabled {
    return !self.enabled;
}


@end