//
//  APMInsightLargeObject.m
//  MemoryGraphDemo
//
//  Created by bytedance on 2021/10/19.
//

#import "APMInsightLargeObject.h"

@interface APMInsightInnerLargeObject : NSObject
{
    long *_nums;
}
@end

@implementation APMInsightInnerLargeObject

- (void)dealloc {
    [super dealloc];
    free(_nums);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /**
         * 申请内存块
         */
        _nums = (long *)malloc(sizeof(long) * 1024 * 1024);
        /**
         * 苹果对于内存块不设置的情况，认定为clean memory并不会真正的分配内存。
         * 因此，这里对申请的内存块进行设置值，变更为dirty memory。
         */
        for (int i = 0; i < 1024 * 1024; i++) {
            _nums[i] = i;
        }
    }
    return self;
}

@end


@interface APMInsightLargeObject ()
{
    BOOL _isLeaked;
}

@property (nonatomic, strong) APMInsightInnerLargeObject *largeObject;

@end

@implementation APMInsightLargeObject

- (void)dealloc {
    if (!_isLeaked) {
        [self.largeObject release];
    }
    
    [super dealloc];
}

- (instancetype)initWithLeakedObject:(BOOL)isLeaked {
    self = [super init];
    if (self) {
        _isLeaked = isLeaked;
        
        self.largeObject = [[APMInsightInnerLargeObject alloc] init];
    }
    return self;
}

@end
