//
//  APMInsightWebViewController.h
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInsightWebViewController : UIViewController

+ (instancetype)webViewControllerWithURLString:(NSString *)urlString title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
