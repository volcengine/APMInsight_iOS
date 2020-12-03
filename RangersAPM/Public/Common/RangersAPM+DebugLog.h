//
//  RangersAPM+DebugLog.h
//  HeimdallrFinder
//
//  Created by xuminghao.eric on 2020/11/26.
//

#import "RangersAPM.h"

NS_ASSUME_NONNULL_BEGIN

/**
 log - SDK Debug日志内容
 */
typedef void(^RangersAPMLogger)(NSString *log);

@interface RangersAPM (DebugLog)

/**
 开启控制台日志输出，建议只在Debug下调用
 
 @param logger 格式化输出日志，如果传入nil则按照默认格式输出。默认输出格式： APMInsight : log
 */
+ (void)allowDebugLogUsingLogger:(nullable RangersAPMLogger)logger;

@end

NS_ASSUME_NONNULL_END
