//
//  DetailViewController.h
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-8.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocialBar.h"
@interface DetailViewController : UIViewController<UMSocialBarDelegate>

@property(nonatomic,retain)UIImage *imageP;

@property(nonatomic,retain)NSString *url;


-(id)initWithDescriptor:(NSString *)descriptor withImage:(UIImage *)image;
@end
