//
//  AppDelegate.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "AppDelegate.h"
#import "APMHomeViewController.h"
/**
 可复制部分开始---
 Copyable section starts ---
 */
#import <RangersAPM.h>
#import <RangersAPM+DebugLog.h>
/**
 ---可复制部分结束
 --- Copyable section ends
 */

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /**
     可以把这部分初始化代码copy到您的工程中，建议初始化时机尽量靠前，否则可能出现启动崩溃无法捕获，或者启动分析数据产生误差
     ⚠️注意：①在复制此部分代码前请先参考Podfile文件，引入对应的组件
            ②导入头文件
            ③请修改config对应的属性值
                appID：平台为APP分配的ID
                channel：APP的发布渠道
     
     You can copy the initialization code as follows to the same part in your project.
     And I suggest the code be excuted as early as possible. Otherwise, the crash that occurs during App Launching may not be detected and there may be error in the data of launch analysis.
     ⚠️Tips: ① Before you copy the code, please read the Podfile and install necessary cocoapods components first.
             ② Import the header files.
             ③ Set the propertys of the variable named "config" with your own values.
                appID: the ID of your App on APMInsight
                channel: the channel you App will publish to
     */
    /**
     必要部分 ！！！
     可复制部分开始---
     Necessary !!!
     Copyable section starts ---
     */
    
    RangersAPMConfig *config = [RangersAPMConfig configWithAppID:@"194767"];
    config.channel = @"App Store";
    config.deviceIDSource = RAPMDeviceIDSourceFromUser;
    
    /**
     输出控制台日志，需要导入头文件 RangersAPM+DebugLog.h
     Print console log, import RangersAPM+DebugLog.h first
     */
#if DEBUG
    [RangersAPM allowDebugLogUsingLogger:^(NSString * _Nonnull log) {
        NSLog(@"APMInsight Debug Log : %@", log);
    }];
#endif
    
    [RangersAPM startWithConfig:config];
    
    [RangersAPM setDeviceID:@"MYDEVICEID194767"];
    
    [RangersAPM setUserID:@"MYUSERID194767"];
    
    /**
     ---可复制部分结束
     --- Copyable section ends
     */
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    APMHomeViewController * controller = [[APMHomeViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
