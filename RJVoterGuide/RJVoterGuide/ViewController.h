//
//  ViewController.h
//  RJVoterGuide
//
//  Created by Kerry Woodall on 10/9/12.
//  Copyright (c) 2012 LVRJ. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "Office.h"
#import "CandidateViewController.h"

@interface ViewController : UIViewController <UITableViewDataSource>
{
    NSArray *tableData;
}
@property (strong, nonatomic) NSArray *tableData;

@end
