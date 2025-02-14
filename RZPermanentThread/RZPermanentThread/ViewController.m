//
//  ViewController.m
//  RZPermenantThread
//
//  Created by GRZ on 2025/2/13.
//

#import "ViewController.h"
#import "PermentThreadTool/RZPermenantThreadWithCFCore.h"
#import "PermentThreadTool/MJPermenantThread.h"
typedef void(^MJPermenantThreadBlock)(void);


@interface ViewController ()
@property (nonatomic, strong) RZPermenantThreadWithCFCore *pt_withCF;
@property (nonatomic, strong) MJPermenantThread *pt_withNS;

@property (nonatomic, assign) MJPermenantThreadBlock block;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pt_withCF = [[RZPermenantThreadWithCFCore alloc] init];
    
    self.block = ^{
        NSLog(@"123");
    };
    
    self.block();
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.block();
    NSLog(@"");
    [self.pt_withCF executeTaskWithBlock:^{
        NSLog(@"executeTaskWithBlock -- %@", [NSThread currentThread]);
    }];
}

@end
