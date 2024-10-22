//
//  NSData+Hex.m
//  TestFeel
//
//  Created by app on 2024/6/19.
//

#import "NSData+Hex.h"

@implementation NSData (Hex)


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

@end
