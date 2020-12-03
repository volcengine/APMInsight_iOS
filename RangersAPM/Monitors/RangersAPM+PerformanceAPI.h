//
//  RangersAPM+PerformanceAPI.h
//  Pods
//
//  Created by xuminghao.eric on 2020/8/4.
//

#import "RangersAPM.h"

NS_ASSUME_NONNULL_BEGIN

@interface RangersAPM (PerformanceAPI)

/**
 use this api to add a span during launch
*/
+ (void)beginLaunchSpan:(NSString *)spanName;
+ (void)endLaunchSpan:(NSString *)spanName;

@end

NS_ASSUME_NONNULL_END
