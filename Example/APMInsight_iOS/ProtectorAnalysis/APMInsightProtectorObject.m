//
//  APMInsightProtectorObject.m
//  APMInsight_iOS
//
//  Created by bytedance on 2021/9/30.
//

#import "APMInsightProtectorObject.h"

@implementation APMInsightProtectorObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _subview = [UIView new];
        _number = @(0);
        [self.subview addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)dealloc {
    self.subview.frame = CGRectMake(0, 1, 2, 3);
    [self.subview removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@ get %@ keypath:(%@) context:(%p) change:%@ -> %@", self, object, keyPath, context, change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
}

@end
