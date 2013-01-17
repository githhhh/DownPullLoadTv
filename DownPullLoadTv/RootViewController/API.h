//
//  API.h
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-6.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "AFHTTPClient.h"
#import "AFNetworking.h"
#import "JSON.h"
#define kAPIHost @"http://10.2.17.121:8091"

#define kAPILoginPath @"/IOSlogin.aspx"//  默认网址的根目录
#define kAPIUploadPath @"/UploadImg.aspx"
#define kAPIListPath @"/DownLoadList.aspx"


typedef void (^JSONResponseBlock)(id json);
typedef void (^FileContentData)(id<AFMultipartFormData>) ;
@interface API : NSObject
@property(nonatomic,retain)    AFHTTPClient *httpClient;
+(API *)sharedInstance;

//请求  方法...
-(void)commandWithParams:(NSMutableDictionary *)params
                  Method:(NSString *)name
                    PATH:(NSString *)path
   
            onCompletion:(JSONResponseBlock )completionBlock;


//上传  文件...
-(void)commandWithUploadFiles:(NSString *)FileType  FileName:(NSString *)fileN   FileData:(NSData *)data  PATH:(NSString *)path onCompletion:(JSONResponseBlock)completionBlock;






@end
