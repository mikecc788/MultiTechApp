//
//  LFSSetCircleView.h
//  AirSmart
//
//  Created by app on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFSSetCircleView : UIView
-(instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth;
@property(nonatomic,strong)NSString *value;
@end

NS_ASSUME_NONNULL_END
