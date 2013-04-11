//
//  CategoryViewController.h
//  ARSSReader
//
//  Created by Kerry Woodall on 6/14/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "RSSLoader.h"
#import "StoryViewController.h"
#import "UseScrollViewController.h"

@interface CategoryViewController : UITableViewController {
    UILabel* label;
    NSDictionary* item; 
    NSString* urlLink; 
    NSArray* urlArray; 
    NSArray* imageArray; 
    NSArray * tableDataList;
}

@property (nonatomic, retain) NSArray * tableDataList;
@property (retain, nonatomic) NSDictionary* item;
@property (retain, nonatomic) NSString* urlLink;
@property (retain, nonatomic) NSArray* urlArray;
@property (retain, nonatomic) NSArray* imageArray;
@property (retain, nonatomic) IBOutlet UITableView *tableOutlet;

@end



