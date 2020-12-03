//
//  RangersAPMForSDK.h
//  Pods
//
//  Created by who on 2020/5/18.
//

#import <Foundation/Foundation.h>
#import "BDAutoTrackConfig+RangersAPMForSDK.h"

NS_ASSUME_NONNULL_BEGIN

@interface RangersAPMForSDK : NSObject

+ (void)startWithConfig:(BDAutoTrackConfig *)config;

/**
 添加自定义的环境变量
 
 @param value 自定义的环境变量的值
 @param key 自定义的环境变量的键
 */
+ (void)setCustomContextValue:(id)value forKey:(NSString *)key appID:(NSString *)appID;

/**
 移除自定义的环境变量
 
 @param key 自定义的环境变量的键
 */
+ (void)removeCustomContextKey:(NSString *)key appID:(NSString *)appID;

/**
 添加自定义的筛选项
 
 @param value 自定义的筛选项的值
 @param key 自定义的筛选项的的键
 */
+ (void)setCustomFilterValue:(id)value forKey:(NSString *)key appID:(NSString *)appID;

/**
 移除自定义的筛选项
 
 @param key 自定义的筛选项的键
 */
+ (void)removeCustomFilterKey:(NSString *)key appID:(NSString *)appID;


@end

NS_ASSUME_NONNULL_END
