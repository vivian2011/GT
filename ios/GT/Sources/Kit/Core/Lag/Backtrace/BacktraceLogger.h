//
//  BacktraceLogger.h
//  GT
//
//  Created by MOMO on 2018/10/17.
//  Copyright © 2018年 wstt. All rights reserved.
//


#import <Foundation/Foundation.h>

/*!
 *  @brief  线程堆栈上下文输出
 */
@interface BacktraceLogger : NSObject

+ (NSString *)lxd_backtraceOfAllThread;
+ (NSString *)lxd_backtraceOfMainThread;
+ (NSString *)lxd_backtraceOfCurrentThread;
+ (NSString *)lxd_backtraceOfNSThread:(NSThread *)thread;

+ (void)lxd_logMain;
+ (void)lxd_logCurrent;
+ (void)lxd_logAllThread;

@end
