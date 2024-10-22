//
//  ICUDataManager.m
//  TestFeel
//
//  Created by app on 2024/6/27.
//

#import "ICUDataManager.h"

@implementation ICUDataManager
+ (instancetype)sharedManager {
    static ICUDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)initializeData {
    NSArray *savedStringsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedStringsArray"];
    
    // 如果不存在保存的字符串数组，初始化一个空数组
    if (savedStringsArray == nil || ![savedStringsArray isKindOfClass:[NSArray class]]) {
        NSArray *emptyArray = @[];
        [[NSUserDefaults standardUserDefaults] setObject:emptyArray forKey:@"savedStringsArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)saveString:(NSString *)string {
    // 检索已保存的字符串数组
    NSMutableArray *savedStringsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedStringsArray"] mutableCopy];
    
    // 检查字符串是否已存在
    if (![savedStringsArray containsObject:string]) {
        // 如果字符串不存在，保存新字符串
        [savedStringsArray addObject:string];
        [[NSUserDefaults standardUserDefaults] setObject:savedStringsArray forKey:@"savedStringsArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"String saved: %@", string);
    } else {
        NSLog(@"String already exists: %@", string);
    }
}

- (BOOL)isStringSaved:(NSString *)string {
    NSArray *savedStringsArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedStringsArray"];
    return [savedStringsArray containsObject:string];
}
@end
