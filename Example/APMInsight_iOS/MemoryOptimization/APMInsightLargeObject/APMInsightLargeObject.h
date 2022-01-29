//
//  APMInsightLargeObject.h
//  MemoryGraphDemo
//
//  Created by bytedance on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInsightLargeObject : NSObject

/**
 * 内部是否要泄露内存
 */
- (instancetype)initWithLeakedObject:(BOOL)isLeaked;

@end

NS_ASSUME_NONNULL_END
