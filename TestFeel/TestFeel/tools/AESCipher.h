//
//  AESCipher.h
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESCipher : NSObject
+(NSString*)aesEncryptString:(NSString *)content;

+(NSString*)aesDecryptString:(NSString*)content;

+(NSString *)aesEncryptString:(NSString *)content withKey:(NSString *)key;

+(NSString *)aesDecryptString:(NSString *)content withKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
