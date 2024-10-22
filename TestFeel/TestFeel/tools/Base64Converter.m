//
//  Base64Converter.m
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import "Base64Converter.h"

@implementation Base64Converter
+ (NSString *)hexStringFromBase64String:(NSString *)base64String {
    // 解码 Base64 字符串为 NSData
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    
    // 创建一个可变字符串来存储十六进制字符串
    NSMutableString *hexString = [NSMutableString stringWithCapacity:[data length] * 2];
    
    // 遍历 NSData 对象的字节，将每个字节转换为十六进制字符串并追加到 hexString 中
    const unsigned char *dataBytes = [data bytes];
    for (NSInteger i = 0; i < [data length]; i++) {
        [hexString appendFormat:@"%02x", dataBytes[i]];
    }
    
    return hexString;
}

+ (NSData *)dataWithHexString:(NSString *)hexString {
    NSMutableData *data = [NSMutableData data];
    int idx;
    for (idx = 0; idx + 2 <= hexString.length; idx += 2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString *hexStr = [hexString substringWithRange:range];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        if ([scanner scanHexInt:&intValue]) {
            uint8_t byte = (uint8_t)intValue;
            [data appendBytes:&byte length:1];
        }
    }
    return data;
}

+ (NSString *)base64StringFromHexString:(NSString *)hexString {
    // 创建一个可变数据对象来存储字节
    NSMutableData *data = [NSMutableData dataWithCapacity:[hexString length] / 2];
    
    // 遍历十六进制字符串，每两个字符转换为一个字节
    for (NSInteger i = 0; i < [hexString length]; i += 2) {
        NSString *hexChar = [hexString substringWithRange:NSMakeRange(i, 2)];
        unsigned int byte;
        [[NSScanner scannerWithString:hexChar] scanHexInt:&byte];
        [data appendBytes:&byte length:1];
    }
    
    // 将 NSData 对象编码为 Base64 字符串
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    return base64String;
}
+ (NSString *)hexStringFromData:(NSData *)data {
    const unsigned char *dataBytes = (const unsigned char *)[data bytes];
     NSMutableString *hexString = [NSMutableString stringWithCapacity:[data length] * 2];
     for (NSInteger i = 0; i < [data length]; i++) {
         [hexString appendFormat:@"%02X", dataBytes[i]];  // Use %02X to get uppercase hex digits
     }
     return hexString;
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
