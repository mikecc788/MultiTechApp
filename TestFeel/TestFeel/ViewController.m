//
//  ViewController.m
//  TestFeel
//
//  Created by app on 2022/3/7.
//

#import "ViewController.h"
#import "NSObject+Extension.h"
#import "HYRadix.h"
#import "AES128Util.h"
#import "AESCBCUtil.h"
#import "NSData+Hex.h"
#import "HistoryDeviceModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 测试密钥池功能
    [self testAESCBCWithKeyPool];
    
//    [self testData];
}

- (void)testData {
    NSData *data = [NSData dataWithBytes:(unsigned char[]){0x9a, 0x05, 0x8e, 0x95, 0xee, 0x1d, 0x3b, 0xf2} length:8];
    NSString *result = [self reversedHexStringFromData:data];
    NSLog(@"输出字符串: %@", result);
}

// 将NSData的前两个字节交换，其余6字节逆序输出并转为十六进制字符串
- (NSString *)reversedHexStringFromData:(NSData *)data {
    const unsigned char *bytes = data.bytes;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:data.length * 2];

    // 前两个字节交换
    if (data.length >= 2) {
        [hexString appendFormat:@"%02x%02x", bytes[1], bytes[0]];
    } else if (data.length == 1) {
        [hexString appendFormat:@"%02x", bytes[0]];
    }

    // 后面六个字节逆序输出
    for (NSInteger i = data.length - 1; i >= 2; i--) {
        [hexString appendFormat:@"%02x", bytes[i]];
    }

    return hexString;
}

/**
 * 测试AES CBC密钥池功能
 */
- (void)testAESCBCWithKeyPool {
    NSLog(@"=== 开始测试AES CBC密钥池功能 ===");
    
    // 原始数据（十六进制字符串）
    NSString *originalData = @"88dd1f1503000000000000000000000000000000";
    // 96AEC1B55E3C9723A0D615C777B08A5A3B36D2BF4FBA65E9CA25466B19F94E33
    NSString *decryData = @"DAE4984CC351AA08F2ABB973E8168EF6ABF92D6E63";
    NSString *endStr = [NSObject calculateCRCFromHexString:originalData];
    NSLog(@"原始数据: %@  end=%@ =%ld length=%ld", originalData,endStr,originalData.length,decryData.length);
    NSString *result11 = [AESCBCUtil encryptHexStringWithFixedKey:[NSString stringWithFormat:@"%@%@",originalData,endStr]];
    NSString *result22 = [AESCBCUtil decryptHexStringWithFixedKey:decryData];
    NSLog(@"result11=%@ result22=%@",result11,result22);
    
    // 演示不同密钥索引产生不同的加密结果
    NSLog(@"\n--- 演示不同密钥索引的加密结果 ---");
    NSString *result8 = [AESCBCUtil encryptHexStringZeroPadding:[NSString stringWithFormat:@"%@%@",originalData,endStr] withKeyIndex:2];
    NSString *result88 = [AESCBCUtil decryptHexStringZeroPadding:@"DAE4984CC351AA08F2ABB973E8168EF6ABF92D6E63" withKeyIndex:9];
    NSLog(@"密钥索引8加密结果: %@ 解密结果:%@", result8,result88);
    
    NSLog(@"=== AES CBC密钥池测试完成 ===\n");
}

@end
