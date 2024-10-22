//
//  RadarController.m
//  TestFeel
//
//  Created by app on 2023/2/13.
//

#import "RadarController.h"
#import "LFSSetTextField.h"
@interface RadarController ()

@end

@implementation RadarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    LFSSetTextField *field = [[LFSSetTextField alloc]initWithFrame:CGRectMake(100, 100, 60, 40)];
    [self.view addSubview:field];
    
}


@end
