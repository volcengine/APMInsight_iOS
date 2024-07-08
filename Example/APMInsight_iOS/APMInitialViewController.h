//
//  APMInitialViewController.h
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2023/5/22.
//

#import <UIKit/UIKit.h>
#import <RangersAPM.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInitialViewController : UIViewController

@property (nonatomic, strong, class) RangersAPMConfig *config;

@end

NS_ASSUME_NONNULL_END
