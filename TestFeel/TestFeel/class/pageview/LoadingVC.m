//
//  LoadingVC.m
//  TestFeel
//
//  Created by app on 2022/12/9.
//

#import "LoadingVC.h"
#import "CountDown.h"
#import "MBProgressHUD+Extension.h"
@interface LoadingVC ()
@property (strong, nonatomic)  CountDown *countDown;
@end

@implementation LoadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.countDown = [[CountDown alloc] init];
    __block int count = 30;
    [self.countDown countDownWithPER_SECBlock:^{
        NSLog(@"6");
        count--;
    }];
    NSLog(@"count=%d",count);
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showToast:[NSString stringWithFormat:@"aaa%d",count] ToView:self.view];
    
}


@end
