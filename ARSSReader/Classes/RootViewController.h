//
//  RootViewController.h
//  ARSSReader
//
//

#import <UIKit/UIKit.h>
#import "RSSLoader.h"
#import "CategoryViewController.h"
#import "StoryViewController.h"
#import "TableHeaderView.h"

@interface RootViewController : UITableViewController<RSSLoaderDelegate> {
	RSSLoader* rss;
	NSMutableArray* rssItems;
}


@end
