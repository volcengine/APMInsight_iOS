//
//  APMInsightAutoreleaseObject.h
//  MemoryGraphDemo
//
//  Created by bytedance on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APMInsightAutoreleaseObject : NSObject

@property (nonatomic, strong) NSObject *helpManager;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
