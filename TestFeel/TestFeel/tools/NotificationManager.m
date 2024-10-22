//
//  NotificationManager.m
//  TestFeel
//
//  Created by app on 2024/7/30.
//

#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>
@implementation NotificationManager
+ (instancetype)sharedManager {
    static NotificationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)scheduleNotificationWithInterval:(NSInteger)interval {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // 创建通知内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"通知";
    content.body = @"Hello 11111";
    content.sound = [UNNotificationSound defaultSound];
    
    // 创建时间间隔触发器
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
    
    // 创建通知请求
    NSString *identifier = @"HelloNotification";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    // 添加通知请求
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error adding notification: %@", error.localizedDescription);
        } else {
            NSLog(@"Notification scheduled successfully with interval %ld seconds.", (long)interval);
        }
    }];
}

//检查授权
- (void)checkNotificationAuthorizationWithCompletion:(void (^)(BOOL authorized))completion {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        BOOL authorized = (settings.authorizationStatus == UNAuthorizationStatusAuthorized);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(authorized);
            }
        });
    }];
}


@end
