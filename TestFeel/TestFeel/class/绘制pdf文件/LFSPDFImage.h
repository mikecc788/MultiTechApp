//
//  LFSPDFImage.h
//  TestFeel
//
//  Created by app on 2023/4/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFSPDFImage : NSObject

+ (void)createPDFImageWithTitle:(NSString *)title pefArray:(NSArray*)pefArray saveToPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
