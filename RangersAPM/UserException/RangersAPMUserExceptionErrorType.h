//
//  RangersAPMUserExceptionErrorType.h
//  HeimdallrFinder
//
//  Created by xuminghao.eric on 2020/10/22.
//

#ifndef RangersAPMUserExceptionErrorType_h
#define RangersAPMUserExceptionErrorType_h

typedef void (^RangersAPMUserExceptionCallback)(NSError *_Nullable error);

typedef NS_ENUM(NSInteger, RangersAPMUserExceptionFailType) {
    RangersAPMUserExceptionFailTypeNotWorking  = 1,     // user exception模块没有开启工作
    RangersAPMUserExceptionFailTypeMissingType = 2,     // 类型缺失
    RangersAPMUserExceptionFailTypeExceedsLimiting = 3, // 超出客户端限流，1min内同一种类型的自定义异常不可以超过1条
    RangersAPMUserExceptionFailTypeInsertFail = 4,      // 写入数据库失败
    RangersAPMUserExceptionFailTypeParamsMissing = 5,   // 参数缺失
    RangersAPMUserExceptionFailTypeBlockList = 6,       // 命中黑名单
    RangersAPMUserExceptionFailTypeLog = 7,             // 日志生成失败
};


#endif /* RangersAPMUserExceptionErrorType_h */
