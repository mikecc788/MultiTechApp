//
//  LFSPDFImage.m
//  TestFeel
//
//  Created by app on 2023/4/4.
//

#import "LFSPDFImage.h"
#import <CoreText/CoreText.h>
#import <PDFKit/PDFKit.h>
@implementation LFSPDFImage
+ (void)createPDFImageWithTitle:(NSString *)title pefArray:(NSArray*)pefArray saveToPath:(NSString *)path {
    NSArray *sortedArray = [pefArray sortedArrayUsingSelector:@selector(compare:)]; //从小到大排序
    int avgValue = [[sortedArray valueForKeyPath:@"@avg.intValue"] intValue];
    CGFloat leftPadding = 20;
    CGFloat pdfWidth = 612;
    CGFloat titleY = 50;
    CGFloat verticalSpacing = 5;
    CGFloat titleH = 30;
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfWidth, 792), nil);
    
    UIColor *yellowColor = [UIColor colorWithHexString:@"F0990B"];
    CGRect yellowRect = CGRectMake(leftPadding, titleY -10, pdfWidth - leftPadding *2, titleH*3 + verticalSpacing *4);
    [yellowColor setFill];
    UIRectFill(yellowRect);
    
    CGRect titleRect = CGRectMake(0, titleY, pdfWidth, titleH);
    [self drawTextWith:title color:[UIColor whiteColor] fontSize:24 rect:titleRect];
    
    NSString *time = @"2023 -4-5";
    CGRect timeRect = CGRectMake(0, titleY + titleH +verticalSpacing, pdfWidth, titleH);
    [self drawTextWith:time color:[UIColor whiteColor] fontSize:24 rect:timeRect];
    
    CGRect pefRect = CGRectMake(0, titleY + titleH*2 + verticalSpacing, pdfWidth, titleH);
    [self drawTextWith:@"PEF" color:[UIColor whiteColor] fontSize:30 rect:pefRect];
    
    CGFloat tableY = titleY + titleH*3 + verticalSpacing*4 + 20;
    
    // 绘制表格边框
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"F0990B"].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGRect tableRect = CGRectMake(leftPadding,tableY , pdfWidth - leftPadding *2, 40);
    CGContextStrokeRect(context, tableRect);
    CGFloat cellWidth = CGRectGetWidth(tableRect) / 3.0;
    CGFloat cellHeight = CGRectGetHeight(tableRect);
    // 绘制垂直线条
    for (int i = 1; i < 3; i++) {
        CGFloat x = CGRectGetMinX(tableRect) + i * cellWidth;
        CGContextMoveToPoint(context, x, CGRectGetMinY(tableRect));
        CGContextAddLineToPoint(context, x, CGRectGetMaxY(tableRect));
        CGContextStrokePath(context);
    }
    // 添加文本
   
    NSArray *textArray = @[[NSString stringWithFormat:@"%@  %@",@"最大:",sortedArray.lastObject], [NSString stringWithFormat:@"%@  %@",@"最小:",sortedArray.firstObject], [NSString stringWithFormat:@"%@  %d",@"平均数:",avgValue]];
    for (int i = 0; i < 3; i++) {
        CGRect textRect = CGRectMake(CGRectGetMinX(tableRect) + i * cellWidth, CGRectGetMinY(tableRect) + 8, cellWidth, cellHeight);
       NSString *text = textArray[i];
       [text drawInRect:textRect withAttributes:[self getTextAttribute:[UIColor blackColor] fontSize:14]];
    }
    
    // 绘制横线
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"F0990B"].CGColor);

    CGContextMoveToPoint(context, CGRectGetMinX(tableRect), CGRectGetMaxY(tableRect) + 20.0);
    CGContextAddLineToPoint(context, CGRectGetMaxX(tableRect), CGRectGetMaxY(tableRect) + 20.0);
    CGContextStrokePath(context);
    // 计算每个文字的位置
    CGFloat textWidth = CGRectGetWidth(tableRect) / 6.0;
    CGFloat textHeight = 20.0;
    CGFloat textY = CGRectGetMaxY(tableRect) + 24.0;
    CGFloat textXStart = CGRectGetMinX(tableRect);
    // 绘制文字
    NSArray *texts = @[@"日期", @"评估 - L/m", @"目标 - L/m", @"%", @"FEV1 - L",@"症状/备忘"];

    [texts enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
        CGRect textRect = CGRectMake(textXStart + idx * textWidth, textY, textWidth, textHeight);
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:[self getTextAttribute:[UIColor blackColor] fontSize:14]];
        [attributedText drawInRect:textRect];
    }];
    // 计算横线位置
    CGFloat lineY = textY + textHeight + 10.0;
    // 绘制横线
    CGContextMoveToPoint(context, textXStart, lineY);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"F0990B"].CGColor);
    CGContextAddLineToPoint(context, textXStart + CGRectGetWidth(tableRect), lineY);
    CGContextStrokePath(context);
    
    CGFloat footerLineY = textY + textHeight + 10.0 + pefArray.count * 40;
    // 绘制横线
    CGContextMoveToPoint(context, textXStart, footerLineY);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"F0990B"].CGColor);
    CGContextAddLineToPoint(context, textXStart + CGRectGetWidth(tableRect), footerLineY);
    CGContextStrokePath(context);
    
    UIGraphicsEndPDFContext();
    [pdfData writeToFile:path atomically:YES];
    
}
+(void)drawTextWith:(NSString *)string color:(UIColor *)color fontSize:(NSInteger)fontSize rect:(CGRect)rect{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: color};
    [string drawInRect:rect withAttributes:textAttributes];
}
+(NSDictionary*)getTextAttribute:(UIColor *)color fontSize:(NSInteger)fontSize{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: color};
    return textAttributes;
}
@end
