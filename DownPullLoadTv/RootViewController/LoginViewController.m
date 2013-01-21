//
//  LoginViewController.m
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-6.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//


#import "LoginViewController.h"
#import "RootViewController.h"
#import "API.h"
#import "RefreshView.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize pw;


  
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
    
}

- (IBAction)backgroundTap:(id)sender {
    
    [_user resignFirstResponder];
    [_password resignFirstResponder];
    
    
}





- (IBAction)login:(id)sender {
    
    if (_user.text.length==0||_password.text.length==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"输入用户名和密码" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _user.text, @"username",
                                 _password.text , @"password", nil] ;
    

    [[API sharedInstance] commandWithParams:[params retain]     Method:@"POST"  PATH: kAPILoginPath  onCompletion:^(id   json){
        AFHTTPRequestOperation *operation=json;
        
        
        //将json字符串转换为  字典
        NSDictionary * data= [operation.responseString JSONValue  ];
        if (![[data objectForKey:@"isSuc"] integerValue]==0 ) {
            //成功
            NSLog(@"跳转图片列表....开始异步加载图片......");
            
 
           
           
            pw=[[PhotosWall alloc] initWithNibName:@"PhotosWall" bundle:nil] ;
                       
            
           
            
            
            
            UINavigationController *navigation=[[UINavigationController alloc] initWithRootViewController:pw];

            navigation.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

            [self.view addSubview:navigation.view];
            
    

            
        }else
        {
        
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Error" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }

        [params release];
        
    }];
 

   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [pw release];
   

    [_user release];
    [_password release];
    [super dealloc];
}
@end
