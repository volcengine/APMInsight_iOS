//
//  APMInsightALogViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2021/8/5.
//

#import "APMInsightALogViewController.h"
#if __has_include(<RangersAPM+ALog.h>)
#import "RangersAPM+ALog.h"
#endif
#import "APMInsightCellItem.h"

@implementation APMInsightALogViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellIdentifier = @"APMInsightALogCell";
        self.vcTitle = @"日志回捞";
#if __has_include(<RangersAPM+ALog.h>)
        [RangersAPM setALogEnabled];
        [RangersAPM enableConsoleLog];
#endif
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupItems {
    APMInsightCellItem *item = [[APMInsightCellItem alloc] init];
    item.title = @"记录一条日志";
    item.selectBlock = ^{
#if __has_include(<RangersAPM+ALog.h>)
        RANGERSAPM_ALOG_INFO(@"APMInsight", @"write a log");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"日志记录成功" message:@"在平台创建云控命令后，APP下一次切换至前台或重新启动后，会上报记录的日志" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
#endif
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
