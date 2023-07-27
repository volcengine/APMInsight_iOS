//
//  APMInsightCustomCloudHandler.m
//  APMInsight_iOS
//
//  Created by ByteDance on 2023/7/18.
//

#if __has_include(<RangersAPM+CloudCommand.h>)

#import "APMInsightCustomCloudHandler.h"

@implementation APMInsightCustomCloudHandler

+ (NSString *)cloudCommandIdentifier {
    return @"pull_file";
}

/// 创建用于执行指令的实例变量
+ (instancetype)createInstance {
    static APMInsightCustomCloudHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[APMInsightCustomCloudHandler alloc] init];
    });
    return handler;
}


/// 执行自定义命令
- (void)executeCustomCommandWithParams:(NSDictionary *)params completion:(RangersAPMCustomCommandCompletion)completion {
    
    RangersAPMCustomCommandResult *result = [[RangersAPMCustomCommandResult alloc] init];
    result.specificParams = @{@"aKey": @"aValue", @"bKey": @"bValue"};
    
    NSString *filePath = [params objectForKey:@"file_path"];
    if (!filePath || filePath.length == 0) {
        NSError *error = [NSError errorWithDomain:@"pull_file" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"pull file params is missing file_path."}];
        result.error = error;
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    NSString *toBeUplodFilePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:toBeUplodFilePath]) {
        NSError *error = [NSError errorWithDomain:@"pull_file" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"file is not exist."}];
        result.error = error;
        
        if (completion) {
            completion(result);
        }
        
        return;
    }
    
    result.data = [NSData dataWithContentsOfFile:toBeUplodFilePath];
    result.fileName = @"custom_file_name";
    if (completion) {
        completion(result);
    }
}

/// 上传结果到服务器成功
- (void)uploadCustomCommandResultSucceededWithParams:(NSDictionary *)params {
    NSLog(@"------ %s", __func__);
}

/// 上传结果到服务器失败
- (void)uploadCustomCommandResultFailedWithParams:(NSDictionary *)params error:(NSError *)error {
    NSLog(@"------ %s", __func__);
}

@end

#endif
