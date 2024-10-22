//
//  ViewController.m
//  TestFeel
//
//  Created by app on 2022/3/7.
//

#import "ViewController.h"
#import "NSObject+Extension.h"
#import "HYRadix.h"
#import "tools/ICUDataManager.h"
#import "AES128Util.h"
#import "MJExtension.h"
#import "HistoryDeviceModel.h"
#import "NotificationManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
//    [self testPass];
    [self test];
    
//    [self testNotice];
}
-(void)testPass{
    // 7e1ae39d4c8d9a0a83c7a8b12df13863
    //14180619120601000000000000000000
    // 661cfa8f4a8d9a0a83c7a8b12df13863
    //6a02e5845e8b9b0a83c7a8b12df13863
    NSString *hex1 = @"7e1ae39d4c8d9a0a83c7a8b12df13863";
    NSString *hex2 = @"14180619120601000000000000000000";
        
    NSString *xorResult = [AES128Util xorHexString:hex1 withHexString:hex2];
    NSLog(@"XOR Result: %@", xorResult);
    
    NSTimeInterval total = 600;
    NSLog(@"%.0f",total/60);
    
    
    NSString *hexString = @"1418080f0e0c2d";

    // 计算需要补零的个数
    NSUInteger targetLength = 32;
    NSUInteger zeroPaddingLength = targetLength - [hexString length];

    // 生成零的字符串
    NSString *zeroPadding = [@"" stringByPaddingToLength:zeroPaddingLength withString:@"0" startingAtIndex:0];

    // 拼接补零后的字符串
    NSString *paddedHexString = [hexString stringByAppendingString:zeroPadding];

    NSLog(@"补零后的字符串: %@ ==%ld", paddedHexString,paddedHexString.length);
    
}


-(void)checkNotificationAuthorization{
    [[NotificationManager sharedManager] checkNotificationAuthorizationWithCompletion:^(BOOL authorized) {
        if (authorized) {
            [self showAlertToSetInterval];
        } else {
            // 提示用户启用通知
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知权限未授权" message:@"请在设置中启用通知，以便接收应用通知。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:settingsAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
// 弹出设置时间间隔的对话框
- (void)showAlertToSetInterval {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置时间间隔" message:@"请输入通知的时间间隔（秒）" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"秒";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSInteger interval = [textField.text integerValue];
        if (interval > 0) {
            [[NotificationManager sharedManager] scheduleNotificationWithInterval:interval];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)testNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFileNotification:) name:@"FileNotification" object:nil];
}

// 通知处理方法
- (void)handleFileNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *fileName = userInfo[@"fileName"];
    NSString *filePath = userInfo[@"filePath"];
    
    NSLog(@"收到文件通知：文件名 = %@, 文件路径 = %@", fileName, filePath);
    
    // 这里可以进行相应的处理，例如显示文件内容等
}


-(void)test{
    NSString *test = @"e6180102005500000000000000005501040a7f8f000000000000000000000000";
    
    NSString *cipeher = [AES128Util encryptData:test];
    NSLog(@"cipeher1=%@",cipeher);
    
    NSString *dipeher = [AES128Util decryptData:@"1fa7d36216caa5c1df4d65e026bc1f6201e67387000000000000000000000000" time:@"14180a0f12061c000000000000000000"];
    NSLog(@"cipeher2=%@",dipeher);
}

- (void)dealloc {
    // 注销通知观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"FileNotification"
                                                  object:nil];
}


@end
