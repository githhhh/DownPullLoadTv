//
//  PhotosWall.m
//  DownPullLoadTv
//
//  Created by tang bin on 13-1-11.
//  Copyright (c) 2013年 tang bin. All rights reserved.
//

#import "PhotosWall.h"
#import "AFHTTPClient.h"
#import "API.h"
#import "UIImageView+AFNetworking.h"
@interface PhotosWall ()
- (void)upload;
//- (void)setupPageControl;
@end

@implementation PhotosWall

//@synthesize pageControl;
@synthesize imgeSoure;
@synthesize detail;
@synthesize refreshView;
@synthesize gridView;
static UIPageControl *pageControl;

static  int timeCount;

static  NSData *data;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"Photos Wall";
        
    }
    return self;
}
#pragma mark -refreshView    Method
- (void)startLoading {
    [refreshView startLoading];
    // 模拟3秒后停止
    [self performSelector:@selector(stopLoading)
               withObject:nil afterDelay:3];
}
// 停止,可以触发自己定义的停止方法
- (void)stopLoading {
    [refreshView stopLoading];
}
//刷新...
- (void)refresh {
    //请求数据.....
    [[API    sharedInstance] commandWithParams:nil Method:@"GET" PATH:kAPIListPath
                                  onCompletion:^(id json){
                                      
                                      if (imgeSoure) {
                                         // NSLog(@"dsf");
                                           [imgeSoure removeAllObjects];
                                         // NSLog(@"imgeSource:%d",[imgeSoure count]);
                                      }
                                       
                                      AFHTTPRequestOperation *operation=json;
                                 
                                      imgeSoure=[[operation.responseString   JSONValue  ] retain] ;
                                  
                                      NSLog(@"刷新成功...");
                                      
                                      [self startLoading];
                                      //加载数据...
                                       [gridView  reloadData];
                                      
                                      
                                  }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Create a reload button
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonSystemItemAction target:self action:@selector(openMemu)];
    
    
    
  //  [reloadButton    setImage:[UIImage imageNamed:@"camera.png"] ];
    
    
    
    
    self.navigationItem.rightBarButtonItem = reloadButton;
    [reloadButton release];
    
    [[API    sharedInstance] commandWithParams:nil Method:@"GET" PATH:kAPIListPath
                                  onCompletion:^(id json){
                                     
               AFHTTPRequestOperation *operation=json;
                imgeSoure=[[NSMutableArray alloc] init];                       
                imgeSoure=[[operation.responseString   JSONValue  ] retain];//必须retain 否则会释放掉...
                                         
                                      
                                      //refreshView
                                       //使用NSBundle   初始化程序中的xib资源.....相当于init 
                                      NSArray *nils=[[NSBundle mainBundle ] loadNibNamed:@"RefreshView" owner:self options:nil];
                                      refreshView =[[nils objectAtIndex:0] retain];
                                      
                                      refreshView.backgroundColor =[UIColor clearColor];
                                      [ refreshView setupWithOwner:gridView.scrollView delegate:self ];
                                      
                                //      [self refresh   ];
                                      
                                      
                                    //grideView
                                      gridView.cellMargin = 5;// cell bian yuan
                                      gridView.numberOfRows = 6;
                                      gridView.numberOfColumns = 3;
                                      gridView.backgroundColor=[UIColor clearColor];
                                      
                                      gridView.layoutStyle =//HorizontalLayout;
                                      VerticalLayout;
                                      gridView.scrollView.delegate=self;
                                  //  pageControl
                                      pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0,gridView.frame.size.height-36 , 320, 39)];
                                      pageControl.numberOfPages=gridView.numberOfPages;
                                      pageControl.currentPage=gridView .currentPageIndex;
                                      
                                      [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
                                      pageControl.backgroundColor=[UIColor clearColor];
                                               
        [gridView addSubview:pageControl];
                                      
                                      
                                      timeCount=0;
                                      
                                      //定时滚动..
                                      
                                     // [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];

      }];
    
   

    
}
/*
//定时滚动
-(void)scrollTimer{
    timeCount ++;
    if (timeCount == gridView.numberOfPages) {
        timeCount = 0;
    }
    
    [gridView.scrollView setContentOffset:CGPointMake(320 * timeCount, 0) animated:YES];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}
*/
 
 - (void)changePage:(id)sender {
 UIPageControl*pagec=sender;
 int page = pagec.currentPage;//获取当前pagecontroll的值
     [UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:0.3f];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
 [gridView.scrollView setContentOffset:CGPointMake(320 * page, 0) animated:YES];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
 [UIView commitAnimations];
 }

-(void)openMemu
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"打开相机" otherButtonTitles:@"从图库选择",@"从相机胶卷选择", nil];

    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==actionSheet.cancelButtonIndex) {

        
        NSLog(@"取消.%d",actionSheet.cancelButtonIndex);
    }else
    {

    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    picker.allowsEditing=YES;
    
    switch (buttonIndex) {
        case 0://相机
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:picker animated:YES];

                [picker release];
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error" message:@"该设备找不到相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show ];
                [alert release];

            }

            break;
        case 1: //图库...
           
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self  presentModalViewController:picker animated:YES]; 
                [picker release];
                
            }else
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error" message:@"该设备找不到图库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show ];
                [alert release];
            }
            break;
            case 2://相机胶卷
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentModalViewController:picker animated:YES];
                [picker release];
            }else
            {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error" message:@"该设备找不到相机胶卷" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show ];
                [alert release];
            }
            
            
            break;
        default:
            break;
     }

    }


}


    //上传   图片......
- (void)upload
{
    /* NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSData *fileData=[NSData dataWithContentsOfFile:[ documentsDirectory stringByAppendingPathComponent:@"test.xlsx"]];
     [[API     sharedInstance] commandWithUploadFiles:@"application/vnd.ms-excel" FileName:@"test.xlsx" FileData:fileData PATH:kAPIUploadPath  onCompletion:^(id json){
     
     NSLog(@"json:%@",json);
     if (imgeSoure) {
     [imgeSoure addObject:(NSString *)json];
     }
     [gridView  reloadData];
     
     }]; */
   
}
#pragma mark 保存图片到document

-(NSString *)saveImage:(NSData *)data WithName:(NSString * )imageName

{
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //得到选择后沙盒中图片的完整路径
    NSString *  filePath = [DocumentsPath stringByAppendingPathComponent:imageName];
    
    [fileManager createFileAtPath:filePath contents:data attributes:nil];
    
    return filePath;
}



#pragma mark -UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

//上传
    NSString *extion;
    
    
      NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"]) {//选中的是图片
   
        UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
       
        if (UIImagePNGRepresentation(img)==nil) {
            data=UIImageJPEGRepresentation(img, 1.0);
            extion=@"jpeg";
        }else
        {
            data=UIImagePNGRepresentation(img) ;
            extion=@"png";
        }

    NSDateFormatter *f=[[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyyMMddHHmmss"];
    NSString *imgeName= [f stringFromDate:[NSDate date]] ;
//保持图片 到沙盒
   [self saveImage:data WithName:[NSString stringWithFormat:@"%@.%@",imgeName,extion]];
    [f release];
    
     //test.xlsx
     
//发送................................................
    [[API     sharedInstance] commandWithUploadFiles:[ NSString stringWithFormat:@"image/%@",extion] FileName:[NSString stringWithFormat:@"%@.%@",imgeName,extion] FileData:data PATH:kAPIUploadPath  onCompletion:^(id json){
     
     NSLog(@"json:%@",json);
     if (imgeSoure) {
     [imgeSoure addObject:(NSString *)json];
     }
     [gridView  reloadData];
        
    }]; 

    
  [picker dismissModalViewControllerAnimated:YES];

       
        /* //类似微薄选择图后的效果
         UIImageView *smallimage = [[[UIImageView alloc] initWithFrame:
         CGRectMake(50, 120, 40, 40)] autorelease];
         
         smallimage.image = image;
         //加在视图中
         [self.view addSubview:smallimage];*/
        
        
        
    }

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissModalViewControllerAnimated:YES];

}












#pragma - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [gridView updateCurrentPageIndex];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [gridView updateCurrentPageIndex];
}
// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_ {
    
    [refreshView scrollViewWillBeginDragging:scrollView_];
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
    
    
    [refreshView scrollViewDidScroll:scrollView_];
}
// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView_ willDecelerate:(BOOL)decelerate {
    
    [refreshView scrollViewDidEndDragging:scrollView_ willDecelerate:decelerate];
}
#pragma mark - RefreshViewDelegate
- (void)refreshViewDidCallBack {
    [self refresh];
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [gridView release];
    gridView = nil;
    [pageControl release];
    pageControl = nil;
    [super viewDidUnload];
}






#pragma - MMGridViewDataSource



- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    
    
    return  [imgeSoure count];
}
//缩放  图片
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewDefaultCell *cell = [[[MMGridViewDefaultCell alloc] initWithFrame:CGRectNull] autorelease];
//异步加载图片　　　缓存．．．．
    NSString *ex=[[[imgeSoure objectAtIndex:index] pathExtension] lowercaseString];
    
    if (![ex isEqualToString:@"jpg"]&&![ex isEqualToString:@"jpeg"]&&![ex isEqualToString:@"png"]) {
        //移除...保持..
        [cell  .backgroundView setImage:[UIImage imageNamed:@"pop.png"]];
        return cell;
        
    }
    
     NSString *URL=[kAPIHost stringByAppendingPathComponent:[imgeSoure objectAtIndex:index]];
    //  缩放图片
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:URL]] ;//释放...
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    [cell.backgroundView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"pop.png"] success:^(NSURLRequest *request,NSHTTPURLResponse *response,UIImage *img)
     {
         
         //开启线程   缩放图片....
         dispatch_queue_t queue=dispatch_queue_create("oprationImage", NULL);
         dispatch_async(queue, ^(){
             //缩放图片.....
             UIImage *sumImg= [self scaleToSize:img size:CGSizeMake(96.666664  , 87.000000) ];
             dispatch_async(dispatch_get_main_queue(), ^(){
                 //再主线程队列下
                 [cell  .backgroundView setImage:sumImg];
                 
             });
         });
         
         dispatch_release(queue);
         
         cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[self scaleToSize:img size:CGSizeMake(110  , 100) ]];
         
         
     }failure:^(NSURLRequest *request,NSHTTPURLResponse *response,NSError *error){
         NSLog(@"error:%@",[error localizedDescription]);
         
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"error" message:@"加载失败..." delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
         [alert show    ];
         [alert release]; 
         
     }];

   
    return cell;


}

#pragma - MMGridViewDelegate
- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    

    NSString *imageName =[kAPIHost stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[imgeSoure objectAtIndex:index]]];
   
     DetailViewController *barViewController;
    
  
    if (![[[imageName pathExtension] lowercaseString] isEqualToString:@"jpg"]&&![[[imageName pathExtension] lowercaseString] isEqualToString:@"png"]&&![[[imageName pathExtension] lowercaseString] isEqualToString:@"jpeg"]) {
        
        NSLog(@"不是图片..");
        barViewController = [[DetailViewController alloc] initWithDescriptor:@"testttt" withImage:nil] ;
        
    
        
    }else
    {
        NSLog(@"图片..");
        
        UIImage *imge=[[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:imageName]]];
        
        //唯一标识   来标识资源.....改变可能不能 找到
       barViewController = [[DetailViewController alloc] initWithDescriptor:@"testttt" withImage:imge] ;
        
         
    
    }
    // ...

    
    barViewController.url=imageName;
    
   
    [self.navigationController pushViewController:barViewController animated:YES];
    [barViewController release];
    
}




- (void)gridView:(MMGridView *)gridView didDoubleTapCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    
    //shuang ji
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"Cell at index %d was double tapped.", index]
                                                   delegate:nil
                                          cancelButtonTitle:@"Cool!"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    
    
}



- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
   // [self setupPageControl];
    pageControl. numberOfPages=gridView.numberOfPages;
    pageControl.currentPage=gridView.currentPageIndex;
    
}

-(void)dealloc
{
    
[data release];//释放图片...
 
    [refreshView release];
    [detail release];
    [gridView release];
   [pageControl release];
    [imgeSoure release];

 
    [super dealloc];
}

@end
