//
//  EventRecordManager.h
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2021/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventRecordManager : NSObject

+ (void)recordEvent:(NSString *)eventName
            metrics:(nullable NSDictionary<NSString *, NSNumber *> *)metrics
          dimension:(nullable NSDictionary<NSString *, NSString *> *)dimension
         extraValue:(nullable NSDictionary *)extraValue;

@end

NS_ASSUME_NONNULL_END
