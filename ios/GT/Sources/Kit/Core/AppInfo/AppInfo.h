//
//  AppInfo.h
//  GT
//
//  Created by MOMO on 2018/10/16.
//  Copyright © 2018年 wstt. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface AppInfo : NSObject

/// 获取设备版本号
+ (NSString *)getDeviceName;

/// 获取iPhone名称
+ (NSString *)getiPhoneName;

/// 获取app版本号
+ (NSString *)getAPPVerion;

/// 当前系统名称
+ (NSString *)getSystemName;

/// 当前系统版本号
+ (NSString *)getSystemVersion;

/// 通用唯一识别码UUID
+ (NSString *)getUUID;

//获取应用名称
+ (NSString *)getAppName;

/// 获取内部build版本号
+ (NSString *)getBuildVerion;

@end
