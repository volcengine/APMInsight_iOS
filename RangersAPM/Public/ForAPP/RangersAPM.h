//
//  RangersAPM.h
//  Pods
//
//  Created by xuminghao.eric on 2020/4/27.
//

#import <Foundation/Foundation.h>
#import "BDAutoTrackConfig+RangersAPM.h"

NS_ASSUME_NONNULL_BEGIN

@interface RangersAPM : NSObject

+ (void)startWithConfig:(BDAutoTrackConfig *)config;

@property (atomic, copy, class) NSString *userID;/**用户ID */
@property (atomic, copy, class) NSString *userName;/**用户名 */
@property (atomic, copy, class) NSString *email;/**用户邮箱 */

/**
 添加自定义的环境变量
 
 @param value 自定义的环境变量的值
 @param key 自定义的环境变量的键
 */
+ (void)setCustomContextValue:(id)value forKey:(NSString *)key;

/**
 移除自定义的环境变量
 
 @param key 自定义的环境变量的键
 */
+ (void)removeCustomContextKey:(NSString *)key;

/**
 添加自定义的筛选项
 
 @param value 自定义的筛选项的值
 @param key 自定义的筛选项的的键
 */
+ (void)setCustomFilterValue:(id)value forKey:(NSString *)key;

/**
 移除自定义的筛选项
 
 @param key 自定义的筛选项的键
 */
+ (void)removeCustomFilterKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
