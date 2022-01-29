//
//  APMInsightLeakedObject.h
//  MemoryGraphDemo
//
//  Created by bytedance on 2021/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInsightLeakedObject : NSObject

@property (nonatomic, strong) NSObject *helpManager;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
