//
//  AES128Util.m
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import "AES128Util.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Base64Converter.h"
#import "NSData+Hex.h"
static NSString *const publicKey = @"7e1ae39d4c8d9a0a83c7a8b12df13863";
//static NSString *const publicKey = @"AES2024051714250";
@implementation AES128Util

//加密
+ (NSString *)encryptData:(NSString *)content{
    NSData *data = [NSData dataWithHexString:content];
    NSData *keyData = [NSData dataWithHexString:publicKey];
    NSData *encryptedData = [self aesOperation:kCCEncrypt onData:data key:keyData];
    NSString *testString = [Base64Converter hexStringFromData:encryptedData];
    return testString;
}

//解密
+ (NSString *)decryptData:(NSString *)hexString{
    NSData *keyData = [NSData dataWithHexString:publicKey];
    NSData *encryptedData = [NSData dataWithHexString:hexString];
    
    NSData *decryptedData = [self aesOperation:kCCDecrypt onData:encryptedData key:keyData];
    NSString *decryptedString =  [Base64Converter hexStringFromData:decryptedData];
    return decryptedString;
}

+ (NSData *)encryptDataTwo:(NSString *)data{
    NSData *keyData = [[NSData alloc] initWithBytes:[publicKey UTF8String] length:[publicKey length]];
    NSData *plainData = [[NSData alloc] initWithBytes:[data UTF8String] length:[data length]];

    return [self aesOperation:kCCEncrypt onData:plainData key:keyData];
}

//解密
+ (NSData *)decryptDataTwo:(NSData *)data{
    NSData *keyData = [[NSData alloc] initWithBytes:[publicKey UTF8String] length:[publicKey length]];
    
    return [self aesOperation:kCCDecrypt onData:data key:keyData];
}

+ (NSData *)aesOperation:(CCOperation)operation onData:(NSData *)data key:(NSData *)key {
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    size_t numBytesProcessed = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode,
                                          [key bytes],
                                          kCCKeySizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesProcessed);

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesProcessed];
    }

    free(buffer);
    return nil;
}
+ (NSString *)decryptData:(NSString *)hexString time:(NSString*)time{
    NSString *key = [Base64Converter xorHexString:publicKey withHexString:time];
    NSData *keyData = [NSData dataWithHexString:key];
    NSData *encryptedData = [NSData dataWithHexString:hexString];
    
    NSData *decryptedData = [self aesOperation:kCCDecrypt onData:encryptedData key:keyData];
    NSString *decryptedString =  [Base64Converter hexStringFromData:decryptedData];
    return decryptedString;
}

+ (NSString *)xorHexString:(NSString *)hex1 withHexString:(NSString *)hex2 {
    if (hex1.length != hex2.length) {
        return nil;  // 如果两个字符串长度不相等，则返回nil
    }

    NSMutableString *result = [NSMutableString stringWithCapacity:hex1.length];

    for (NSInteger i = 0; i < hex1.length; i += 2) {
        NSString *hexChar1 = [hex1 substringWithRange:NSMakeRange(i, 2)];
        NSString *hexChar2 = [hex2 substringWithRange:NSMakeRange(i, 2)];

        unsigned int int1, int2;
        [[NSScanner scannerWithString:hexChar1] scanHexInt:&int1];
        [[NSScanner scannerWithString:hexChar2] scanHexInt:&int2];

        unsigned int xorResult = int1 ^ int2;

        [result appendFormat:@"%02x", xorResult];
    }

    return [result copy];
}

@end
