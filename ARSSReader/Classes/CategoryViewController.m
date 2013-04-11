//
//  CategoryViewController.m
//  ARSSReader
//
//  Created by Kerry Woodall on 6/14/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import "CategoryViewController.h"
#import "UseScrollViewController.h"
#import "StoryViewController.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

@synthesize tableDataList;
@synthesize item;
@synthesize urlLink;
@synthesize urlArray;
@synthesize imageArray;
@synthesize tableOutlet;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSMutableArray *myArray = [[NSMutableArray alloc] init]; 
    NSMutableArray *tempUrlArray = [[NSMutableArray alloc] init]; 
    NSMutableArray *tempImageArray = [[NSMutableArray alloc] init]; 
    
    [super viewDidLoad];    
    
    NSString *categoryLinkValue = [item objectForKey:@"link"];  
    
    NSData* categoryLevelData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: categoryLinkValue] ];
    
    NSError *error;
    NSString *articledesUrl=@"";  
	
    GDataXMLDocument* categoryDoc = [[GDataXMLDocument alloc] initWithData:categoryLevelData options:0 error:&error];    
    
    NSString *cTitle;        
    
    if (categoryDoc != nil) {	       
        NSArray *categoryEntries = [categoryDoc.rootElement elementsForName:@"entry"];  
        if (categoryEntries != nil) {	
            
            for(GDataXMLElement *e in categoryEntries){
                
                //NSLog(@"%@", e); 
                
                NSArray *catTitles = [e elementsForName:@"title"];  
                
                GDataXMLElement *titleElement = (GDataXMLElement *)[catTitles objectAtIndex:0];    
                cTitle = titleElement.stringValue;         
                
                // Store category titles
                if (cTitle != nil) {	
                    [myArray addObject:cTitle];             
                }
                articledesUrl=@"";
                
                NSArray *links = [e elementsForName:@"link"];
                
                for(GDataXMLElement *link in links) {
                    NSString *rel = [[link attributeForName:@"rel"] stringValue];
                    
                    if ([rel compare:@"alternate"] == NSOrderedSame) {
                        articledesUrl =[[link attributeForName:@"href"] stringValue];
                        articledesUrl = [articledesUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];                        
                    }                 
                }                    
                // Store links
                if (articledesUrl != nil) {	
                    [tempUrlArray addObject:articledesUrl];    
                          
                    NSData* articleData;
                    GDataXMLDocument* articleDoc;
                    NSError *error;  
                    
                    articleData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: articledesUrl] ];        
                    //NSLog(@"%@", urlLink);    
                    articleDoc = [[GDataXMLDocument alloc] initWithData:articleData options:0 error:&error];  
                    
                    NSArray *contents = [articleDoc.rootElement elementsForName:@"entry"];     
                    
                    NSString *linkOfContent=nil;
                    NSString *thumbNailLink=nil;
                    
                    NSArray *imageLink=nil;
                    
                    for(GDataXMLElement *contentItem in contents) {           
                        imageLink = [contentItem elementsForName:@"link"];        
                    }         
                    
                    for(GDataXMLElement *link in imageLink) {
                        NSString *linkType= [[link attributeForName:@"type"] stringValue];
                        if ([linkType compare:@"application/jpg"] == NSOrderedSame) {            
                            linkOfContent =[[link attributeForName:@"href"] stringValue];  
                           
                            if ([linkOfContent rangeOfString:@"thn"].location != NSNotFound){
                                thumbNailLink = linkOfContent;
                                //NSLog(@"%@", linkOfContent);
                            }
                            else {
                                //thumbNailLink = linkOfContent;
                                //NSLog(@"%@", linkOfContent);
                            }                           
                        }    
                    }
                  
                    NSURL * imageURL = [NSURL URLWithString:thumbNailLink];                  
                    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];    
                    UIImage * image = [UIImage imageWithData:imageData];
                    
                    if (image == nil) {
                        image = [UIImage imageNamed:@"icon.png"]; 
                        CGSize newSize = CGSizeMake(40, 40);  
                        UIGraphicsBeginImageContext(newSize);
                        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
                        UIGraphicsEndImageContext();
                        image = newImage;
                        [tempImageArray addObject:image];                          
                    }else {    
                        CGSize newSize = CGSizeMake(40, 40);  //whaterver size
                        UIGraphicsBeginImageContext(newSize);
                        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
                        UIGraphicsEndImageContext();
                        image = newImage;
                        [tempImageArray addObject:image];                         
                    }
                    
                    urlLink = articledesUrl; 
                }    
            }  
        }    
        // Saves all category titles
        
        if (myArray == nil) 
            [myArray addObject:@"Titles not available see administrator"];  
        else   { 
            tableDataList = myArray;
            urlArray = tempUrlArray;     
            imageArray = tempImageArray;
        }    
    }       
    
}
- (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    [image drawInRect:CGRectMake(0,0,85,85)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableDataList count];        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellIdentifier] autorelease];
    }        
    cell.textLabel.text = [self.tableDataList objectAtIndex:[indexPath row]];   
    cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14.0]; 
    cell.imageView.image = [imageArray objectAtIndex:[indexPath row]]; 
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    /*
     UIAlertView *alert = [[[UIAlertView alloc]
     initWithTitle:@"Pending" message:@"Work in progress"
     delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] 
     autorelease];
     [alert show];                      
     */    
    
    // Navigation logic may go here. Create and push another view controller.
    
    int row = indexPath.row;     
    
    UseScrollViewController *useScrollViewController = [[UseScrollViewController alloc] initWithNibName:@"UseScrollViewController" bundle:nil];       
    
    NSString *urlStr = [urlArray objectAtIndex:row];     
    
    //NSLog(@"%@", urlArray); 
    
    useScrollViewController.urlLink = urlStr;   
    useScrollViewController.urlArray = urlArray;  
    
    NSString * idx = [NSString stringWithFormat:@"%i", row];   
    
    useScrollViewController.indexLocation = idx; 
    
    // Pass the selected object to the new view controller.   
    /*
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity startAnimating];
    
	[cell setAccessoryView: activity];
	[activity release];
    */    
    
    [self.navigationController pushViewController:useScrollViewController animated:YES];
    [useScrollViewController release];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPathLast:(NSIndexPath *)indexPath
{   
    /*
     UIAlertView *alert = [[[UIAlertView alloc]
     initWithTitle:@"Pending" message:@"Work in progress"
     delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] 
     autorelease];
     [alert show];                      
     */    
    
    // Navigation logic may go here. Create and push another view controller.
    
    int row = indexPath.row;     
    
    StoryViewController *storyViewController = [[StoryViewController alloc] initWithNibName:@"StoryViewController" bundle:nil];       
    
    NSString *urlStr = [urlArray objectAtIndex:row];       
    
    storyViewController.urlLink = urlStr;   
    
    // Pass the selected object to the new view controller.  
     
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity startAnimating];
    
	[cell setAccessoryView: activity];
	[activity release];
    
    //[self.navigationController pushViewController:storyViewController animated:YES];
    //[storyViewController release];
    
}

- (void)dealloc {
	//very important, otherwise unfinished requests will cause exc_badaccess
	[tableDataList release];
    [tableOutlet release];
    [item release];
    [urlLink release];
    [urlArray release];    
    imageArray = nil;
    [imageArray release];
    
    [super dealloc];    
    
    
}
@end

