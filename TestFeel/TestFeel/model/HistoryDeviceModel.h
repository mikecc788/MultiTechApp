//
//  HistoryDeviceModel.h
//  FeelLife
//
//  Created by app on 2024/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface HistoryDeviceContent : NSObject
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *image;
@end


@interface HistoryDeviceModel : NSObject
@property (nonatomic, strong) NSArray<HistoryDeviceContent*> *contents;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
