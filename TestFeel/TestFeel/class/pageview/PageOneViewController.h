//
//  PageOneViewController.h
//  TestFeel
//
//  Created by app on 2022/10/25.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>
#import "JXCategoryListContainerView.h"
#import "RefreshDeviceBaseVC.h"
NS_ASSUME_NONNULL_BEGIN

@interface PageOneViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (strong , nonatomic)UICollectionView *collectionView;
@property (nonatomic, strong) UINavigationController *naviController;
@property (nonatomic, copy) void(^didScrollCallback)(UIScrollView *scrollView);
-(void)setDeviceType:(LFSProductType)type;
@end

NS_ASSUME_NONNULL_END
