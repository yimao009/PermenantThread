//
//  RZPermenantThreadWithCFCore.h
//  RZPermenantThread
//
//  Created by GRZ on 2025/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RZPermenantThreadWithCFCore : NSObject
- (void)start;

- (void)executeTaskWithBlock:(void(^)(void))block;

- (void)stop;
@end

NS_ASSUME_NONNULL_END
