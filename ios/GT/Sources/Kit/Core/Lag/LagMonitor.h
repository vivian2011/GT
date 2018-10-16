//
//  LagMonitor.h
//  GT
//
//  Created by MOMO on 2018/10/16.
//  Copyright © 2018年 wstt. All rights reserved.
//
#ifndef GT_DEBUG_DISABLE

#import <Foundation/Foundation.h>
#import "GTDebugDef.h"
#import "GTParaOutDef.h"

@interface LagMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;
- (void)stopMonitor;

@end

#endif
