//
//  CircleConfigure.h
//  TestFeel
//
//  Created by app on 2024/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleConfigure : NSObject
/** 渐变色方向 起始坐标 */
@property (nonatomic, assign) CGPoint startPoint;
/** 渐变色方向 结束坐标 */
@property (nonatomic, assign) CGPoint endPoint;
/** 渐变色的颜色数组 */
@property (nonatomic, strong) NSArray *colorArr;
/** 每个颜色的起始位置数组 注:每个元素 0 <= item < 1 */
@property (nonatomic, strong) NSArray *colorSize;
//注意: colorArr.count 和 colorSize.count 必须相等
//不相等时,渐变色最终显示出来的样子和期望的会有差异
@end

NS_ASSUME_NONNULL_END
