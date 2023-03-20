//
//  main.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#if __has_include(<RangersAPM+PerformanceAPI.h>)
#import <RangersAPM+PerformanceAPI.h>
#endif

int main(int argc, char * argv[]) {
#if __has_include(<RangersAPM+PerformanceAPI.h>)
    [RangersAPM prewarmCheckStart];
#endif
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
