//
//  InfoViewController.m
//  PhotoViewer
//
//  Created by Kerry Woodall on 4/19/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import "InfoViewController.h"
#import "Candidate.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize detailsLabel;

@synthesize currentCandidate;
@synthesize candidateImage;

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
	// Do any additional setup after loading the view.
    
    NSString *fn = [currentCandidate firstName];
    NSString *ln = [currentCandidate lastName];
    NSString *space = @" ";
    NSString *fullName = [NSString stringWithFormat:@"%@%@%@",fn,space,ln];
    ln = ln.lowercaseString;
    NSString *id = [currentCandidate masterCandidateId];
    
    //NSLog(@"%@", @"in infoViewController");
    //NSLog(@"%@", id);
    
    NSString *http = @"http://media.lvrj.com/images/";
    NSString *mid = @"-election2012-";
    NSString *png = @".png";
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@%@%@%@",http,ln,mid,id,png];
    //NSLog(@"%@", fullUrl);
    
    //NSURL *url = [NSURL URLWithString:[fullUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //NSURLResponse *resp = nil;
    //NSError *err = nil;
    //NSData *response = [NSURLConnection sendSynchronousRequest:
    //request returningResponse: &resp error: &err];
    //NSLog(@"%@", response);
    
    UIImage* canImage = [UIImage imageWithData:
                         [NSData dataWithContentsOfURL:
                          [NSURL URLWithString: fullUrl]]];
    
    //[NSURL URLWithString: @"http://example.com/image.jpg"]]];
    
    UIImage *image = [UIImage imageNamed: @"Unknown-person.gif"];
    
    if (canImage == nil)
        [candidateImage setImage: image];
    else
        [candidateImage setImage: canImage];
    
    //detailsLabel setText:[currentCandidate lastName]];
    detailsLabel.text = fullName;
    //[detailsLabel setText:fullName];
    //[detailsLabel setTextAlignment:UITextAlignmentCenter];
}

- (void)viewDidUnload
{
    [self setDetailsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //[self dismissModalViewControllerAnimated:YES];
    
}
@end
