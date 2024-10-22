//
//  BatteryViewController.m
//  TestFeel
//
//  Created by app on 2023/8/15.
//

#import "BatteryViewController.h"
#import "KSBatteryView.h"
@interface BatteryViewController ()
@property(nonatomic,strong)KSBatteryView *batteryV;
@end

@implementation BatteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    KSBatteryView *batteryV= [[KSBatteryView alloc]initWithFrame:CGRectMake(0,  150, SCREEN_WIDTH-80, 60) num:80];
    self.batteryV = batteryV;
    [self.view addSubview:batteryV];
    
}



@end
