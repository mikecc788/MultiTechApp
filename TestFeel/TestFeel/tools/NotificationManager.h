//
//  NotificationManager.h
//  TestFeel
//
//  Created by app on 2024/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationManager : NSObject
+ (instancetype)sharedManager;
- (void)scheduleNotificationWithInterval:(NSInteger)interval;
- (void)checkNotificationAuthorizationWithCompletion:(void (^)(BOOL authorized))completion;
@end

NS_ASSUME_NONNULL_END
