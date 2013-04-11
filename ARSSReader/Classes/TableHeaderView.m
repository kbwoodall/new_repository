//
//  TableHeaderView.m
//  ARSSReader
//

#import "TableHeaderView.h"

@implementation TableHeaderView

- (id)initWithText:(NSString*)text 
{
    
	UIImage* img = [UIImage imageNamed:@"arss_header.png"];
    
    UIImageView *imageForNewstag =[[UIImageView  alloc] init];
    imageForNewstag.frame =CGRectMake(3, 8, 40, 275);
    imageForNewstag.image =[UIImage  imageNamed:@"logo-212x144.png"];
    imageForNewstag.backgroundColor =[UIColor  clearColor]; 
    
    //UIImage* img = [UIImage imageNamed:@"icon.png"];
    
    if ((self = [super initWithImage:img])) {
        // Initialization code
		label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,200,70)];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor grayColor];
		label.shadowOffset = CGSizeMake(1, 1);
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:20];
		label.text = text;
		//label.numberOfLines = 1;
        label.numberOfLines = 2;
		[self addSubview:label];
		[label release];
    }
    
    return self;
}



- (void)setText:(NSString*)text
{
	label.text = text;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [super dealloc];
}

@end
