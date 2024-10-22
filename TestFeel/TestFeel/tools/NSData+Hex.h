//
//  NSData+Hex.h
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Hex)
+ (NSData *)dataWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
