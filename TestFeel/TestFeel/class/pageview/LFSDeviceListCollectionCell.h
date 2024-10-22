//
//  LFSDeviceListCollectionCell.h
//  FeelLife
//
//  Created by app on 2022/10/22.
//

#import <UIKit/UIKit.h>
#define kLFSDeviceListCollectionCellID @"kLFSDeviceListCollectionCellID"
NS_ASSUME_NONNULL_BEGIN

@interface LFSDeviceListCollectionCell : UICollectionViewCell
-(void)setTitle:(NSString*)title img:(NSString*)imgName;
@end

NS_ASSUME_NONNULL_END
