//
//  AESCipher.m
//  TestFeel
//
//  Created by app on 2024/6/19.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "AESCipher.h"
static NSString *const publicKey = @"7e1ae39d4c8d9a0a83c7a8b12df13863";

@implementation AESCipher

+ (NSString *)aesEncryptString:(NSString *)content {
    return [self aesEncryptString:content withKey:publicKey];
}

+ (NSString *)aesDecryptString:(NSString *)content {
    return [self aesDecryptString:content withKey:publicKey];
}

+ (NSString *)aesEncryptString:(NSString *)content withKey:(NSString *)key {
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [self dataWithHexstring:key];
    NSData *encryptedData = [self aesEncryptData:contentData withKey:keyData];
    return [self hexStringFromData:encryptedData];
}

+ (NSString *)aesDecryptString:(NSString *)content withKey:(NSString *)key {
    NSData *contentData = [self dataForHexString:content];
    NSData *keyData = [self dataWithHexstring:key];
    NSData *decryptedData = [self aesDecryptData:contentData withKey:keyData];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (NSData *)aesEncryptData:(NSData *)contentData withKey:(NSData *)keyData {
    return [self cipherAction:contentData withKey:keyData withOperation:kCCEncrypt];
}

+ (NSData *)aesDecryptData:(NSData *)contentData withKey:(NSData *)keyData {
    return [self cipherAction:contentData withKey:keyData withOperation:kCCDecrypt];
}

+ (NSData *)cipherAction:(NSData *)contentData withKey:(NSData *)keyData withOperation:(CCOperation)operation {
    NSUInteger dataLength = contentData.length;

    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;

    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesProcessed = 0;

    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyBytes,
                                          kCCKeySizeAES256,
                                          NULL, // ECB mode does not use an IV
                                          contentBytes,
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

+ (NSData *)dataForHexString:(NSString *)hexString {
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:hexString.length / 2];
    unsigned char wholeByte;
    char byteChars[3] = {'\0', '\0', '\0'};
    int i;
    for (i = 0; i < [hexString length] / 2; i++) {
        byteChars[0] = [hexString characterAtIndex:i * 2];
        byteChars[1] = [hexString characterAtIndex:i * 2 + 1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)data {
    const unsigned char *dataBytes = [data bytes];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:data.length * 2];
    for (NSInteger i = 0; i < data.length; i++) {
        [hexString appendFormat:@"%02lx", (unsigned long)dataBytes[i]];
    }
    return [hexString copy];
}

+(NSData*)dataWithHexstring:(NSString *)hexstring{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for(idx = 0; idx + 2 <= hexstring.length; idx += 2){
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


@end

