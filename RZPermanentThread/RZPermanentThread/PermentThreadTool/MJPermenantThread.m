//
//  MJPermenantThread.m
//  RunLoopDemo
//
//  Created by GRZ on 2025/2/13.
//

#import "MJPermenantThread.h"

//@interface GRZThread : NSThread
//@end
//@implementation GRZThread
//
//- (void)dealloc
//{
//    NSLog(@"GRZThread dealloc %s", __func__);
//}
//
//@end

@interface MJPermenantThread ()
@property (nonatomic, strong) NSThread *innerThread;
@property (nonatomic, assign, getter=isStoped) BOOL stoped;
@end
@implementation MJPermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stoped = NO;
        
        __weak typeof(self) weakSelf = self;
        
        self.innerThread = [[NSThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            
//            CFRunLoopRunInMode(<#CFRunLoopMode mode#>, <#CFTimeInterval seconds#>, <#Boolean returnAfterSourceHandled#>)
            
            while (weakSelf && !weakSelf.isStoped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]];
            }
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
    NSLog(@"MJPermenantThread dealloc %s", __func__);
}

#pragma mark -Private

- (void)__stop {
    self.stoped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.innerThread = nil;
}

- (void)__executeBlock:(void (^)(void))block
{
    block();
}

@end
