//
//  RangersAPM+CrashCallback.h
//  Pods
//
//  Created by xuminghao.eric on 2020/9/15.
//

#import "RangersAPM.h"
#include <mach/mach_types.h>

typedef void (*apm_crash_callback)(char **dynamic_key, char **dynamic_data, uint64_t crash_time, uint64_t fault_address, thread_t current_thread, thread_t crash_thread);

/**
 RangersAPM 内部处理完 Crash 后，回调业务方，自定义数据，会在 APMInsight平台 自定义数据中展示
 
 ⚠️⚠️⚠️ Warning ⚠️⚠️⚠️
 ⚠️⚠️⚠️ Crash后App运行环境比较脆弱，容易造成二次Crash或死锁，除非非常必要，否则不建议使用该方法 ⚠️⚠️⚠️
 
 业务方收到回调时，表明App已发生Crash，运行在异常环境，所以存在使用限制，应该遵守下面约定：
 1. 回调方法内部应该越简单越好，只用于记录关键信息，尽快结束 （Crash期间用户端表现为界面卡死状态）
 2. 这时除了当前线程，其他线程都被挂起，所以不要开启其他线程
 3. 不要调用OC方法，容易造成死锁
 4. 尽量不要在堆上malloc分配内存
*/

@interface RangersAPM (CrashCallback)

+ (void)registerCallback:(apm_crash_callback)callback;

+ (void)removeCallback:(apm_crash_callback)callback;

@end

