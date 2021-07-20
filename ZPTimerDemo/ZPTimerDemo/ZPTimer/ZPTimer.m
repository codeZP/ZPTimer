//
//  ZPTimer.m
//  ZPTimerDemo
//
//  Created by ZhiLian on 2021/7/20.
//

#import "ZPTimer.h"

NSMutableDictionary *names_;
dispatch_semaphore_t semaphore_;

@implementation ZPTimer

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        names_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)timeWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async block:(void (^)(void))block {
    if (!block || start < 0 || (interval <= 0 && repeats)) return nil;
    
    dispatch_queue_t queue = async ? dispatch_queue_create("zpTime", DISPATCH_QUEUE_CONCURRENT) : dispatch_get_main_queue();
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *name = [NSString stringWithFormat:@"%zd", names_.count];
    names_[name] = timer;
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        block();
        if (!repeats) {
            dispatch_source_cancel(timer);
        }
    });
    dispatch_resume(timer);
    
    return name;
}

+ (NSString *)timeWithTarget:(id)target start:(NSTimeInterval)start action:(SEL)action interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    if (!self || !action) return nil;
    
    return [self timeWithStart:start interval:interval repeats:repeats async:async block:^{
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:action];
#pragma clang diagnostic pop
        }
    }];
}

+ (void)cancleTimer:(NSString *)name {
    if (name.length == 0) return;
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t time = names_[name];
    if (time) {
        dispatch_source_cancel(time);
        [names_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end
