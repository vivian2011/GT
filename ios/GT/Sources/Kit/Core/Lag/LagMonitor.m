#import "LagMonitor.h"
#import "BacktraceLogger.h"

@interface LagMonitor ()
{
    int timeoutCount;
    CFRunLoopObserverRef observer;
    
@public
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}
@end

@implementation LagMonitor

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    LagMonitor *moniotr = (__bridge LagMonitor*)info;
    // 记录状态值
    moniotr->activity = activity;
    // 发送信号
    dispatch_semaphore_t semaphore = moniotr->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)stopMonitor
{
    if (!observer)
        return;
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    CFRelease(observer);
    observer = NULL;
}

- (void)startMonitor
{

    if (observer)
        return;
    
    // 创建信号,Dispatch Semaphore保证同步
    semaphore = dispatch_semaphore_create(0);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    observer = CFRunLoopObserverCreate(kCFAllocatorDefault,     //选择默认分配器
                                       kCFRunLoopAllActivities,  //配置观察者监听Run Loop的所有状态
                                       YES, //yes:runloop每次运行都监听，no：只监听一次
                                       0,       //设置优先级，0为最高优先级
                                       &runLoopObserverCallBack, //回调函数
                                       &context); //观察者上下文
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 在子线程监控时长 开启一个持续的loop用来进行监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES)
        {
            //假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms，等待超时返回为非0，信号量达到则返回为0
            long st = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0)
            {
                if (!observer)
                {
                    timeoutCount = 0;
                    semaphore = 0;
                    activity = 0;
                    return;
                }
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (activity==kCFRunLoopBeforeSources || activity==kCFRunLoopAfterWaiting)
                {
                    if (++timeoutCount < 5){
                        continue;
                    }else{
                        //检测到卡顿上报并记录
                        NSLog(@"此处发生卡顿，卡顿堆栈打印开始：------");
                        [BacktraceLogger lxd_logMain];
                        NSLog(@"此处发生卡顿，卡顿堆栈打印结束：------");
                    }
                    
                }//end activity
            }// end semaphore wait
            timeoutCount = 0;
        }// end while
    });
}

@end
