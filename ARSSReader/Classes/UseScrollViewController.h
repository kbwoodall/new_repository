//
//  UseScrollViewController.h
//  ARSSReader
//
//  Created by Kerry Woodall on 6/27/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface UseScrollViewController : UIViewController<UIScrollViewDelegate> {   
    NSString* urlLink;  
    NSString* indexLocation; 
    NSArray* urlArray;   
       
}
@property (retain, nonatomic) NSString* urlLink;
@property (retain, nonatomic) NSString* indexLocation;
@property (retain, nonatomic) NSArray* urlArray;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@end
