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
#if __has_include(<RangersAPM+BootingProtect.h>)
#import <RangersAPM+BootingProtect.h>
#endif
#if __has_include(<RangersAPM+PerformanceAPI.h>)
#import <RangersAPM+PerformanceAPI.h>
#endif
/**
 ---可复制部分结束
 --- Copyable section ends
 */

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RangersAPM prewarmCheckEnd];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /**
     可以把这部分初始化代码copy到您的工程中，建议初始化时机尽量靠前，否则可能出现启动崩溃无法捕获，或者启动分析数据产生误差
     ⚠️注意：①在复制此部分代码前请先参考Podfile文件，引入对应的组件
            ②导入头文件
            ③请修改config对应的属性值
                appID：平台为APP分配的ID
                channel：APP的发布渠道
                groupID：需要和扩展程序一致，以便读取共享空间
     
     You can copy the initialization code as follows to the same part in your project.
     And I suggest the code be excuted as early as possible. Otherwise, the crash that occurs during App Launching may not be detected and there may be error in the data of launch analysis.
     ⚠️Tips: ① Before you copy the code, please read the Podfile and install necessary cocoapods components first.
             ② Import the header files.
             ③ Set the propertys of the variable named "config" with your own values.
                appID: the ID of your App on APMInsight
                channel: the channel you App will publish to
                groupID: should be consistent with the extension in order to read the shared space
     */
    /**
     必要部分 ！！！
     可复制部分开始---
     Necessary !!!
     Copyable section starts ---
     */
    
    RangersAPMConfig *config = [RangersAPMConfig configWithAppID:@"233805"];
    config.channel = @"App Store";
    config.deviceIDSource = RAPMDeviceIDSourceFromAPMService;
    config.groupID = @"group.volcengine.apmplus";  //如果不需要监控扩展程序，则不需要此行代码
    
    /**
     首次启动由于没有获取到配置，无法确定需要开启哪些功能模块。可以配置此属性，来决定首次启动默认需要开启的功能模块，仅对首次启动生效，一旦拉取到配置，下次启动就会先读取本地缓存的配置来决定。
     ⚠️注意:
     ①建议默认开启崩溃分析（RangersAPMCrashMonitorSwitch）、启动分析（RangersAPMLaunchMonitorSwitch）、网络分析（RangersAPMNetworkMonitorSwitch），避免一些和首次启动强相关的数据丢失
     ②配置默认开启模块后，新设备首次启动会默认打开这些模块，可能会出现平台上关闭了这些模块，但是依然有数据上报的情况，可能会给您的事件量造成意外的消耗；请根据您的应用情况灵活配置。
     
     Since the configuration is not obtained during the first startup, it is impossible to determine which function modules need to be enabled. This property can be configured to determine the function modules that need to be enabled by default for the first startup. It only takes effect for the first startup. Once the configuration is pulled, the next startup will read the configuration of the local cache to determine.
     ⚠️Tips:
     ① It is recommended to enable crash analysis (RangersAPMCrashMonitorSwitch), startup analysis (RangersAPMLaunchMonitorSwitch), and network analysis (RangersAPMNetworkMonitorSwitch) by default to avoid data loss that is strongly related to the first startup.
     ② After configuring the default enabled modules, these modules will be enabled by default when the new device is started for the first time. It may happen that these modules are closed on the platform, but there are still data reports, which may cause unexpected consumption of your event volume; please refer to Flexible configuration for your application.
     */
    config.defaultMonitors = RangersAPMCrashMonitorSwitch;
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
    
#if __has_include(<RangersAPM+BootingProtect.h>)
    [RangersAPM startProtectWithBootingThreshold:10 bootingCrashHandler:^(RangersAPMBootingInfo * _Nonnull info) {
        /**
         对连续异常的场景进行防护策略，这里的demo只输出了一些log，您可以在自己的应用中做一些本地缓存清理或其他策略。可以针对不同的异常发生次数制定不同的策略。
         
         Implement protection strategies for consecutive exceptions. The demo here only outputs some logs. You can do some local cache cleaning or other strategies in your own application. Different strategies can be formulated for different exception occurrence times.
         */
        if (info.consecutiveExceptionTimes >= 1) {
            NSLog(@"⚠️Consecutive exception 1 time");
        } else if (info.consecutiveExceptionTimes >= 3) {
            NSAssert(NO, @"⚠️Consecutive exception 3 times !!!");
        }
        
        /**
         除了对连续异常进行防护，您也可以针对不同的异常类型执行不同的防护策略。
         
         In addition to protecting against consecutive exceptions, you can also implement different protection strategies for different exception types.
         */
        if (info.crashTimes >= 1) {
            NSLog(@"⚠️Consecutive crash 1 time");
        }
        if (info.watchdogTimes >= 1) {
            NSLog(@"⚠️Consecutive watchdog 1 time");
        }
        if (info.OOMTimes >= 1) {
            NSLog(@"⚠️Consecutive oom 1 time");
        }
    }];
#endif
        
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
