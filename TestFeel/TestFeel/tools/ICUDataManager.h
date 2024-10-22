//
//  ICUDataManager.h
//  TestFeel
//
//  Created by app on 2024/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ICUDataManager : NSObject
+ (instancetype)sharedManager;

- (void)initializeData;
- (void)saveString:(NSString *)string;
- (BOOL)isStringSaved:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
