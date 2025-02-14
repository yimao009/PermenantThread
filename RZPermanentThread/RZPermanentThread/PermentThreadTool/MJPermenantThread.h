//
//  MJPermenantThread.h
//  RunLoopDemo
//
//  Created by GRZ on 2025/2/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MJPermenantThreadBlock)(void);
/**
 线程保活封装📦
 */
@interface MJPermenantThread : NSObject

- (void)start;

- (void)executeTaskWithBlock:(void(^)(void))block;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
