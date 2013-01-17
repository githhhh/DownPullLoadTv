//
//  LoginViewController.h
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-6.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "PhotosWall.h"

@class RootViewController;

@interface LoginViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *user;

//@property(retain,nonatomic)RootViewController *root;

@property(retain,nonatomic)PhotosWall *pw;



@property (retain, nonatomic) IBOutlet UITextField *password;

@end
