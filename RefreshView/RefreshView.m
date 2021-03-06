//
//  RefreshView.m
//  Testself
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView
@synthesize refreshIndicator;
@synthesize refreshStatusLabel;
@synthesize refreshLastUpdatedTimeLabel;
@synthesize refreshArrowImageView;
@synthesize isLoading;
@synthesize isDragging;
@synthesize owner;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)dealloc {
    [refreshArrowImageView release];
    [refreshIndicator release];
    [refreshStatusLabel release];
    [refreshLastUpdatedTimeLabel release];
    
    [owner release];
    [super dealloc];
}

- (void)setupWithOwner:(UIScrollView *)owner_  delegate:(id)delegate_ {
    self.owner = owner_;
    self.delegate = delegate_;
    [owner insertSubview:self atIndex:0];
    self.frame = CGRectMake(0, -REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT);
    [refreshIndicator stopAnimating];
}
// refreshView 结束加载动画
- (void)stopLoading {
    
    
    
    // control
    isLoading = NO;
   // NSLog(@"停止动画...");
   // self.owner.contentInset = UIEdgeInsetsMake(-self.owner.contentOffset.y, 0, 0, 0);
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    owner.contentInset = UIEdgeInsetsZero;//恢复原位...
    owner.contentOffset = CGPointZero;//
    self.refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    
    // UI 更新日期计算
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"yyyy'-'MM'-'dd HH':'mm':'ss"];
    NSString *timeStr = [outFormat stringFromDate:nowDate];
    [outFormat release];
    // UI 赋值
    refreshLastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@", REFRESH_UPDATE_TIME_PREFIX, timeStr];
    refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
    refreshArrowImageView.hidden = NO;
    [refreshIndicator stopAnimating];
    
  
    
}

// refreshView 开始加载动画
- (void)startLoading {
    // control
    isLoading = YES;
   // NSLog(@"开始动画....");
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    owner.contentOffset = CGPointMake(0, -REFRESH_HEADER_HEIGHT);
    owner.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshStatusLabel.text = REFRESH_LOADING_STATUS;
    refreshArrowImageView.hidden = YES;
    [refreshIndicator startAnimating];
    [UIView commitAnimations];
}
// refreshView 刚开始拖动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}
// refreshView 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"isloading :%d",isLoading);
    //NSLog(@"isDragging:::%d",isDragging);
   // NSLog(@"scrollView.contentOffset.y::%f",scrollView.contentOffset.y);
   // NSLog(@"拖动过程中");

    if (isLoading) {
        
        
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y >= 0){
          // NSLog(@"1");
            scrollView.contentInset = UIEdgeInsetsZero;
        }
            
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        {
            // NSLog(@"2");
            //NSLog(@"scrollView.contentOffset.y::%f",scrollView.contentOffset.y);
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);

        }
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        
      //NSLog(@"isDragging:%d",isDragging);
       //
        
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
         // NSLog(@"scrollView.contentOffset.y::%f",scrollView.contentOffset.y);
        // NSLog(@"REFRESH_HEADER_HEIGHT::%d",REFRESH_HEADER_HEIGHT);
        
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
           // NSLog(@"3");
            
            // User is scrolling above the header
            refreshStatusLabel.text = REFRESH_RELEASED_STATUS;
            refreshArrowImageView.transform = CGAffineTransformMakeRotation(3.14);//旋转
            
             
             //  scrollView.contentInset = UIEdgeInsetsMake(-0, 0, 0, 0);
            
        } else { // User is scrolling somewhere within the header
            
           // NSLog(@"4");
            refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
            refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
            
            
        }
        [UIView commitAnimations];
    }
}
// refreshView 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        if ([delegate respondsToSelector:@selector(refreshViewDidCallBack)]) {
            [delegate refreshViewDidCallBack];
        }
    }
}
@end
