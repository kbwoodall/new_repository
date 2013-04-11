//
//  StoryViewController.h
//  ARSSReader
//
//  Created by Kerry Woodall on 6/18/12.
//  Copyright (c) 2012 Las Vegas Review Journal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface StoryViewController : UIViewController{     
    NSString* urlLink;      
}    
@property (retain, nonatomic) NSString* urlLink;
@property (retain, nonatomic) IBOutlet UITextView *textOutlet;
@property (retain, nonatomic) IBOutlet UIImageView *imageOutlet;

@end
