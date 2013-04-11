//
//  RSSLoader.h
//  ARSSReader
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

//#define kRSSUrl @"http://apps.stephensmedia.com/FeedDispatch/Dispatch?key=JKbnyjuhd78AIFYUGIN141C67TVNAXZB&publication=lvrj"

#define kRSSUrl @"http://apps.stephensmedia.com/FeedDispatch/Dispatch?key=43n75vw7wnAFSASDFVAFGvoagybuygve&publication=lvrj"

@protocol RSSLoaderDelegate
@required
-(void)updatedFeedWithRSS:(NSArray*)items;
-(void)failedFeedUpdateWithError:(NSError*)error;
-(void)updatedFeedTitle:(NSString*)title;
@end

@interface RSSLoader : NSObject {
	UIViewController<RSSLoaderDelegate> * delegate;
	BOOL loaded;
}

@property (retain, nonatomic) UIViewController<RSSLoaderDelegate> * delegate;
@property (nonatomic, assign) BOOL loaded;

-(void)load;

@end