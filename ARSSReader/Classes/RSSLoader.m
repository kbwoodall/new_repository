//
//  RSSLoader.m
//  ARSSReader
//

#import "RSSLoader.h"

@interface RSSLoader (Private)

-(void)dispatchLoadingOperation;
-(NSDictionary*)getItemFromXmlElement:(GDataXMLElement*)xmlItem;
@end

@implementation RSSLoader
@synthesize delegate, loaded;

-(id)init
{
    
    
    //------------------------------------------------------------------------------------------
    /*
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FailedBankCD.sqlite"];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];        
    
    if (managedObjectModel == nil) {   
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FailedBankCD" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    NSLog(@"%@", managedObjectModel); 
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"FailedBankInfo" inManagedObjectContext:managedObjectContext];
   
     if (managedObjectModel == nil) {   
     NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FailedBankinfo" withExtension:@"momd"];
     managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
     }
    NSLog(@"%@", entity); 
    */
    //context = [self managedObjectContext];
    
    //RSSItem *rssItem = [NSEntityDescription                          insertNewObjectForEntityForName:@"RSTable"                                      inManagedObjectContext:context];
    
    //fetchRequest = [[NSFetchRequest alloc] init];      
    
    //entityDescription = [NSEntityDescription entityForName:@"RSTable" inManagedObjectContext:managedObjectContext];
    
    //NSLog(@"%@", entityDescription); 
    
    /*
     [fetchRequest setEntity:entity];
     NSError *error;
     self.databaseArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
     */
    
    //self.title = @"RSSitems";    
    //NSLog(@"%@", [databaseArray count]); 
    //------------------------------------------------------------------------------------------  
	if ([super init]!=nil) {
		self.loaded = NO;
	}
	return self;
}

-(void)load
{
	[self dispatchLoadingOperation];
}

-(void)dealloc
{
	self.delegate = nil;
	[super dealloc];
}

-(void)dispatchLoadingOperation
{
	NSOperationQueue *queue = [NSOperationQueue new];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:@selector(fetchRss)
																			  object:nil];
	
	[queue addOperation:operation];
	[operation release];
	[queue autorelease];
}

-(void)fetchRss
{	
    
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //NSEntityDescription *entity;
    
    //entity = [NSEntityDescription entityForName:@"RSSItem" inManagedObjectContext:managedObjectContext];
    
    //[fetchRequest setEntity:entity];
    
    NSError *error;
    
    //self.databaseArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //self.name = @"RSSItem";
    
    //NSLog(@"%@", fetchRequest); 
    
	//NSLog(@"fetch rss");
    //NSLog(kRSSUrl);
    
	NSData* xmlData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: kRSSUrl] ];
    //NSError *error;
	
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	
	if (doc != nil) {
		self.loaded = YES;
        //NSLog(@"-----------------------------------------------------");
        //NSLog(@"%@", doc.rootElement);    
        //NSLog(@"-----------------------------------------------------");
        
        NSArray *entries = [doc.rootElement elementsForName:@"entry"];              
        
        for(GDataXMLElement *e in entries){
            //NSArray *titles = [e elementsForName:@"title"];             
            //GDataXMLElement *titleElement = (GDataXMLElement *)[titles objectAtIndex:0];               
            //NSString *title = [titleElement stringValue];             
            //NSLog(@"%@", title);
            //NSLog(@"-----------------------------------------------------");                          
            
            NSString *articledesUrl=@"";
            NSArray *links = [e elementsForName:@"link"];
            for(GDataXMLElement *link in links) {
                NSString *rel = [[link attributeForName:@"rel"] stringValue];
                
                if ([rel compare:@"alternate"] == NSOrderedSame) {
                    articledesUrl =[[link attributeForName:@"href"] stringValue];
                    articledesUrl = [articledesUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];                    
                }
            }
            //NSLog(@"LINK");   
            //NSLog(@"%@", articledesUrl); 
            //NSLog(@"LINK");                                
        }          
        
        //NSLog(@"Number of entries: %i ", [entries count]);
        
        //NSMutableArray* rssItems = [NSMutableArray arrayWithCapacity:[ids count] ];          
		
		//for (GDataXMLElement* xmlItem in ids) {
		//	[rssItems addObject: [self getItemFromXmlElement:xmlItem] ];
		//}
        
        
        /*
         for(GDataXMLElement *f in [ids elementsForName:@"id"]){
         GDataXMLElement *nameElement = (GDataXMLElement *)[temp objectAtIndex:0];               
         NSString *name= [nameElement stringValue]; 
         //NSLog(@"%@", [nameElement stringValue ]);    
         //NSLog(@"%@", name);
         //NSLog(@"-----------------------------------------------------");
         
         
         }             
         for(int i =0;i<[[e elementsForName:@"id"]count];i++){
         
         GDataXMLElement *nameElement = (GDataXMLElement *)[temp objectAtIndex:indx++];               
         NSString *name= [nameElement stringValue]; 
         //NSLog(@"%@", [nameElement stringValue ]);    
         //NSLog(@"%@", name);
         //NSLog(@"-----------------------------------------------------");
         
         }        
         
         for(int i =0;i<[[e elementsForName:@"id"]count];i++){
         
         NSArray*  str = [e elementsForName:@"link"];
         
         //if (str.count) > 0) {
         //GDataXMLElement *nameElement = (GDataXMLElement *)[str objectAtIndex:0];
         //NSString name= [nameElement stringValue];    
         
         //NSLog(@"%@", [str objectAtIndex:0 ]); 
         
         //NSLog(@"%@", [nameElement stringValue ]);
         
         //}
         
         
         //NSLog(@"%@", [str objectAtIndex:0 ]);  
         //NSLog(@"*****************************************************");                  
         
         //orderByLastString = [NSString stringWithFormat:@"%@ %@",orderByFirstString,orderByLastString];
         //NSLog(@"order By String: %@",orderByLastString);
         }
         */  
		
		//GDataXMLNode* title = [[[doc rootElement] nodesForXPath:@"channel/title" error:&error] objectAtIndex:0];       
        
        //GDataXMLNode* title = [[[doc rootElement] nodesForXPath:@"//title" error:&error] objectAtIndex:0];                
        
		//[self.delegate updatedFeedTitle: [title stringValue] ];
        
        [self.delegate updatedFeedTitle: @"Review Journal" ];
		
		//NSArray* items = [[doc rootElement] nodesForXPath:@"channel/item" error:&error];     
        
        //NSArray* items = [[doc rootElement] nodesForXPath:@"//description" error:&error]; 
        
		NSMutableArray* rssItems = [NSMutableArray arrayWithCapacity:[entries count] ];          
        
		for (GDataXMLElement* xmlItem in entries) {
			[rssItems addObject: [self getItemFromXmlElement:xmlItem] ];
		}	 	  
        
        //NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaa");           
        //NSLog(@"%@", rssItems); 
        //NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaa");    
        
        [self.delegate performSelectorOnMainThread:@selector(updatedFeedWithRSS:) withObject:rssItems waitUntilDone:YES];           
        
	} else {
		[self.delegate performSelectorOnMainThread:@selector(failedFeedUpdateWithError:) withObject:error waitUntilDone:YES];
	}
	
    [doc autorelease];
    [xmlData release];
}

-(NSDictionary*)getItemFromXmlElement:(GDataXMLElement*)xmlItem
{
    NSString *articledesUrl=@"";
    NSArray *links = [xmlItem elementsForName:@"link"];
    for(GDataXMLElement *link in links) {
        NSString *rel = [[link attributeForName:@"rel"] stringValue];
        
        if ([rel compare:@"alternate"] == NSOrderedSame) {
            articledesUrl =[[link attributeForName:@"href"] stringValue];
            articledesUrl = [articledesUrl stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];            
        }
    }         
    
	return [NSDictionary dictionaryWithObjectsAndKeys:	  
            
            [[[xmlItem elementsForName:@"title"] objectAtIndex:0] stringValue], @"title",
            
            //[[[xmlItem elementsForName:@"link"] objectAtIndex:0] stringValue], 
            
            articledesUrl, @"link",       
            
            [[[xmlItem elementsForName:@"published"] objectAtIndex:0] stringValue], @"description",
            
            nil];
}

@end
