//
//  NetworkManager.h
//  TestFeel
//
//  Created by app on 2022/9/27.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodPost,
    RequestMethodGet
};

NS_ASSUME_NONNULL_BEGIN

/**
 *  网络请求,请求进度 block
 *
 *  @param downloadProgress 进度条
 */
typedef void(^RequestProgress)(NSProgress * downloadProgress);

typedef void (^NetworkManagerSuccess)(id responseObject);
typedef void (^NetworkManagerFailure)(NSString *failureReason, NSInteger statusCode);
typedef void(^ErrorBlock)(id error);
typedef void(^CompletionBlock)(void);
@interface NetworkManager : NSObject
+ (id)sharedManager;
-(void)test;
- (void)tokenCheckWithSuccess:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure;

- (void)authenticateWithEmail:(NSString*)email password:(NSString*)password success:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure;

#pragma mark ----------- 网络请求（get）-----------
-(void)requestWithURL:(NSString *)urlStr parameters:(NSDictionary *)params success:(NetworkManagerSuccess)success failure:(NetworkManagerFailure)failure;

@end

NS_ASSUME_NONNULL_END
