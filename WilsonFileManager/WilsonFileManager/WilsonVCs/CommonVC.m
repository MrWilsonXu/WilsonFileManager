//
//  CommonVC.m
//  WilsonFileManager
//
//  Created by Wilson on 2018/9/27.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "CommonVC.h"

@interface CommonVC ()

@end

@implementation CommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Common";
    self.view.backgroundColor = [UIColor whiteColor];
    [self testGCDGroup];
}

- (void)testGCDGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i = 0;
        for (; i < 100; i++) {
            NSString *str = @"kobe";
            i += str.length;
            [NSThread sleepForTimeInterval:0.1];
        }
        NSLog(@"%d", i);
        NSLog(@"For cycle complete");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Task 2 complete");
    });
    // 监听多个任务同步执行是否完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"All Task had completion");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
