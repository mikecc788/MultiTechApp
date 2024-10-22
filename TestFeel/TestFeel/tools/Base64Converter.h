//
//  Base64Converter.h
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Base64Converter : NSObject
+ (NSString *)hexStringFromBase64String:(NSString *)base64String;
+ (NSData *)dataWithHexString:(NSString *)hexString;
+ (NSString *)base64StringFromHexString:(NSString *)hexString;
+ (NSString *)hexStringFromData:(NSData *)data;
+ (NSString *)xorHexString:(NSString *)hex1 withHexString:(NSString *)hex2;
@end

NS_ASSUME_NONNULL_END
