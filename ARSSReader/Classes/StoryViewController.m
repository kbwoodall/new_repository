//
//  StoryViewController.m
//  ARSSReader
//
//  Created by Kerry Woodall on 6/18/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import "StoryViewController.h"
@interface StoryViewController ()

@end

@implementation StoryViewController
@synthesize urlLink;
@synthesize textOutlet;
@synthesize imageOutlet;

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
    
    NSError *error;      
    NSData* articleData;
    GDataXMLDocument* articleDoc;       
    
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
    
    for(GDataXMLElement *link in imageLink) {
        NSString *linkType= [[link attributeForName:@"type"] stringValue];
        if ([linkType compare:@"application/jpg"] == NSOrderedSame) {            
            linkOfContent =[[link attributeForName:@"href"] stringValue];
            //NSLog(@"%@", linkOfContent);
        }    
    }    
       
    content =[content  stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    content =[content  stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n\n"];
    
    [textOutlet setText: content];      
    [textOutlet setFont:[UIFont fontWithName:@"Verdana" size:14.0]];   
    
    NSURL * imageURL = [NSURL URLWithString:linkOfContent];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];    
    UIImage * image = [UIImage imageWithData:imageData];
    
    if (image != nil) {
        CGSize newSize = CGSizeMake(250, 150);  //whaterver size
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
        UIGraphicsEndImageContext();
        image = newImage;
   
        [imageOutlet setImage:image]; 
    }    
            
    // Do any additional setup after loading the view from its nib.
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

- (void)dealloc {
	//very important, otherwise unfinished requests will cause exc_badaccess
	[urlLink release];
    [textOutlet release];   
    
    [super dealloc];   
    
}


@end
