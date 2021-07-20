//
//  ZPTimer.h
//  ZPTimerDemo
//
//  Created by ZhiLian on 2021/7/20.
//

#import <Foundation/Foundation.h>

@interface ZPTimer : NSObject


/// 创造定时器方法
/// @param start 开始时间
/// @param interval 间隔时间
/// @param repeats 是否重复
/// @param async 是否异步
/// @param block 任务
+ (NSString *)timeWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async block:(void(^)(void))block;

/// 创造定时器方法
/// @param target 目标
/// @param action 方法
/// @param interval 间隔时间
/// @param repeats 是否重复
/// @param async 是否异步
+ (NSString *)timeWithTarget:(id)target start:(NSTimeInterval)start action:(SEL)action interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async;

/// 取消定时器
/// @param name 要取消的定时器标识（创建定时器返回）
+ (void)cancleTimer:(NSString *)name;

@end
