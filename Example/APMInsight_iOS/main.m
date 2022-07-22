//
//  main.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <RangersAPM+PerformanceAPI.h>

int main(int argc, char * argv[]) {
    [RangersAPM prewarmCheckStart];
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
