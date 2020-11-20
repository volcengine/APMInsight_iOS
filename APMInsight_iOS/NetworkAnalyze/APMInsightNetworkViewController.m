//
//  APMInsightNetworkViewController.m
//  APMInsight_iOS
//
//  Created by xuminghao.eric on 2020/11/12.
//

#import "APMInsightNetworkViewController.h"
#import "APMInsightCellItem.h"

static NSString *const kUserRequestPlaceholder = @"请输入完整的URL，默认：https://www.baidu.com";

@interface APMInsightNetworkViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *items;

@end

@implementation APMInsightNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"APMInsightNetworkCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    self.title = @"网络分析";
    // Do any additional setup after loading the view.
}

#pragma mark UITableViewDelegate, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APMInsightNetworkCell"];
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
- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        
        UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"请求成功" message:@"网络请求成功，请把APP切换到后台以触发日志上报，稍后即可在平台上看到网络统计" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [successAlert addAction:ok];
        
        __weak typeof(self) weakSelf = self;
        void(^requestBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
                [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (!error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf presentViewController:successAlert animated:YES completion:nil];
                        });
                    }
                }] resume];
            }
        };
        APMInsightCellItem *requestkItem = [APMInsightCellItem itemWithTitle:@"网络请求：https://www.baidu.com" block:requestBlock];
        
        void(^userRequestBlock)(void) = ^{
            __strong typeof(self) strongSelf = weakSelf;
            if (strongSelf) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义网络请求" message:@"示例 https://www.baidu.com" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *url = @"https://www.baidu.com";
                    for (UITextField *textField in alert.textFields) {
                        if ([textField.text isEqualToString:kUserRequestPlaceholder]) {
                            url = textField.text ?: url;
                            break;
                        }
                    }
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (!error) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [strongSelf presentViewController:successAlert animated:YES completion:nil];
                            });
                        }
                    }] resume];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:ok];
                [alert addAction:cancel];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = kUserRequestPlaceholder;
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf presentViewController:alert animated:YES completion:nil];
                });
            }
        };
        APMInsightCellItem *userRequestItem = [APMInsightCellItem itemWithTitle:@"自定义网络请求" block:userRequestBlock];
        
        [_items addObject:requestkItem];
        [_items addObject:userRequestItem];
    }
    return _items;
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
