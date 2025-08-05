//
//  AESCBCUtil.h
//  TestFeel
//
//  Created by app on 2024/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * AES CBC模式加密解密工具类
 * 使用固定的key和IV进行AES-128-CBC加密解密
 */
@interface AESCBCUtil : NSObject

// 使用固定密钥进行加密解密（不需要keyIndex参数）
+ (NSString *)encryptHexStringWithFixedKey:(NSString *)hexString;
+ (NSString *)decryptHexStringWithFixedKey:(NSString *)encryptedHexString;
+ (NSString *)encryptHexStringZeroPadding:(NSString *)hexString withKeyIndex:(NSInteger)keyIndex;
+ (NSString *)decryptHexStringZeroPadding:(NSString *)encryptedHexString withKeyIndex:(NSInteger)keyIndex;
@end

NS_ASSUME_NONNULL_END 
