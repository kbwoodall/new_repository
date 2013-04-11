//
//  UseScrollViewController.m
//  ARSSReader
//
//  Created by Kerry Woodall on 6/27/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import "UseScrollViewController.h"

@interface UseScrollViewController ()

@end

@implementation UseScrollViewController
@synthesize scrollView;
@synthesize urlLink;
@synthesize indexLocation;
@synthesize urlArray;
UITextView *uiView;
UIImageView *imageView;
UIScrollView *sView;
UIView *view;
UIAlertView *alert;

UISwipeGestureRecognizer *oneFingerSwipeLeft;
UISwipeGestureRecognizer *oneFingerSwipeRight;

int currentIndex = 0;

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
    //NSLog(@"%@", urlArray);     
    
    //currentIndex = [self getlastIndexLocation:indexLocation];    
    currentIndex = indexLocation.intValue;    
    
    oneFingerSwipeLeft = [[[UISwipeGestureRecognizer alloc] 
                           initWithTarget:self 
                           action:@selector(oneFingerSwipeLeft:)] autorelease];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    oneFingerSwipeRight = [[[UISwipeGestureRecognizer alloc] 
                            initWithTarget:self 
                            action:@selector(oneFingerSwipeRight:)] autorelease];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
   
    [self getArrayEntry: currentIndex];    
}

-(int)getlastIndexLocation:(NSString *)indx {    
    return  [indx intValue];    
}

- (void)getArrayEntry:(int)indxLocation 
{   
    NSError *error;      
    NSData* articleData;
    GDataXMLDocument* articleDoc;      
    
    NSString *nsLink = [urlArray objectAtIndex:indxLocation];   
    articleData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: nsLink] ];           
    articleDoc = [[GDataXMLDocument alloc] initWithData:articleData options:0 error:&error];  
    
    NSArray *contents = [articleDoc.rootElement elementsForName:@"entry"];     
    NSString *content=nil;
    NSString *titleOfContent=nil;
    NSString *linkOfContent=nil;
    NSArray *articleDescription;
    NSArray *imageTitle=nil;
    NSArray *imageLink=nil;
    
    for(GDataXMLElement *contentItem in contents) {            
        articleDescription = [contentItem elementsForName:@"content"];
        imageTitle = [contentItem elementsForName:@"title"];
        imageLink = [contentItem elementsForName:@"link"];        
    }         
    for(GDataXMLElement *description in articleDescription) {
        NSString *summaryType= [[description attributeForName:@"type"] stringValue];
        if ([summaryType compare:@"html"] == NSOrderedSame) {
            content =[description stringValue];            
        }          
    }   
    for(GDataXMLElement *title in imageTitle) {
        NSString *titleType= [[title attributeForName:@"type"] stringValue];
        if ([titleType compare:@"html"] == NSOrderedSame) {
            titleOfContent =[title stringValue];  
            //NSLog(@"%@", titleOfContent);
        }          
    }   
    NSString *fullImageContentLink=nil;  
    NSMutableArray *images = [NSMutableArray array];    
    
    for(GDataXMLElement *link in imageLink) {
        NSString *linkType= [[link attributeForName:@"type"] stringValue];
        if ([linkType compare:@"application/jpg"] == NSOrderedSame) {            
            linkOfContent =[[link attributeForName:@"href"] stringValue];
            //NSLog(@"%@", linkOfContent);
            if ([linkOfContent rangeOfString:@"thn"].location != NSNotFound){
                //fullImageContentLink = linkOfContent;   
                //NSLog(@"%@", fullImageContentLink);
            }
            else {
                fullImageContentLink = linkOfContent;                
                NSURL * imageURL = [NSURL URLWithString:fullImageContentLink];
                NSData * imageData = [NSData dataWithContentsOfURL:imageURL];    
                UIImage * image = [UIImage imageWithData:imageData];
                if (image != nil)
                   [images addObject: image];
                //NSLog(@"%@", fullImageContentLink);
                //NSLog(@"%@", [images lastObject]); 
            }
        }    
    }     
    content =[content  stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    content =[content  stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n\n"];
    [view removeFromSuperview];
    
    int width = 0;
    int height = 0;
    int iSize = 0;
    for(UIImage * img in images) {    
        iSize++;
        if (img.size.height > height)
            height = img.size.height; 
        if (img.size.width > width)
            width = img.size.width;
    }   
    int cSize = (width*iSize) + 100;
    
    //setup view with message   
    //------------------------------------------------------------------------------------- 
    view = [[UIView alloc] initWithFrame:CGRectMake(30, 0 , 200, 15)];
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(30, 0, 200,15)];
    [label setText: @"multiple photos"];
    [label setFont:[UIFont fontWithName:@"Verdana" size:12.0]];  
    [label setTextColor: [UIColor blueColor]];            
    [view addSubview: label];
    //-------------------------------------------------------------------------------------    
    if (sView != nil){
       [sView removeFromSuperview];
    }    
     
    if ([images count] != 0) {           
        int left = 20;
        //setup view with image
        sView =[[UIScrollView  alloc]  initWithFrame:CGRectMake(left,15,width,height)]; 
        [sView setContentSize:(CGSizeMake(cSize, height))];
         
        for(UIImage * refImage in images) {      
            // left,down,width,height 
            //------------------------------------------------------------------------------------- 
            imageView =[[UIImageView  alloc]  initWithFrame:CGRectMake(left,15,refImage.size.width,refImage.size.height)];   
                        
            [imageView setImage:refImage];             
            [sView addSubview:imageView];   
            
            left = left + 40 + refImage.size.width;    
            //NSLog(@"%f", refImage.size.height);
            //NSLog(@"%f", refImage.size.width);
        }
        if (iSize > 1) {
            [sView addSubview:view]; 
        }
        [scrollView addSubview:sView]; 
        //-------------------------------------------------------------------------------------       
        [uiView removeFromSuperview];        
        uiView = [[UITextView alloc] initWithFrame:CGRectMake(0, height,self.view.frame.size.width,self.view.frame.size.height)];  
        [uiView setEditable:NO];     
        [uiView setText: content];      
        [uiView setFont:[UIFont fontWithName:@"Verdana" size:14.0]];  
        
        [uiView addGestureRecognizer:oneFingerSwipeLeft];
        [uiView addGestureRecognizer:oneFingerSwipeRight];
        
        [scrollView addSubview:uiView];
       //-------------------------------------------------------------------------------------
        CGFloat scrollViewHeight = 0.0f;
        for (UIView* view in scrollView.subviews)
        {
            scrollViewHeight += view.frame.size.height;
        }        
        [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];   
        [scrollView showsVerticalScrollIndicator];
        
        [imageView release];  
        [uiView release]; 
        [sView release];
        
    }else {
        sView=nil;
        [uiView removeFromSuperview];
        
        uiView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5,self.view.frame.size.width, self.view.frame.size.height)];    
        [uiView setEditable:NO];      
        [uiView setText: content];      
        [uiView setFont:[UIFont fontWithName:@"Verdana" size:14.0]]; 
        
        [uiView addGestureRecognizer:oneFingerSwipeLeft];
        [uiView addGestureRecognizer:oneFingerSwipeRight]; 
        
        [scrollView addSubview:uiView]; 
        
        CGFloat scrollViewHeight = 0.0f;
        for (UIView* view in scrollView.subviews)
        {
            scrollViewHeight += view.frame.size.height;
        }        
        [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];            
        [uiView release];   
    }   
        
    
}         


//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//	return imageView;
//}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
    
    if (currentIndex == 0)  {   
        [self getArrayEntry: currentIndex];
    }else {   
        currentIndex = currentIndex - 1;    
        [self getArrayEntry: currentIndex];
    }   
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
       
    if (currentIndex == [urlArray count] - 1)  {   
        [self getArrayEntry: currentIndex];
    }else {   
        currentIndex = currentIndex + 1;    
        [self getArrayEntry: currentIndex];
    }   
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//articleData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: urlLink] ]; 
//UIScrollView *sView =[[UIScrollView  alloc]  initWithFrame:CGRectMake(20,05,first.size.width,first.size.height)]; 
//[sView setContentSize:(CGSizeMake(800, height))];
//[sView setContentSize:(CGSizeMake((iSize*width), height))];
//[sView setContentSize:(CGSizeMake(800, first.size.height))];
//[scrollView addSubview:sView];
//imageView =[[UIImageView  alloc]  initWithFrame:CGRectMake(40,40,250, 150)];
//[imageView removeFromSuperview]; 

//UIScrollView *sView =[[UIScrollView  alloc]  initWithFrame:CGRectMake(left,05,refImage.size.width,refImage.size.height)]; 
//sView =[[UIScrollView  alloc]  initWithFrame:CGRectMake(left,05,refImage.size.width,refImage.size.height)]; 

//[sView setContentSize:(CGSizeMake(20, imageView.frame.size.height))];

//[sView setContentSize:(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height))];

//NSURL * imageURL = [NSURL URLWithString:fullImageContentLink];
//NSData * imageData = [NSData dataWithContentsOfURL:imageURL];    
//UIImage * image = [UIImage imageWithData:imageData];

//UIScrollView *sView = [[UIScrollView alloc] initWithFrame:                                                                   (CGSizeMake(imageView.frame.size.width, imageView.frame.size.height))];   

//[sView setContentSize:(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height))];

//[sView addSubview:imageView];        
//[scrollView addSubview:sView];  
/*
 if ([images count] > 0) {
 [imageView2 removeFromSuperview]; 
 
 UIImage *refImage2 = [images objectAtIndex:1];        
 imageView2 =[[UIImageView  alloc]  initWithFrame:CGRectMake(40,300,refImage2.size.width,refImage2.size.height)];       
 [imageView2 setImage:refImage2]; 
 [scrollView addSubview:imageView2];
 }
 */ 

//sView removeFromSuperview];
//CGFloat sViewHeight = imageView.frame.size.height;        
//[sView setContentSize:(CGSizeMake(320, sViewHeight))];         
//[sView addSubview:imageView];     

/*
 alert = [[[UIAlertView alloc]
 initWithTitle:@"Swiping right" message: string
 
 delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] 
 autorelease];    
 [alert show];      
 */

//[scrollView removeFromSuperview];    
//[self.view addSubview:scrollView];

//CGFloat scrollViewHeight = 0.0f;
//for (UIView* view in scrollView.subviews)
//{
//    scrollViewHeight += view.frame.size.height;
//}
//[scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];   

//[scrollView setContentSize:(CGSizeMake(320, 800))]; 
//[scrollView addSubview:uiView];

/*
 NSError *error;      
 NSData* articleData;
 GDataXMLDocument* articleDoc;      
 
 // urlLink starting point
 
 NSString *nsLink = [urlArray objectAtIndex:0];                           
 
 //articleData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: nsLink] ];            
 
 articleData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: urlLink] ];            
 
 articleDoc = [[GDataXMLDocument alloc] initWithData:articleData options:0 error:&error];  
 
 NSArray *contents = [articleDoc.rootElement elementsForName:@"entry"];     
 NSString *content=nil;
 NSString *titleOfContent=nil;
 NSString *linkOfContent=nil;
 NSArray *articleDescription;
 NSArray *imageTitle=nil;
 NSArray *imageLink=nil;
 
 for(GDataXMLElement *contentItem in contents) {            
 articleDescription = [contentItem elementsForName:@"content"];
 imageTitle = [contentItem elementsForName:@"title"];
 imageLink = [contentItem elementsForName:@"link"];        
 }         
 for(GDataXMLElement *description in articleDescription) {
 NSString *summaryType= [[description attributeForName:@"type"] stringValue];
 if ([summaryType compare:@"html"] == NSOrderedSame) {
 content =[description stringValue];            
 }          
 }   
 for(GDataXMLElement *title in imageTitle) {
 NSString *titleType= [[title attributeForName:@"type"] stringValue];
 if ([titleType compare:@"html"] == NSOrderedSame) {
 titleOfContent =[title stringValue];  
 //NSLog(@"%@", titleOfContent);
 }          
 }   
 NSString *fullImageContentLink=nil;    
 for(GDataXMLElement *link in imageLink) {
 NSString *linkType= [[link attributeForName:@"type"] stringValue];
 if ([linkType compare:@"application/jpg"] == NSOrderedSame) {            
 linkOfContent =[[link attributeForName:@"href"] stringValue];
 //NSLog(@"%@", linkOfContent);
 
 //BOOL *myBool = [linkOfContent rangeOfString:@"thn"];
 
 if ([linkOfContent rangeOfString:@"thn"].location != NSNotFound)
 {       
 //fullImageContentLink = linkOfContent;   
 //NSLog(@"%@", fullImageContentLink);
 }
 else {
 fullImageContentLink = linkOfContent;
 //NSLog(@"%@", fullImageContentLink);
 }
 }    
 }      
 content =[content  stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
 content =[content  stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n\n"];
 
 NSURL * imageURL = [NSURL URLWithString:fullImageContentLink];
 NSData * imageData = [NSData dataWithContentsOfURL:imageURL];    
 UIImage * image = [UIImage imageWithData:imageData];
 
 if (image != nil) {     
 // left,down,width,height 
 //imageView =[[UIImageView  alloc]  initWithFrame:CGRectMake(40,40,250, 150)];
 
 imageView =[[UIImageView  alloc]  initWithFrame:CGRectMake(40,40,image.size.width,image.size.height)];        
 
 [imageView setImage:image]; 
 uiView = [[UITextView alloc] initWithFrame:CGRectMake(0, 200,self.view.frame.size.width,self.view.frame.size.height)];  
 [uiView setEditable:NO];     
 [uiView setText: content];      
 [uiView setFont:[UIFont fontWithName:@"Verdana" size:14.0]];  
 
 [uiView addGestureRecognizer:oneFingerSwipeLeft];
 [uiView addGestureRecognizer:oneFingerSwipeRight];
 
 [scrollView addSubview:imageView];
 [scrollView addSubview:uiView];
 
 CGFloat scrollViewHeight = 0.0f;
 for (UIView* view in scrollView.subviews)
 {
 scrollViewHeight += view.frame.size.height;
 }        
 [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];   
 [scrollView showsVerticalScrollIndicator];
 
 [imageView release];  
 [uiView release]; 
 }else {
 topView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5,self.view.frame.size.width, self.view.frame.size.height)];    
 [topView setEditable:NO];      
 [topView setText: content];      
 [topView setFont:[UIFont fontWithName:@"Verdana" size:14.0]]; 
 
 [topView addGestureRecognizer:oneFingerSwipeLeft];
 [topView addGestureRecognizer:oneFingerSwipeRight]; 
 
 [scrollView addSubview:topView]; 
 
 CGFloat scrollViewHeight = 0.0f;
 for (UIView* view in scrollView.subviews)
 {
 scrollViewHeight += view.frame.size.height;
 }        
 [scrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];            
 [topView release];   
 }    
 
 */ 


/*
 UISwipeGestureRecognizer *oneFingerSwipeLeft = [[[UISwipeGestureRecognizer alloc] 
 initWithTarget:self 
 action:@selector(oneFingerSwipeLeft:)] autorelease];
 [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
 
 UISwipeGestureRecognizer *oneFingerSwipeRight = [[[UISwipeGestureRecognizer alloc] 
 initWithTarget:self 
 action:@selector(oneFingerSwipeRight:)] autorelease];
 [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
 */

//NSString *indxLocation = @"1";  

/* 
 [topView canBecomeFirstResponder];
 [uiView canBecomeFirstResponder];
 //UITextView *topView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
 //UITextView *uiView = [[UITextView alloc] initWithFrame:CGRectMake(0, 150,self.view.frame.size.width,self.view.frame.size.height)];  
 //NSString *tempUrl = @"http://apps03.stephensmedia.com/Atom3Feeds/Atom3Servlet?xmltype=StoryId&imagevariant=1&publicationcode=RJA,NEON,DRIVE,HOME_AND_GARDEN&feedvariant=50075&key=243mnaf09245mknmcfp98a2j1k34&StoryId=54301883&publication=lvrj&&date=061820120835";
 //[scrollView setScrollEnabled:YES];  
 //CGSize newSize = CGSizeMake(500, 300);  //whaterver size
 //UIGraphicsBeginImageContext(newSize);
 //[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
 //UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
 //UIGraphicsEndImageContext();
 //image = newImage;
 
 //NSURL * imageURL = [NSURL URLWithString:linkOfContent];
 UIImage *image = [UIImage imageNamed:@"icon.jpg"];
 //we need to create a framework the ui image view
 CGRect frame = CGRectMake(0, 0, 50, 50);
 //initialize the ui image view
 imageView = [[UIImageView alloc] initWithFrame:frame];
 imageView.image = image;
 
 //set the content size of the scroll view
 //for more information please consult the UIScrollView's documentation
 scrollView.contentSize = imageView.frame.size;
 
 //scrollView.contentSize = 
 //CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
 
 scrollView.maximumZoomScale = 4.0;
 scrollView.minimumZoomScale = 0.75;
 scrollView.clipsToBounds = YES;
 scrollView.delegate = self;
 
 [scrollView addSubview:imageView];  
 [image release];
 
 */

/*    
 NSInteger viewcount= 4; 
 for (int i = 0; i <viewcount; i++) 
 { 
 CGFloat y = i * self.view.frame.size.height; 
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y,self.view.frame.size.width, self .view.frame.size.height)];      
 view.backgroundColor = [UIColor greenColor]; 
 [scrollView addSubview:view]; 
 [view release]; 
 }
 scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *viewcount); 
 */

//NSInteger viewcount= 4; 
//for (int i = 0; i <viewcount; i++) 
//{ 
//CGFloat y = i * self.view.frame.size.height; 
//UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];     
//-------------------
//-------------------
//UIImage *image = [UIImage imageNamed:@"icon.jpg"];

//[imageView setImage:image];

//UIImageView *iView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 100)]; 

//UIImageView *iView = [[UIImageView alloc] initWithImage:image]; 

//[iView setImage:image];
//UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100,300, 282)];   

//UIImageView *image =[[UIImageView  alloc]  initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 100)];

//imageView.frame.size.width

//UIImageView *image =[[UIImageView  alloc]  initWithFrame:CGRectMake(0, 30, 42, 152)];
//-------------------
//[scrollView addSubview:imageView]; 
//[scrollView addSubview:view];     
//[view release]; 
//scrollView.contentSize = image.frame.size;
//scrollView.maximumZoomScale = 4.0;
//scrollView.minimumZoomScale = 0.75;
//scrollView.clipsToBounds = YES;
//scrollView.delegate = self;

