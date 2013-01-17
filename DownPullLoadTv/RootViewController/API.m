//
//  API.m
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-6.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//
/*   post api
 
 NSURL *baseURL = [NSURL URLWithString:@"http://10.2.17.121:8091"];
 
 //build normal NSMutableURLRequest objects
 //make sure to setHTTPMethod to "POST".
 //from https://github.com/AFNetworking/AFNetworking
 AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
 [httpClient defaultValueForHeader:@"Accept"];
 [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
 NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
 _user.text, @"username",
 _password.text , @"password", nil];
 
 NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/IOSlogin.aspx" parameters:params];
 //Add your request object to an AFHTTPRequestOperation
 AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
 
 //"Why don't I get JSON / XML / Property List in my HTTP client callbacks?"
 //see: https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-FAQ
 //mattt's suggestion http://stackoverflow.com/a/9931815/1004227 --still didn't prevent me from receiving plist data
 //[httpClient registerHTTPOperationClass:[AFPropertyListParameterEncoding class]];
 
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSDictionary  *response =(NSDictionary *) [operation responseString];
 NSLog(@"response: [%@]",response);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"error: %@", [operation error]);
 }];
 
 //call start on your request operation
 [operation start];
 [httpClient release];
 */

#import "API.h"




//http://10.2.17.121:8091/IOSlogin.aspx


@implementation API

@synthesize httpClient;
#pragma mark -Singleton methods

+(API *)sharedInstance
{
    static API *sharedInstance=nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
    
        sharedInstance=[[super alloc] init] ;
    });
    
    

    
    return  sharedInstance;

}

-(void)commandWithParams:(NSMutableDictionary *)params Method:(NSString *)name PATH:(NSString *)path      onCompletion:(JSONResponseBlock)completionBlock
{

    if (!httpClient) {
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [httpClient defaultValueForHeader:@"Accept"];
    }

    
    
    
    NSURLRequest *request=[httpClient requestWithMethod:name path: path parameters:params  ];

    
    AFHTTPRequestOperation*operation=
    [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease] ;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation,id responseString){
        
       completionBlock(operation );
        
    
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        NSLog(@"error:%@",[error localizedDescription]);
        
        }];
    
    [ operation start];

   // [request release];//不能释放.....
   
}


-(void)commandWithUploadFiles:(NSString *)FileType FileName:(NSString *)fileN FileData:(NSData *)data PATH:(NSString *)path onCompletion:(JSONResponseBlock)completionBlock
{
    if (!httpClient) {
        httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
        [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [httpClient defaultValueForHeader:@"Accept"];
    }
    NSMutableURLRequest *request=[httpClient multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
 
        NSString *name=[fileN  pathExtension];
        
        NSLog(@"name.%@",name);
        
        [formData appendPartWithFileData:data name:@"uuuu" fileName:[NSString stringWithFormat:@"uuuu.%@",name] mimeType:FileType];
        
        
    }];
   
    AFHTTPRequestOperation*operation=[[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionBlock(operation.responseString);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"上传失败"
                                                      message:[error localizedDescription]
                                                     delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alert show    ];
        [alert release];
        
        
    }];

    [operation start];

}


























-(void)dealloc
{
  [httpClient release];

    [super dealloc];
}

@end
