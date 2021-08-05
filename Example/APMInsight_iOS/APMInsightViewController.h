//
//  APMInsightViewController.h
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2021/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInsightViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSString *vcTitle;

- (void)setupItems;

@end

NS_ASSUME_NONNULL_END
