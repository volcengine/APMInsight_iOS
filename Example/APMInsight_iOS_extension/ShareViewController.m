//
//  ShareViewController.m
//  APMInsight_iOS_extension
//
//  Created by xuminghao.eric on 2022/3/23.
//

#import "ShareViewController.h"
#import <RangersAPMForAPPExtension.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    /**
     可以把这部分初始化代码copy到您的工程中，建议初始化时机尽量靠前，否则可能出现启动崩溃无法捕获
     ⚠️注意：①在复制此部分代码前请先参考Podfile文件，引入对应的组件
            ②导入头文件
            ③请修改config对应的属性值
                appID：平台为APP分配的ID
                groupID：需要和主程序一致，以便读取共享空间
     
     You can copy the initialization code as follows to the same part in your project.
     And I suggest the code be excuted as early as possible. Otherwise, the crash that occurs during App Launching may not be detected.
     ⚠️Tips: ① Before you copy the code, please read the Podfile and install necessary cocoapods components first.
             ② Import the header files.
             ③ Set the propertys of the variable named "config" with your own values.
                appID: the ID of your App on APMInsight
                channel: the channel you App will publish to
                groupID: should be consistent with the host APP in order to read the shared space
     */
    /**
     必要部分 ！！！
     可复制部分开始---
     Necessary !!!
     Copyable section starts ---
     */
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         输出控制台日志
         Print console log
         */
#if DEBUG
        [RangersAPMForAPPExtension allowDebugLogUsingLogger:^(NSString * _Nonnull log) {
            NSLog(@"APMInsight Debug Log : %@", log);
        }];
#endif
        [RangersAPMForAPPExtension startWithGroupID:@"group.apminsight.APMInsight-iOS" forAppID:@"233805"];
    });
    /**
     ---可复制部分结束
     --- Copyable section ends
     */
    
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    /**
     测试崩溃捕获
     点击分享扩展程序的 Post 选项后，会执行如下代码，触发崩溃。之后启动 |主程序| 即可上报扩展程序的崩溃。
     */
    [[NSArray array] objectAtIndex:0];
    
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
