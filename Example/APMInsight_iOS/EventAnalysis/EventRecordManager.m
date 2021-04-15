//
//  EventRecordManager.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2021/2/28.
//

#import "EventRecordManager.h"
#if __has_include(<RangersAPM+EventMonitor.h>)
#import <RangersAPM+EventMonitor.h>
#endif

@implementation EventRecordManager

+ (void)recordEvent:(NSString *)eventName metrics:(NSDictionary<NSString *,NSNumber *> *)metrics dimension:(NSDictionary<NSString *,NSString *> *)dimension extraValue:(NSDictionary *)extraValue {
#if __has_include(<RangersAPM+EventMonitor.h>)
    [RangersAPM trackEvent:eventName metrics:metrics dimension:dimension extraValue:extraValue];
#endif
}

@end
