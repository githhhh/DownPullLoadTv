//
//  AppDelegate.h
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-5.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialData.h"
#import "UMSocialBar.h"

#import "WXApi.h"
#import "UMSocialControllerService.h"

@class LoginViewController  ;




@interface AppDelegate : UIResponder <UIApplicationDelegate >

@property (strong, nonatomic) UIWindow *window;


@property (strong, nonatomic) LoginViewController *rootv;


@end
