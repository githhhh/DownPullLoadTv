//
//  PhotosWall.h
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMGridView.h"
#import "API.h"
#import "MMGridViewDefaultCell.h"
#import "EGORefreshTableHeaderView.h"
#import "DetailViewController.h"
@interface PhotosWall : UIViewController<MMGridViewDataSource,MMGridViewDelegate>

{

    //,UIImagePickerControllerDelegate,UINavigationControllerDelegate
    
    IBOutlet MMGridView *gridView;

  

}








@property(nonatomic,retain)NSMutableArray *imgeSoure;
@property(nonatomic,retain)DetailViewController  *detail;




@end
