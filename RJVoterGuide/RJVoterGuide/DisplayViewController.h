//
//  DisplayViewController.h
//  PhotoViewer
//
//  Created by Kerry Woodall on 4/19/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "InfoViewController.h"

@interface DisplayViewController : UIViewController

@property (strong,nonatomic) Candidate *currentCandidate;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property (weak, nonatomic) IBOutlet UITextView *currentText;
@property (weak, nonatomic) IBOutlet UIImageView *rjimage;

@end
