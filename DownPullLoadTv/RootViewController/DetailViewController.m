//
//  DetailViewController.m
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-8.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "DetailViewController.h"
#import "API.h"
#import "UMSocialMacroDefine.h"
@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize imageP;
@synthesize url ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create a reload button

        
        

    }
    return self;
}

-(id)initWithDescriptor:(NSString *)descriptor withImage:(UIImage *)image
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonSystemItemAction target:self action:@selector(reload)];
        self.navigationItem.rightBarButtonItem = reloadButton;
        [reloadButton release];

        
     
        if (!image) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,5, 320, 350)];
            imageView.image = [UIImage imageNamed:@"pop.png"];
            [self.view addSubview:imageView];
            [imageView release];
            
            return self;
        }
        
        
        
        
        self.imageP=image;
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:descriptor withTitle:@"socialBarTest"];
        UMSocialBar * _socialBar = [[UMSocialBar alloc] initWithUMSocialData:socialData withViewController:self];
        //下面这个设置为NO，分享列表出现短信、邮箱不需要登录
        //        _socialBar.socialControllerService.shareNeedLogin = NO;
        //设置个人中心页面也不需要登录，默认需要。如果你单独使用UMSocialControllerService则默认不需要
        //        _socialBar.socialControllerService.userCenterNeedLogin =NO;
        _socialBar.socialBarDelegate = self;
        _socialBar.socialBarView.themeColor = UMSBarColorBlack;
        
        _socialBar.socialData.shareText = @"我分享的:哇！！！美女";
        _socialBar.socialData.shareImage = image;
        _socialBar.socialData.commentImage = image;
        _socialBar.socialData.commentText = @"我分享的:哇！！！美女";
        
        [_socialBar  updateButtonNumberWithIdentifier:descriptor];
        _socialBar.center = CGPointMake(160, 391);
        
        [self.view addSubview:_socialBar];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 372)];
        imageView.image = image;
        [self.view addSubview:imageView];
        [imageView     release];

        
    }
    return self;
    
    

}

-(void)reload
{
    NSLog(@"下载....");
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName=[ self.url pathExtension];
    
    NSLog(@"Extension::::%@",fileName);
    
     NSLog(@"fileName::::%@",[self.url lastPathComponent    ]);
   
 
    
    if ([[fileName lowercaseString] isEqualToString:@"jpg"]||[[fileName lowercaseString] isEqualToString:@"jpeg"]) {
        [ UIImageJPEGRepresentation(imageP, 1.0) writeToFile:[documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",[self.url lastPathComponent]]] options:NSAtomicWrite error:nil]
        ;
        
        NSLog(@"下载.成功..");
        
        return;
    }
    if ([[fileName lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(imageP) writeToFile:[documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",[self.url lastPathComponent]]]  options:NSAtomicWrite error:nil];
        
        NSLog(@"下载.成功..");
        
        return;
    }
    //下载文件....
    
    NSLog(@"url:%@",self.url);
   
    [[API sharedInstance] commandWithParams:nil Method:@"GET" PATH:self.url onCompletion:^(id json) {
         AFHTTPRequestOperation *operation=json; 
     
              [operation.responseData writeToFile:[documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",[self.url lastPathComponent]]] options:NSAtomicWrite error:nil];
             NSLog(@"下载成功....%@",[self.url lastPathComponent]);
       
        
        
    }];

}




#pragma mark - UMSocialBarDelegate
-(void)didFinishUpdateBarNumber:(UMSButtonTypeMask)actionTypeMask
{
    NSLog(@"finish update bar button is %d",actionTypeMask);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  
    [imageP release];
    [url release];
    [super dealloc];
}
@end
