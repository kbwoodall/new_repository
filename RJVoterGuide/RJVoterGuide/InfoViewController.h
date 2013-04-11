//
//  InfoViewController.h
//  PhotoViewer
//
//  Created by Kerry Woodall on 4/19/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"

@interface InfoViewController : UIViewController

@property (strong,nonatomic) Candidate *currentCandidate;
- (IBAction)dismiss:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *candidateImage;

@end
