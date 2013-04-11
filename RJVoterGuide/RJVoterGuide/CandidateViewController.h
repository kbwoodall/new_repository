//
//  CandidateViewController.h
//  RJVoterGuide
//
//  Created by Kerry Woodall on 10/9/12.
//  Copyright (c) 2012 LVRJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "Office.h"
#import "DisplayViewController.h"

@interface CandidateViewController : UIViewController
{   
           NSArray *tableData;
}
@property (strong, nonatomic) NSArray *tableData;
@property (strong,nonatomic) Office *currentOffice; 
@end
