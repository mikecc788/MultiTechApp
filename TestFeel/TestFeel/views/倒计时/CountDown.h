//
//  CountDown.h
//  TestFeel
//
//  Created by app on 2022/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountDown : NSObject
///每秒走一次，回调block
-(void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock;
-(void)destoryTimer;
@end

NS_ASSUME_NONNULL_END
