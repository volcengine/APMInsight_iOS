//
//  APMInsightAutoreleaseObject.m
//  MemoryGraphDemo
//
//  Created by bytedance on 2021/9/18.
//

#import "APMInsightAutoreleaseObject.h"
#import "APMInsightLargeObject.h"

@interface APMInsightAutoreleaseObject ()

@property (nonatomic, strong) APMInsightLargeObject *largeObject;

@end

@implementation APMInsightAutoreleaseObject

- (void)dealloc {
    NSLog(@"%s;", __func__);
} 

- (instancetype)initWithName:(NSString *)name {
    if (self) {
        self.name = name;
        self.helpManager = [NSObject new];
        self.largeObject = [[APMInsightLargeObject alloc] initWithLeakedObject:NO];
    }
    return self;
}

@end
