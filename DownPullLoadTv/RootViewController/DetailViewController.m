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

static  NSString* msg;
static UILabel *label;
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
        
        UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonSystemItemAction target:self action:@selector(openMemu)];
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

        
        //加提示
       label=[[UILabel alloc] initWithFrame:CGRectMake(0,342,320 , 30)];
        msg=@"";
        label.text=msg;
        label.textAlignment= UITextAlignmentCenter;
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor whiteColor ];
        [self.view addSubview:label];
        [self.view sendSubviewToBack:label];

        
             
    }
    return self;
    
    

}
-(void)openMemu
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:@"保存到沙盒(Documents)", nil];
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) {
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0://相册
           
            [self saveAlbum];
            break;
        case 1://Documents
            
            [self saveDocuments];
            break;
  
        default:
            break;
    }
}

   

-(void)addMessge
{
   
    
    [self.view sendSubviewToBack:label];
    

}




-(void)saveAlbum
{
    
    NSString *fileName=[ self.url pathExtension];
    
    
    
    if ([[fileName lowercaseString] isEqualToString:@"jpg"]||[[fileName lowercaseString] isEqualToString:@"jpeg"]||[[fileName lowercaseString] isEqualToString:@"png"]) {
         UIImageWriteToSavedPhotosAlbum(imageP, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else
    {
      
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error" message:[ NSString stringWithFormat:@"错误的文件类型:*.%@",fileName] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil , nil];
        [alert show    ];
        [alert release];

    
    
    }
   


}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{

    if (error!=NULL) {
        NSLog(@"保存错误....");
         msg=@"保存错误....";
        
    }else
    {
        NSLog(@"保存到相册成功..");
        msg=@"保存到相册成功..";
            
        
        
    }
    [label setText:msg];
    [self.view bringSubviewToFront:label];
[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMessge)  userInfo:Nil repeats:YES];



}

-(void)saveDocuments
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
         msg=@"下载.成功...";
        [label setText:msg];
        [self.view bringSubviewToFront:label];
        
         [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMessge)  userInfo:Nil repeats:YES];
        return;
    }
    if ([[fileName lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(imageP) writeToFile:[documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",[self.url lastPathComponent]]]  options:NSAtomicWrite error:nil];
        
        NSLog(@"下载.成功..");
         msg=@"下载.成功...";
        [label setText:msg];
            [self.view bringSubviewToFront:label];
         [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMessge)  userInfo:Nil repeats:YES];
        return;
    }
    //下载文件....
    
    NSLog(@"url:%@",self.url);
   
    [[API sharedInstance] commandWithParams:nil Method:@"GET" PATH:self.url onCompletion:^(id json) {
         AFHTTPRequestOperation *operation=json; 
     
              [operation.responseData writeToFile:[documentsDirectory stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"%@",[self.url lastPathComponent]]] options:NSAtomicWrite error:nil];
             NSLog(@"下载成功....%@",[self.url lastPathComponent]);
       
          msg=@"下载.成功...";
        [label setText:msg];
            [self.view bringSubviewToFront:label];
         [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(addMessge)  userInfo:Nil repeats:YES];
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


-(void)viewDidUnload
{
  [label release];

    [super viewDidUnload];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [label release];
    [imageP release];
    [url release];
    [super dealloc];
}
@end
