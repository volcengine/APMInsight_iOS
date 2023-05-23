//
//  AppDelegate.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "AppDelegate.h"
#import "APMInitialViewController.h"
/**
 可复制部分开始---
 Copyable section starts ---
 */
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
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    APMInitialViewController * controller = [[APMInitialViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
