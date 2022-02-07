//
//  APMInsightCaptureUITestViewController.m
//  APMInsight_iOS
//
//  Created by Jerry on 2022/1/30.
//

#import "APMInsightCaptureUITestViewController.h"
#import "APMInsightLeakedObject.h"

@interface APMInsightCaptureUITestViewController ()

@end

@implementation APMInsightCaptureUITestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Action
- (IBAction)memoryTriggerAction:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"触发内存泄漏" message:@"点击确定开始触发Leaked类型OOM崩溃，APP将闪退，稍后重新启动APP即可在平台上看到崩溃日志" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (int index = 0; index < 500; index++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
                APMInsightLeakedObject *leakedObject = [[APMInsightLeakedObject alloc] initWithName:[NSString stringWithFormat:@"APMInsightLeakedObject index = %d", index]];
#pragma clang diagnostic pop
                
                if (0 != index && 0 == index % 100) {
                    sleep(1);
                }
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
