//
//  ViewController.m
//  ZPTimerDemo
//
//  Created by ZhiLian on 2021/7/20.
//

#import "ViewController.h"
#import "ZPTimer.h"

@interface ViewController ()
/** 名字 */
@property (nonatomic, strong) NSString *name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"begin");
    self.name = [ZPTimer timeWithStart:2.0 interval:1.0 repeats:YES async:YES block:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [ZPTimer cancleTimer:self.name];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    [ZPTimer cancleTimer:self.name];
}

@end
