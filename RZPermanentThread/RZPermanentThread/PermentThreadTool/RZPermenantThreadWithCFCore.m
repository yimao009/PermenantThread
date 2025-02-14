//
//  RZPermenantThreadWithCFCore.m
//  RZPermenantThread
//
//  Created by GRZ on 2025/2/13.
//

#import "RZPermenantThreadWithCFCore.h"
//@interface GRZThreadWithC : NSThread
//@end
//@implementation GRZThreadWithC
//
//- (void)dealloc
//{
//    NSLog(@"GRZThreadWithC dealloc %s", __func__);
//}
//@end

@interface RZPermenantThreadWithCFCore ()
@property (nonatomic, strong) NSThread *innerThread;
@end
@implementation RZPermenantThreadWithCFCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.innerThread = [[NSThread alloc] initWithBlock:^{
            NSLog(@"begin");
            // 创建上下文
            CFRunLoopSourceContext context = {0};
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(CFAllocatorGetDefault(), 0, &context);
            // 把source加到Runloop
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            CFRelease(source);
            
            // 启动RunLoop
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            NSLog(@"end");
        }];
        // 默认启动
        [self.innerThread start];
    }
    return self;
}

#pragma mark -Public
- (void)stop
{
    if (!self.innerThread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)executeTaskWithBlock:(void (^)(void))block
{
    if (!self.innerThread && !block) {
        return;
    }
    [self performSelector:@selector(__executeBlock:) onThread:self.innerThread withObject:block waitUntilDone:NO];
}

- (void)start
{
    if (!self.innerThread) {
        return;
    }
    [self.innerThread start];
}

- (void)dealloc
{
    [self stop];
    NSLog(@"RZPermenantThreadWithCFCore dealloc %s", __func__);
}

#pragma mark -Private

- (void)__stop {
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.innerThread = nil;
}

- (void)__executeBlock:(void (^)(void))block
{
    block();
}

@end
