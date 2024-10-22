//
//  CreatePDFImage.h
//  TestFeel
//
//  Created by app on 2023/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatePDFImage : NSObject

@property (nonatomic, strong) NSString *Title;
 
@property (nonatomic, strong) NSString *Message_1;
 
@property (nonatomic, strong) NSString *Message_2;
 
@property (nonatomic, strong) NSString *Message_3;
 
@property (nonatomic, strong) NSString *Message_4;
 
 
@property (nonatomic, strong) NSString *fileName;
 
@property (nonatomic) CGFloat FileWidth;
 
@property (nonatomic) CGFloat CellHeight;
 
@property (nonatomic) CGFloat CellPointCount;
 
@property (nonatomic) CGFloat CellGap;
 
@property (nonatomic) CGFloat Top;
 
@property (nonatomic) CGFloat Left;
 
@property (nonatomic) CGFloat Right;
 
@property (nonatomic) CGFloat GridWidth;
 
@property (nonatomic) CGFloat GridLineWidth;
 
@property (nonatomic) CGFloat LineWidth;

- (void)CreatePdfFile:(NSArray *)array;

- (instancetype)initwithTitle:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
