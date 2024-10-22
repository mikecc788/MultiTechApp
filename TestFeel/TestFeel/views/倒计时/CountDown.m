//
//  CountDown.m
//  TestFeel
//
//  Created by app on 2022/12/9.
//

#import "CountDown.h"
@interface CountDown ()
@property(nonatomic,retain) dispatch_source_t timer;

@end
@implementation CountDown
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock{
    if (_timer==nil) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    PER_SECBlock();
                });
            });
            dispatch_resume(_timer);
    }
}
/**
 *  主动销毁定时器
 *  @return 格式为年-月-日
 */
-(void)destoryTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
-(void)dealloc{
    NSLog(@"%s dealloc",object_getClassName(self));
}
@end
