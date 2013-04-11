//
//  TableHeaderView.h
//  ARSSReader
//
//

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIImageView {
	UILabel* label;
}

- (id)initWithText:(NSString*)text;
- (void)setText:(NSString*)text;

@end
