//
//  RefreshDeviceBaseVC.h
//  TestFeel
//
//  Created by app on 2022/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshDeviceBaseVC : UICollectionViewController
@property (nonatomic, strong) UINavigationController *naviController;
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);
- (void)loadDataForFirst;

@end

NS_ASSUME_NONNULL_END
