//
//  AES128Util.h
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES128Util : NSObject
+ (NSString *)encryptData:(NSString *)data;
+ (NSString *)decryptData:(NSString *)hexString;
//解密
+ (NSData *)decryptDataTwo:(NSData *)data;
+ (NSData *)encryptDataTwo:(NSString *)data;

+ (NSString *)xorHexString:(NSString *)hex1 withHexString:(NSString *)hex2;
+ (NSString *)decryptData:(NSString *)hexString time:(NSString*)time;
@end

NS_ASSUME_NONNULL_END
