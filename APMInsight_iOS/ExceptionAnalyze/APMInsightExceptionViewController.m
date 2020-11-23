//
//  APMInsightExceptionViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightExceptionViewController.h"
#import "APMInsightCellItem.h"
#if __has_include(<RangersAPM+UserException.h>)
#import <RangersAPM+UserException.h>
#endif

static NSString *const kExceptionTypePlaceholder = @"ExceptionType, Default:ExceptionTypeTest";
static NSString *const kCustomKeyPlaceholder = @"CustomKey, Default:customKeyDemoTest";
static NSString *const kCustomValuePlaceholder = @"CustomValue, Default:customValueDemoTest";
static NSString *const kFilterKeyPlaceholder = @"FilterKey, Default:filterKeyDemoTest";
static NSString *const kFilterValuePlaceholder = @"FilterValue, Default:filterValueDemoTest";
static NSString *const kDefaultAppIDPlaceholder = @"AppID, Default:";
static NSString *const kDefaultAppID = @"200534";

static NSString *const kUserNetworkErrorPlaceholder = @"https://www.ababaabb.com";

static NSInteger kExceptionCounts = 0;

typedef void (^manualUserExceptionAlertHandler)(NSString *exceptionType, NSString *customKey, NSString *customValue, NSString *filterKey, NSString *filterValue, NSString *appID);

@interface APMInsightExceptionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightExceptionViewController

#pragma mark - Test cases

- (void)recordUserException:(NSString *)exceptionType customs:(NSDictionary *)customs filters:(NSDictionary *)filters appID:(NSString *)appID callback:(RangersAPMUserExceptionCallback)callback {
#if __has_include(<RangersAPM+UserException.h>)
    [RangersAPM trackAllThreadsLogExceptionType:exceptionType skippedDepth:0 customParams:customs filters:filters callback:^(NSError * _Nullable error) {
        callback(error);
    } appID:appID];
#endif
}

- (void)userExceptionTrigger {
    BOOL __block success = YES;
    NSInteger exceptionCountsAfterRecord = kExceptionCounts + 5; //由于短时间内无法记录相同的错误，维护一个全局变量，以错误次数作为后缀
    for (NSInteger i = kExceptionCounts; i < exceptionCountsAfterRecord; i++) {
        [self recordUserException:[NSString stringWithFormat:@"ExceptionTypeDemoTest%ld", i] customs:@{@"customKeyDemoTest":@"customValueDemoTest"} filters:@{@"filterKeyDemoTest":@"filterValueDemooTest"} appID:kDefaultAppID callback:^(NSError * _Nullable error) {
            if (error) {
                success = NO;
            }
        }];
    }
    kExceptionCounts = exceptionCountsAfterRecord;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误记录上报成功" message:@"请到APMInsight平台查看上报的自定义错误日志" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误记录上报失败" message:@"请重新尝试或手动触发" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
}

- (void)manualUserExceptionTrigger {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [self userExceptionAlertWithOKHandler:^(NSString *exceptionType, NSString *customKey, NSString *customValue, NSString *filterKey, NSString *filterValue, NSString *appID) {
            [self recordUserException:exceptionType customs:@{customKey:customValue} filters:@{filterKey:filterValue} appID:appID callback:^(NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义错误记录失败" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alert addAction:action];
                            [self presentViewController:alert animated:YES completion:nil];
                        } else {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义错误记录成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alert addAction:action];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    });
            }];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)networkErrorTrigger {
    NSString __block *urlString = @"https://www.ababaabb.com";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络错误" message:@"请输入能够触发错误的URL，如果不输入将使用默认值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UITextField *textField in alert.textFields) {
            if ([textField.placeholder isEqualToString:kUserNetworkErrorPlaceholder]) {
                urlString = textField.text ?: urlString;
            }
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"网络错误记录成功" message:@"请把APP退到后台以触发上报，稍后即可在平台上看到网络错误日志" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [successAlert addAction:action];
                [self presentViewController:successAlert animated:YES completion:nil];
            });
        }] resume];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kUserNetworkErrorPlaceholder;
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightExceptionCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"错误分析";
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightExceptionCell"];
    APMInsightCellItem *item = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",item.title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    APMInsightCellItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.selectBlock) {
        item.selectBlock();
    }
}

#pragma mark - Lazy-load
- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        __weak typeof(self) weakSelf = self;
        void(^userExceptionBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf userExceptionTrigger];
            }
        };
        APMInsightCellItem *userExceptionItem = [APMInsightCellItem itemWithTitle:@"记录五次自定义错误并上报" block:userExceptionBlock];
        
        void(^manualUserExceptionBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf manualUserExceptionTrigger];
            }
        };
        APMInsightCellItem *manualUserExceptionItem = [APMInsightCellItem itemWithTitle:@"手动记录自定义错误(五次记录触发一次上报)" block:manualUserExceptionBlock];
        
        void(^networkErrorBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf networkErrorTrigger];
            }
        };
        APMInsightCellItem *networkErrorItem = [APMInsightCellItem itemWithTitle:@"触发网络错误" block:networkErrorBlock];
        
        [_items addObject:userExceptionItem];
        [_items addObject:manualUserExceptionItem];
        [_items addObject:networkErrorItem];
    }
    return _items;
}

- (UIAlertController *)userExceptionAlertWithOKHandler:(manualUserExceptionAlertHandler)okHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"定制自定义错误" message:@"请输入自定义信息，不输入则使用默认值" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *exceptionType;
        NSString *customKey;
        NSString *customValue;
        NSString *filterKey;
        NSString *filterValue;
        NSString *aid;
        for (UITextField *text in alert.textFields) {
            if ([text.placeholder isEqualToString:kExceptionTypePlaceholder]) {
                exceptionType = [NSString stringWithString:(text.text.length ? text.text : @"ExceptionTypeTest")];
                continue;;
            }
            if ([text.placeholder isEqualToString:kCustomKeyPlaceholder]) {
                customKey = [NSString stringWithString:(text.text.length ? text.text : @"customKeyTest")];
                continue;;
            }
            if ([text.placeholder isEqualToString:kCustomValuePlaceholder]) {
                customValue = [NSString stringWithString:(text.text.length ? text.text : @"customValueTest")];
                continue;;
            }
            if ([text.placeholder isEqualToString:kFilterKeyPlaceholder]) {
                filterKey = [NSString stringWithString:(text.text.length ? text.text : @"filterKeyTest")];
                continue;;
            }
            if ([text.placeholder isEqualToString:kFilterValuePlaceholder]) {
                filterValue = [NSString stringWithString:(text.text.length ? text.text : @"filterValueTest")];
                continue;;
            }
            if ([text.placeholder isEqualToString:[NSString stringWithFormat:@"%@%@",kDefaultAppIDPlaceholder, kDefaultAppID]]) {
                aid = [NSString stringWithString:(text.text.length ? text.text : kDefaultAppID)];
                continue;;
            }
        }
        
        okHandler(exceptionType, customKey, customValue, filterKey, filterValue, aid);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kExceptionTypePlaceholder;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kCustomKeyPlaceholder;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kCustomValuePlaceholder;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kFilterKeyPlaceholder;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = kFilterValuePlaceholder;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"%@%@",kDefaultAppIDPlaceholder, kDefaultAppID];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    return alert;
}

@end
