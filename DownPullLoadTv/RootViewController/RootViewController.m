//
//  RootViewController.m
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
//  Copyright enormego 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RootViewController.h"

#import "SDImageView+SDWebCache.h"

#import "UMSocialBar.h"

#import "UIImageView+AFNetworking.h"

#import "API.h"




#import "UMSocialMacroDefine.h"


@implementation RootViewController

@synthesize detail;
@synthesize imgSouce;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.title=[NSString stringWithFormat:@"My List"];
            
        
    }

    return  self;

}



- (void)viewDidLoad {
    
   
    
    
    
    [super viewDidLoad];
	
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"上传图片" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadPH)];



    [[API    sharedInstance] commandWithParams:nil Method:@"GET" PATH:kAPIListPath    onCompletion:^(id json){
       AFHTTPRequestOperation *operation=json;
        
            imgSouce=[[NSMutableArray alloc] init];
        imgSouce=[[operation.responseString   JSONValue  ] retain];
        
        
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            view.delegate = self;
            [self.tableView addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
        [self.tableView reloadData];

    }];


    

    
    

    

	
}
-(void)uploadPH
{




    NSLog(@"上传图片.......");




}






-(void)requestImgSouce
{
    
   
    [[API    sharedInstance] commandWithParams:nil Method:@"GET" PATH:kAPIListPath   onCompletion:^(id json){
           AFHTTPRequestOperation *operation=json;
        imgSouce=[[operation.responseString   JSONValue  ] retain];
        
    }];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imgSouce count];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *URL=[kAPIHost stringByAppendingPathComponent:[imgSouce objectAtIndex:indexPath.row]];
    
    
    UIImage *image = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URL]]] autorelease ];
   self.detail=[[DetailViewController  alloc]  initWithDescriptor:URL  withImage:image] ;
[self.navigationController pushViewController:self.detail animated:YES  ];


}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   
    if (imgSouce&&[imgSouce count]!=0) { 
        
        // Configure the cell.
        cell.textLabel.text=[NSString stringWithFormat:@"图片---%d",indexPath.row];
        
        
     [cell .imageView setImageWithURL:[[NSURL alloc]initWithString:[kAPIHost stringByAppendingPathComponent:[imgSouce  objectAtIndex:indexPath.row]]] refreshCache:YES placeholderImage:[UIImage imageNamed:@"pop.png"]];
        
       
      
        
        
    }
    

    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return  80.0;

}




#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo

    //重新加载

    [[API    sharedInstance] commandWithParams:nil Method:@"GET" PATH:kAPIListPath   onCompletion:^(id json){
          AFHTTPRequestOperation *operation=json; 
        imgSouce=[[operation.responseString   JSONValue  ] retain];
        
     
        
        [self.tableView reloadData];
        _reloading = YES;
        
    }];
  

    
    
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    //完成加载
    
    
   }


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
		
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
    
 
    
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
    [super viewDidUnload];
}

- (void)dealloc {
    [detail release],detail=nil;
    [imgSouce release];
    
	_refreshHeaderView = nil;
    [super dealloc];
}


@end

