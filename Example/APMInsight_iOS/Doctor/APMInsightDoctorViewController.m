//
//  APMInsightDoctorViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2024/7/8.
//

#import "APMInsightDoctorViewController.h"
#import "APMInitialViewController.h"
#import <RangersAPM+Doctor.h>

@interface APMInsightDoctorViewController ()

@end

@implementation APMInsightDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupItems {
    APMInsightCellItem *item = [[APMInsightCellItem alloc] init];
    NSString *appID = APMInitialViewController.config.appID;
    item.title = appID;
    item.selectBlock = ^{
        [self.navigationController pushViewController:[RangersAPM generateViewControllerWithAppID:appID] animated:YES];
    };
    [self.items addObject:item];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
