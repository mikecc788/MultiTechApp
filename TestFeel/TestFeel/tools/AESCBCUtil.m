//
//  AESCBCUtil.m
//  TestFeel
//
//  Created by app on 2024/12/19.
//

#import "AESCBCUtil.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Base64Converter.h"
#import "NSData+Hex.h"



@implementation AESCBCUtil

// 本地密钥 (16字节) - 用于固定加密和与密钥池异或
static const unsigned char kAESKey[kCCKeySizeAES128] = {
    0xE4, 0xf5, 0x06, 0x17, 0x28, 0x39, 0x4A, 0x5B,
    0x6C, 0x7D, 0x11, 0x33, 0x55, 0x77, 0x99, 0xBB
};

// 固定的初始化向量 IV (16字节)
static const unsigned char kAESIV[kCCBlockSizeAES128] = {
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
};

// 密钥池数组 (10个密钥组，每个16字节)
+ (NSArray *)keyPool {
    static NSArray *keyPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyPool = @[
            @[@0x2B, @0x7E, @0x15, @0x16, @0x28, @0xAE, @0xD2, @0xA6, @0xAB, @0xF7, @0x15, @0x88, @0x09, @0xCF, @0x4F, @0x3C],
            @[@0x00, @0x01, @0x22, @0x33, @0x44, @0x55, @0x66, @0x77, @0x88, @0x99, @0xAA, @0xBB, @0xCC, @0xDD, @0xEE, @0xFF],
            @[@0xFF, @0xEE, @0xDD, @0xCC, @0xBB, @0xAA, @0x99, @0x88, @0x77, @0x66, @0x55, @0x44, @0x33, @0x22, @0x11, @0x00],
            @[@0x1A, @0xCF, @0x78, @0x34, @0x9D, @0xE0, @0x52, @0xB7, @0xAC, @0x6F, @0x05, @0x91, @0xBB, @0x2E, @0x48, @0x7C],
            @[@0xA0, @0xB1, @0xC2, @0xD3, @0xE4, @0xF5, @0x06, @0x17, @0x28, @0x39, @0x4A, @0x5B, @0x6C, @0x7D, @0x8E, @0x9F],
            @[@0xF0, @0x0E, @0x1D, @0x2C, @0x3B, @0x4A, @0x59, @0x68, @0x77, @0x86, @0x95, @0xA4, @0xB3, @0xC2, @0xD1, @0xE0],
            @[@0x09, @0x87, @0x65, @0x43, @0x21, @0x0F, @0xED, @0xCB, @0xA9, @0x87, @0x65, @0x43, @0x21, @0x0F, @0xED, @0xCB],
            @[@0x55, @0xAA, @0x55, @0xAA, @0x55, @0xAA, @0x55, @0xAA, @0x55, @0xAA, @0x55, @0xAA, @0x55, @0xAA, @0x55, @0xAA],
            @[@0x13, @0x57, @0x9B, @0xDF, @0x24, @0x68, @0xAC, @0xE0, @0x35, @0x79, @0xBD, @0x01, @0x46, @0x8A, @0xCE, @0x12],
            @[@0xC5, @0xE9, @0x0D, @0x31, @0x75, @0xB9, @0xFD, @0x21, @0x65, @0xA9, @0xD3, @0xB7, @0x9B, @0x5F, @0x23, @0x47]
        ];
    });
    return keyPool;
}

#pragma mark - 公共接口方法

+ (NSString *)encryptHexString:(NSString *)hexString {
    if (!hexString || hexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *sourceData = [NSData dataWithHexString:hexString];
    if (!sourceData) {
        return nil;
    }
    
    // 执行加密
    NSData *encryptedData = [self encryptData:sourceData];
    if (!encryptedData) {
        return nil;
    }
    
    // 将加密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:encryptedData];
}

+ (NSString *)decryptHexString:(NSString *)encryptedHexString {
    if (!encryptedHexString || encryptedHexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *encryptedData = [NSData dataWithHexString:encryptedHexString];
    if (!encryptedData) {
        return nil;
    }
    
    // 如果数据长度不是16字节的整数倍，则进行Zero填充
    NSData *paddedData = encryptedData;
    if (encryptedData.length % kCCBlockSizeAES128 != 0) {
        paddedData = [self zeroPadData:encryptedData];
        NSLog(@"AESCBCUtil: 固定密钥解密 - 输入数据长度不足，已补0填充。原长度: %lu，填充后: %lu", 
              (unsigned long)encryptedData.length, (unsigned long)paddedData.length);
    }
    
    // 执行解密（使用固定密钥）
    NSData *decryptedData = [self performAESOperationWithFixedKey:kCCDecrypt onData:paddedData];
    if (!decryptedData) {
        return nil;
    }
    
    // 移除Zero填充
    NSData *unpaddedData = [self removeZeroPadding:decryptedData];
    
    // 将解密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:unpaddedData];
}

+ (NSData *)encryptData:(NSData *)data {
    if (!data || data.length == 0) {
        return nil;
    }
    
    return [self performAESOperation:kCCEncrypt onData:data];
}

+ (NSData *)decryptData:(NSData *)encryptedData {
    if (!encryptedData || encryptedData.length == 0) {
        return nil;
    }
    
    return [self performAESOperation:kCCDecrypt onData:encryptedData];
}

#pragma mark - 私有核心加密方法

/**
 * 执行AES CBC模式的加密或解密操作
 * @param operation 操作类型 (kCCEncrypt 或 kCCDecrypt)
 * @param data 待处理的数据
 * @return 处理后的数据，失败返回nil
 */
+ (NSData *)performAESOperation:(CCOperation)operation onData:(NSData *)data {
    // 计算输出缓冲区大小
    size_t dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    if (!buffer) {
        NSLog(@"AESCBCUtil: 内存分配失败");
        return nil;
    }
    
    size_t numBytesProcessed = 0;
    
    // 执行AES CBC加密/解密
    CCCryptorStatus cryptStatus = CCCrypt(
        operation,                    // 操作类型 (加密/解密)
        kCCAlgorithmAES128,          // 算法类型 (AES-128)
        kCCOptionPKCS7Padding,       // 选项 (PKCS7填充模式，这是CBC的标准填充)
        kAESKey,                     // 密钥
        kCCKeySizeAES128,            // 密钥长度
        kAESIV,                      // 初始化向量
        [data bytes],                // 输入数据
        dataLength,                  // 输入数据长度
        buffer,                      // 输出缓冲区
        bufferSize,                  // 输出缓冲区大小
        &numBytesProcessed           // 实际处理的字节数
    );
    
    if (cryptStatus == kCCSuccess) {
        // 成功，返回处理后的数据
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesProcessed];
        NSLog(@"AESCBCUtil: %@ 操作成功，处理了 %zu 字节", 
              operation == kCCEncrypt ? @"加密" : @"解密", numBytesProcessed);
        return result;
    } else {
        // 失败，释放内存并返回nil
        free(buffer);
        NSLog(@"AESCBCUtil: %@ 操作失败，错误代码: %d", 
              operation == kCCEncrypt ? @"加密" : @"解密", cryptStatus);
        return nil;
    }
}
+ (NSString *)encryptHexStringWithFixedKey:(NSString *)hexString {
    if (!hexString || hexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *sourceData = [NSData dataWithHexString:hexString];
    if (!sourceData) {
        return nil;
    }
    
    // Zero填充到16字节边界
    NSData *paddedData = [self zeroPadData:sourceData];
    
    // 执行加密（使用固定密钥）
    NSData *encryptedData = [self performAESOperationWithFixedKey:kCCEncrypt onData:paddedData];
    if (!encryptedData) {
        return nil;
    }
    
    // 将加密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:encryptedData];
}

/**
 * 使用固定密钥解密十六进制字符串数据（Zero填充模式）
 * @param encryptedHexString 待解密的十六进制字符串
 * @return 解密后的十六进制字符串
 */
+ (NSString *)decryptHexStringWithFixedKey:(NSString *)encryptedHexString {
    if (!encryptedHexString || encryptedHexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *encryptedData = [NSData dataWithHexString:encryptedHexString];
    if (!encryptedData) {
        return nil;
    }
    
    // 如果数据长度不是16字节的整数倍，则进行Zero填充
    NSData *paddedData = encryptedData;
    if (encryptedData.length % kCCBlockSizeAES128 != 0) {
        paddedData = [self zeroPadData:encryptedData];
        NSLog(@"AESCBCUtil: 固定密钥解密 - 输入数据长度不足，已补0填充。原长度: %lu，填充后: %lu", 
              (unsigned long)encryptedData.length, (unsigned long)paddedData.length);
    }
    
    // 执行解密（使用固定密钥）
    NSData *decryptedData = [self performAESOperationWithFixedKey:kCCDecrypt onData:paddedData];
    if (!decryptedData) {
        return nil;
    }
    
    // 移除Zero填充
    NSData *unpaddedData = [self removeZeroPadding:decryptedData];
    
    // 将解密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:unpaddedData];
}

+ (NSData *)performAESOperationWithFixedKey:(CCOperation)operation onData:(NSData *)data {
    // 计算输出缓冲区大小
    size_t dataLength = [data length];
    size_t bufferSize = dataLength;
    void *buffer = malloc(bufferSize);
    
    if (!buffer) {
        NSLog(@"AESCBCUtil: 内存分配失败（固定密钥模式）");
        return nil;
    }
    
    size_t numBytesProcessed = 0;
    
    // 执行AES CBC加密/解密（使用固定密钥，无填充）
    CCCryptorStatus cryptStatus = CCCrypt(
        operation,                    // 操作类型 (加密/解密)
        kCCAlgorithmAES128,          // 算法类型 (AES-128)
        0,                           // 无填充选项（我们手动处理填充）
        kAESKey,                     // 直接使用固定密钥
        kCCKeySizeAES128,            // 密钥长度
        kAESIV,                      // 初始化向量
        [data bytes],                // 输入数据
        dataLength,                  // 输入数据长度
        buffer,                      // 输出缓冲区
        bufferSize,                  // 输出缓冲区大小
        &numBytesProcessed           // 实际处理的字节数
    );
    
    if (cryptStatus == kCCSuccess) {
        // 成功，返回处理后的数据
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesProcessed];
        
        // 输出固定密钥信息（用于调试）
        NSMutableString *fixedKeyHex = [NSMutableString stringWithCapacity:kCCKeySizeAES128 * 2];
        for (int i = 0; i < kCCKeySizeAES128; i++) {
            [fixedKeyHex appendFormat:@"%02X", kAESKey[i]];
        }
        
        NSLog(@"AESCBCUtil: %@ 操作成功（固定密钥模式），处理了 %zu 字节",
              operation == kCCEncrypt ? @"加密" : @"解密", numBytesProcessed);
        NSLog(@"  使用固定密钥: %@", fixedKeyHex);
        
        return result;
    } else {
        // 失败，释放内存并返回nil
        free(buffer);
        NSLog(@"AESCBCUtil: %@ 操作失败（固定密钥模式），错误代码: %d",
              operation == kCCEncrypt ? @"加密" : @"解密", cryptStatus);
        return nil;
    }
}
#pragma mark - 使用密钥池的加密解密方法

+ (NSString *)encryptHexString:(NSString *)hexString withKeyIndex:(NSInteger)keyIndex {
    if (!hexString || hexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *sourceData = [NSData dataWithHexString:hexString];
    if (!sourceData) {
        return nil;
    }
    
    // 执行加密
    NSData *encryptedData = [self encryptData:sourceData withKeyIndex:keyIndex];
    if (!encryptedData) {
        return nil;
    }
    
    // 将加密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:encryptedData];
}

+ (NSString *)decryptHexString:(NSString *)encryptedHexString withKeyIndex:(NSInteger)keyIndex {
    if (!encryptedHexString || encryptedHexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *encryptedData = [NSData dataWithHexString:encryptedHexString];
    if (!encryptedData) {
        return nil;
    }
    
    // 执行解密
    NSData *decryptedData = [self decryptData:encryptedData withKeyIndex:keyIndex];
    if (!decryptedData) {
        return nil;
    }
    
    // 将解密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:decryptedData];
}

+ (NSData *)encryptData:(NSData *)data withKeyIndex:(NSInteger)keyIndex {
    if (!data || data.length == 0) {
        return nil;
    }
    
    return [self performAESOperation:kCCEncrypt onData:data withKeyIndex:keyIndex];
}

+ (NSData *)decryptData:(NSData *)encryptedData withKeyIndex:(NSInteger)keyIndex {
    if (!encryptedData || encryptedData.length == 0) {
        return nil;
    }
    
    return [self performAESOperation:kCCDecrypt onData:encryptedData withKeyIndex:keyIndex];
}

#pragma mark - 私有密钥生成方法

/**
 * 根据密钥索引生成新的密钥
 * @param keyIndex 密钥池索引 (0-9)
 * @return 生成的新密钥，失败返回nil
 */
+ (NSData *)generateKeyWithIndex:(NSInteger)keyIndex {
    // 检查密钥索引范围
    if (keyIndex < 0 || keyIndex >= [[self keyPool] count]) {
        NSLog(@"AESCBCUtil: 密钥索引超出范围 (0-9): %ld", (long)keyIndex);
        return nil;
    }
    
    // 获取指定索引的密钥组
    NSArray *selectedKeyArray = [[self keyPool] objectAtIndex:keyIndex];
    if (!selectedKeyArray || [selectedKeyArray count] != kCCKeySizeAES128) {
        NSLog(@"AESCBCUtil: 密钥组格式错误，索引: %ld", (long)keyIndex);
        return nil;
    }
    
    // 转换密钥组为字节数组
    unsigned char poolKey[kCCKeySizeAES128];
    for (int i = 0; i < kCCKeySizeAES128; i++) {
        poolKey[i] = [selectedKeyArray[i] unsignedCharValue];
    }
    
    // 与本地密钥进行异或操作
    unsigned char xorKey[kCCKeySizeAES128];
    for (int i = 0; i < kCCKeySizeAES128; i++) {
        xorKey[i] = poolKey[i] ^ kAESKey[i];
    }
    
    // 输出密钥生成信息
    NSMutableString *poolKeyHex = [NSMutableString stringWithCapacity:kCCKeySizeAES128 * 2];
    NSMutableString *localKeyHex = [NSMutableString stringWithCapacity:kCCKeySizeAES128 * 2];
    NSMutableString *xorKeyHex = [NSMutableString stringWithCapacity:kCCKeySizeAES128 * 2];
    
    for (int i = 0; i < kCCKeySizeAES128; i++) {
        [poolKeyHex appendFormat:@"%02X", poolKey[i]];
        [localKeyHex appendFormat:@"%02X", kAESKey[i]];
        [xorKeyHex appendFormat:@"%02X", xorKey[i]];
    }
    
    NSLog(@"AESCBCUtil: 密钥生成 - 索引: %ld", (long)keyIndex);
    NSLog(@"  池密钥: %@", poolKeyHex);
    NSLog(@"  本地密钥: %@", localKeyHex);
    NSLog(@"  异或结果: %@", xorKeyHex);
    
    // 打印IV信息
    NSMutableString *ivHex = [NSMutableString stringWithCapacity:kCCBlockSizeAES128 * 2];
    for (int i = 0; i < kCCBlockSizeAES128; i++) {
        [ivHex appendFormat:@"%02X", kAESIV[i]];
    }
    NSLog(@"  使用的IV: %@", ivHex);
    
    return [NSData dataWithBytes:xorKey length:kCCKeySizeAES128];
}

/**
 * 使用指定密钥索引执行AES CBC模式的加密或解密操作
 * @param operation 操作类型 (kCCEncrypt 或 kCCDecrypt)
 * @param data 待处理的数据
 * @param keyIndex 密钥池索引 (0-9)
 * @return 处理后的数据，失败返回nil
 */
+ (NSData *)performAESOperation:(CCOperation)operation onData:(NSData *)data withKeyIndex:(NSInteger)keyIndex {
    // 生成新密钥
    NSData *keyData = [self generateKeyWithIndex:keyIndex];
    if (!keyData) {
        return nil;
    }
    
    // 计算输出缓冲区大小
    size_t dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    if (!buffer) {
        NSLog(@"AESCBCUtil: 内存分配失败");
        return nil;
    }
    
    size_t numBytesProcessed = 0;
    
    // 执行AES CBC加密/解密
    CCCryptorStatus cryptStatus = CCCrypt(
        operation,                    // 操作类型 (加密/解密)
        kCCAlgorithmAES128,          // 算法类型 (AES-128)
        kCCOptionPKCS7Padding,       // 选项 (PKCS7填充模式，这是CBC的标准填充)
        [keyData bytes],             // 生成的异或密钥
        kCCKeySizeAES128,            // 密钥长度
        kAESIV,                      // 初始化向量
        [data bytes],                // 输入数据
        dataLength,                  // 输入数据长度
        buffer,                      // 输出缓冲区
        bufferSize,                  // 输出缓冲区大小
        &numBytesProcessed           // 实际处理的字节数
    );
    
    if (cryptStatus == kCCSuccess) {
        // 成功，返回处理后的数据
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesProcessed];
        NSLog(@"AESCBCUtil: %@ 操作成功，密钥索引: %ld，处理了 %zu 字节", 
              operation == kCCEncrypt ? @"加密" : @"解密", (long)keyIndex, numBytesProcessed);
        return result;
    } else {
        // 失败，释放内存并返回nil
        free(buffer);
        NSLog(@"AESCBCUtil: %@ 操作失败，密钥索引: %ld，错误代码: %d", 
              operation == kCCEncrypt ? @"加密" : @"解密", (long)keyIndex, cryptStatus);
        return nil;
    }
}

#pragma mark - 无填充模式方法

+ (NSString *)encryptHexStringNoPadding:(NSString *)hexString withKeyIndex:(NSInteger)keyIndex {
    if (!hexString || hexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *sourceData = [NSData dataWithHexString:hexString];
    if (!sourceData) {
        return nil;
    }
    
    // 检查数据长度是否是16字节的整数倍
    if (sourceData.length % kCCBlockSizeAES128 != 0) {
        NSLog(@"AESCBCUtil: 无填充模式要求数据长度是16字节的整数倍，当前长度: %lu", (unsigned long)sourceData.length);
        return nil;
    }
    
    // 执行无填充加密
    NSData *encryptedData = [self performAESOperationNoPadding:kCCEncrypt onData:sourceData withKeyIndex:keyIndex];
    if (!encryptedData) {
        return nil;
    }
    
    // 将加密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:encryptedData];
}

/**
 * 使用指定密钥索引执行AES CBC模式的加密或解密操作（无填充）
 * @param operation 操作类型 (kCCEncrypt 或 kCCDecrypt)
 * @param data 待处理的数据
 * @param keyIndex 密钥池索引 (0-9)
 * @return 处理后的数据，失败返回nil
 */
+ (NSData *)performAESOperationNoPadding:(CCOperation)operation onData:(NSData *)data withKeyIndex:(NSInteger)keyIndex {
    // 生成新密钥
    NSData *keyData = [self generateKeyWithIndex:keyIndex];
    if (!keyData) {
        return nil;
    }
    
    // 计算输出缓冲区大小（无填充模式，输出长度等于输入长度）
    size_t dataLength = [data length];
    size_t bufferSize = dataLength;
    void *buffer = malloc(bufferSize);
    
    if (!buffer) {
        NSLog(@"AESCBCUtil: 内存分配失败");
        return nil;
    }
    
    size_t numBytesProcessed = 0;
    
    // 执行AES CBC加密/解密（无填充）
    CCCryptorStatus cryptStatus = CCCrypt(
        operation,                    // 操作类型 (加密/解密)
        kCCAlgorithmAES128,          // 算法类型 (AES-128)
        0,                           // CBC模式（默认）+ 无填充
        [keyData bytes],             // 生成的异或密钥
        kCCKeySizeAES128,            // 密钥长度
        kAESIV,                      // 初始化向量
        [data bytes],                // 输入数据
        dataLength,                  // 输入数据长度
        buffer,                      // 输出缓冲区
        bufferSize,                  // 输出缓冲区大小
        &numBytesProcessed           // 实际处理的字节数
    );
    
    if (cryptStatus == kCCSuccess) {
        // 成功，返回处理后的数据
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesProcessed];
        NSLog(@"AESCBCUtil: %@ 操作成功（无填充），密钥索引: %ld，处理了 %zu 字节", 
              operation == kCCEncrypt ? @"加密" : @"解密", (long)keyIndex, numBytesProcessed);
        return result;
    } else {
        // 失败，释放内存并返回nil
        free(buffer);
        NSLog(@"AESCBCUtil: %@ 操作失败（无填充），密钥索引: %ld，错误代码: %d", 
              operation == kCCEncrypt ? @"加密" : @"解密", (long)keyIndex, cryptStatus);
        return nil;
    }
}

/**
 * 使用指定密钥ID加密十六进制字符串数据（Zero填充模式）
 * @param hexString 待加密的十六进制字符串
 * @param keyIndex 密钥池索引 (0-9)
 * @return 加密后的十六进制字符串
 */
+ (NSString *)encryptHexStringZeroPadding:(NSString *)hexString withKeyIndex:(NSInteger)keyIndex {
    if (!hexString || hexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *sourceData = [NSData dataWithHexString:hexString];
    if (!sourceData) {
        return nil;
    }
    
    // Zero填充到16字节边界
    NSData *paddedData = [self zeroPadData:sourceData];
    
    // 执行加密
    NSData *encryptedData = [self performAESOperationZeroPadding:kCCEncrypt onData:paddedData withKeyIndex:keyIndex];
    if (!encryptedData) {
        return nil;
    }
    
    // 将加密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:encryptedData];
}

/**
 * 使用指定密钥ID解密十六进制字符串数据（Zero填充模式）
 * @param encryptedHexString 待解密的十六进制字符串
 * @param keyIndex 密钥池索引 (0-9)
 * @return 解密后的十六进制字符串
 */
+ (NSString *)decryptHexStringZeroPadding:(NSString *)encryptedHexString withKeyIndex:(NSInteger)keyIndex {
    if (!encryptedHexString || encryptedHexString.length == 0) {
        return nil;
    }
    
    // 将十六进制字符串转换为NSData
    NSData *encryptedData = [NSData dataWithHexString:encryptedHexString];
    if (!encryptedData) {
        return nil;
    }
    // Zero填充到16字节边界
    NSData *paddedData = [self zeroPadData:encryptedData];
    
    // 执行解密
    NSData *decryptedData = [self performAESOperationZeroPadding:kCCDecrypt onData:paddedData withKeyIndex:keyIndex];
    if (!decryptedData) {
        return nil;
    }
    
    // 移除Zero填充
    NSData *unpaddedData = [self removeZeroPadding:decryptedData];
    
    // 将解密结果转换为十六进制字符串
    return [Base64Converter hexStringFromData:unpaddedData];
}

/**
 * Zero填充数据到16字节边界
 */
+ (NSData *)zeroPadData:(NSData *)data {
    NSUInteger dataLength = data.length;
    NSUInteger paddedLength = ((dataLength / kCCBlockSizeAES128) + 1) * kCCBlockSizeAES128;
    
    NSMutableData *paddedData = [NSMutableData dataWithData:data];
    
    // 添加零填充
    NSUInteger paddingLength = paddedLength - dataLength;
    char zeros[paddingLength];
    memset(zeros, 0, paddingLength);
    [paddedData appendBytes:zeros length:paddingLength];
    
    return paddedData;
}

/**
 * 移除Zero填充
 */
+ (NSData *)removeZeroPadding:(NSData *)data {
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    NSUInteger length = data.length;
    
    // 从末尾开始移除零字节
    while (length > 0 && bytes[length - 1] == 0) {
        length--;
    }
    
    return [NSData dataWithBytes:bytes length:length];
}

/**
 * 使用Zero填充模式执行AES CBC操作
 */
+ (NSData *)performAESOperationZeroPadding:(CCOperation)operation onData:(NSData *)data withKeyIndex:(NSInteger)keyIndex {
    // 生成新密钥
    NSData *keyData = [self generateKeyWithIndex:keyIndex];
    if (!keyData) {
        return nil;
    }
    
    // 计算输出缓冲区大小
    size_t dataLength = [data length];
    size_t bufferSize = dataLength;
    void *buffer = malloc(bufferSize);
    
    if (!buffer) {
        NSLog(@"AESCBCUtil: 内存分配失败");
        return nil;
    }
    
    size_t numBytesProcessed = 0;
    
    // 执行AES CBC加密/解密（无填充，因为我们手动处理了填充）
    CCCryptorStatus cryptStatus = CCCrypt(
        operation,                    // 操作类型 (加密/解密)
        kCCAlgorithmAES128,          // 算法类型 (AES-128)
        0,                           // 无填充选项（我们手动处理填充）
        [keyData bytes],             // 生成的异或密钥
        kCCKeySizeAES128,            // 密钥长度
        kAESIV,                      // 初始化向量
        [data bytes],                // 输入数据
        dataLength,                  // 输入数据长度
        buffer,                      // 输出缓冲区
        bufferSize,                  // 输出缓冲区大小
        &numBytesProcessed           // 实际处理的字节数
    );
    
    if (cryptStatus == kCCSuccess) {
        // 成功，返回处理后的数据
        NSData *result = [NSData dataWithBytesNoCopy:buffer length:numBytesProcessed];
        NSLog(@"AESCBCUtil: %@ 操作成功（Zero填充），密钥索引: %ld，处理了 %zu 字节", 
              operation == kCCEncrypt ? @"加密" : @"解密", (long)keyIndex, numBytesProcessed);
        return result;
    } else {
        // 失败，释放内存并返回nil
        free(buffer);
        NSLog(@"AESCBCUtil: %@ 操作失败（Zero填充），密钥索引: %ld，错误代码: %d", 
              operation == kCCEncrypt ? @"加密" : @"解密", (long)keyIndex, cryptStatus);
        return nil;
    }
}

@end 
