//
//  RangersAPM+PrivatizationDeployment.h
//  HeimdallrFinder
//
//  Created by xuminghao.eric on 2020/11/17.
//

#import "RangersAPM.h"

NS_ASSUME_NONNULL_BEGIN

@interface RangersAPM (PrivatizationDeployment)

/*! @abstract 设置私有化部署域名
 @param domain 私有化部署的域名
 */
+ (void)setupRequestURLWithUserDomain:(NSString *)domain;

@end

NS_ASSUME_NONNULL_END
