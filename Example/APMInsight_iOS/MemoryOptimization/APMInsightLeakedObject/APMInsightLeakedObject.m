//
//  APMInsightLeakedObject.m
//  MemoryGraphDemo
//
//  Created by bytedance on 2021/10/19.
//

#import "APMInsightLeakedObject.h"
#import "APMInsightLargeObject.h"
#import <UIKit/UIKit.h>

@interface APMInsightLeakedObject ()

@property (nonatomic, strong) APMInsightLargeObject *largeObject;

@end

@implementation APMInsightLeakedObject

- (void)dealloc {
    NSLog(@"%s;", __func__);
}

- (instancetype)initWithName:(NSString *)name {
    if (self) {
        self.name = name;
        self.helpManager = [NSObject new];
        self.largeObject = [[APMInsightLargeObject alloc] initWithLeakedObject:YES];
    }
    return self;
}

@end
