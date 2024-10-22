//
//  PageCollectionView.h
//  TestFeel
//
//  Created by app on 2022/10/28.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView/JXCategoryView.h>
NS_ASSUME_NONNULL_BEGIN

@interface PageCollectionView : UIView<JXCategoryListContentViewDelegate>
@property (strong , nonatomic)UICollectionView *collectionView;
-(void)setDevice:(NSMutableArray*)device type:(LFSProductType)type;
@end

NS_ASSUME_NONNULL_END
