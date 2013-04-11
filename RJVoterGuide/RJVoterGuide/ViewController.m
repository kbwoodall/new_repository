//
//  ViewController.m
//  RJVoterGuide
//
//  Created by Kerry Woodall on 10/9/12.
//  Copyright (c) 2012 LVRJ. All rights reserved.
//

#import "ViewController.h"

#define DISPLAY_CANDIDATES @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=CANDIDATEBRIEF&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE"

#define DISPLAY_OFFICES @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=OFFICE&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE"

#define GET_ALL_DETAIL @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=CANDIDATEBRIEF&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableData;

NSMutableArray *candidates;
NSMutableArray *offices;

NSIndexPath *path;
Candidate *can;
Office *off;

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //NSString *val5 = @"going to CandidateViewController";
    //NSLog(@"%@", val5);
    CandidateViewController *dvc = [segue destinationViewController];
    //DisplayViewController *dvc = [segue destinationViewController];
    [dvc setCurrentOffice:off];
    //NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    //Candidate *c = [candidates objectAtIndex:[path row]];
    
    
}
/*
 - (id)initWithStyle:(UITableViewStyle)style
 {
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayOffices];
    [self displayCandidates];
    [self filterCandidates];
    [self getAllDetail];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //NSString *val = @"number of sections";
    //NSLog(@"%@", val);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [photos count];
    //NSString *val3 = @"number of rows";
    //NSLog(@"%@", val3);
    //return [candidates count];
    //NSLog(@"%u",[offices count] );
    return [offices count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *val4 = @"cellForRowAtIndexPath";
    //NSLog(@"%@", val4);
    
    static NSString *CellIdentifier = @"OfficeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Office *current = [offices objectAtIndex:indexPath.row];
    NSString *on = [current officeName];
    NSString *fullName = [NSString stringWithFormat:@"%@",on];
    
    //[fullName sizeWithFont:[UIFont fontWithName:@"Verdana" size:6]];
    
    cell.textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    cell.textLabel.numberOfLines = 0;
    cell.font = [UIFont fontWithName:@"Verdana" size:12];
    
    [cell.textLabel setText:fullName];
    
    /*
     Candidate *current = [candidates objectAtIndex:indexPath.row];
     NSString *fn = [current firstName];
     NSString *ln = [current lastName];
     NSString *comma = @", ";
     NSString *fullName = [NSString stringWithFormat:@"%@%@%@",ln,comma,fn];
     [cell.textLabel setText:fullName];
     */
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *val6 = @"selected row";
    //NSLog(@"%@", val6);
    path = [tableView indexPathForSelectedRow];
    //can = [candidates objectAtIndex:[path row]];
    off = [offices objectAtIndex:[path row]];
    
    //NSLog(@"%@", off.officeId);
    //NSLog(@"%@", off.officeName);
    //NSLog(@"%@", val6);
    [self performSegueWithIdentifier:@"ShowPeople" sender:indexPath];
    
    /*
     Navigation logic may go here. Create and push another view controller.
     DisplayViewController *dvc = [[DisplayViewController alloc] initWithNibName:
     initWithNibName:@"<#Nib name#>" bundle:nil];
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)displayCandidates
{
    //NSString *result = @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=CANDIDATEBRIEF&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE";
    
    NSString *result = DISPLAY_CANDIDATES;
    
    NSURL *url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:
                        request returningResponse: &resp error: &err];
    //NSLog(@"%@", url);
    //NSLog(@"%@", result);
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    //NSLog(@"%@", array);
    candidates = [[NSMutableArray alloc] init];
    NSEnumerator *e = [array objectEnumerator];
    id dict;
    while (dict = [e nextObject]) {
        NSString *firstName = [dict objectForKey:@"firstName"];
        NSString *lastName = [dict objectForKey:@"lastName"];
        NSString *masterCandidateId = [dict objectForKey:@"masterCandidateId"];
        //NSLog(@"%@", firstName);
        //NSLog(@"%@", lastName);
        //NSLog(@"%@", masterCandidateId);
        
        Candidate *candidate = [[Candidate alloc] init];
        [candidate setFirstName:firstName];
        [candidate setLastName:lastName];
        [candidate setMasterCandidateId:masterCandidateId];
        
        [candidates addObject:candidate];
        
    }
    //sort the object
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
    [candidates sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //print log
    //for (Candidate *s in candidates) {
    //    NSLog(@"id = %@ and Name = %@\n",s.masterCandidateId,s.lastName);
    //}
    //NSString *val = @"loading values";
    //NSLog(@"%@", val);
    
}

- (void)displayOffices
{
    //NSString *result = @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=OFFICE&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE";
    
    NSString *result = DISPLAY_OFFICES;
    
    NSURL *url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:
                        request returningResponse: &resp error: &err];
    //NSLog(@"%@", url);
    //NSLog(@"%@", result);
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    
    //NSLog(@"%@", array);
    offices = [[NSMutableArray alloc] init];
    NSEnumerator *e = [array objectEnumerator];
    id dict;
    while (dict = [e nextObject]) {
        NSString *apOfficeName = [dict objectForKey:@"apOfficeName"];
        NSString *officeId = [dict objectForKey:@"officeId"];
        NSString *officeName = [dict objectForKey:@"officeName"];
        //NSLog(@"%@", apOfficeName);
        //NSLog(@"%@", officeId);
        //NSLog(@"%@", officeName);
        
        NSString *upperString = [[NSString alloc] initWithFormat:officeName];
        NSString* changeString = [upperString uppercaseString];
        
        Office *office = [[Office alloc] init];
        [office setApOfficeName:apOfficeName];
        [office setOfficeId:officeId];        
        [office setOfficeName:changeString];    
        [offices addObject:office];
        
    }
    //sort the object
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"officeName" ascending:YES];
    
    [offices sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    //print log
    //for (Office *idx in offices) {
    //    NSLog(@"Name = %@\n",idx.officeName);
    //}
}

- (void)filterCandidates
{
    //NSString *val3 = @"In filterCandidates";
    //NSLog(@"%@", val3);
    //NSLog(@"%@", offices);
    //NSLog(@"%@", candidates);
    //for (Office *i in offices) {
    //    NSLog(@"Name = %@\n",i.officeId);
    //}
    //for (Candidate *ix in candidates) {
    //    NSLog(@"Name = %@\n",ix.masterCandidateId);
    //}
}


- (void)getAllDetail
{
    //NSString *val3 = @"In getAllDetail";
    //NSLog(@"%@", val3);
    
    //NSString *result = @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=CANDIDATEBRIEF&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE";
    
    NSString *result = GET_ALL_DETAIL;
    
    //NSString *result = @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=CANDIDATE&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE";
       
    //NSString *newUrl = @"http://appdev01.stephensmedia.com:8080/CandidateGSON/GsonServlet?key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE&get=OFFICE";
    
    NSURL *url = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:
                        request returningResponse: &resp error: &err];
    
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:response
                     options:kNilOptions
                     error:&error];
    
    //NSLog(@"%u", json.count);
    
    //NSLog(@"%@", result);
    //NSArray *jo = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    //NSLog(@"%@", o.);
    //NSMutableArray *cc = [[NSMutableArray alloc] init];
    //NSEnumerator *e = [array objectEnumerator];
    //id dict;
    //while (dict = [e nextObject]) {
    //NSLog(@"here");
    //NSString *firstName = [dict objectForKey:@"firstName"];
    //NSString *lastName = [dict objectForKey:@"lastName"];
    //NSString *masterCandidateId = [dict objectForKey:@"masterCandidateId"];
    //NSLog(@"%s", "here");
    //NSLog(@"%@", lastName);
    //NSLog(@"%@", masterCandidateId);
    //Candidate *candidate = [[Candidate alloc] init];
    //[candidate setFirstName:firstName];
    //[candidate setLastName:lastName];
    //[candidate setMasterCandidateId:masterCandidateId];
    //[candidates addObject:candidate];
    //}
    
    /*
     NSString *url1 = @"http://apps01.stephensmedia.com/CandidateGSON/GsonServlet?get=CANDIDATE&";
     NSString *url2 = @"&key=SFDOYYHOIHEDFHOPVNVNUPENURYORWEYOEVBYTWE";
     NSString *urlnew = [NSString stringWithFormat:@"%@%@",url1,url2];
     
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlnew]];
     NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSString *jString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
     //NSURL *url = [NSURL URLWithString:[urlnew stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
     //NSURLRequest *request = [NSURLRequest requestWithURL:url];
     //NSURLResponse *resp = nil;
     //NSError *err = nil;
     //NSData *response = [NSURLConnection sendSynchronousRequest:
     //                    request returningResponse: &resp error: &err];
     NSLog(@"%@", jString);
     //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
     NSLog(@"%@",[dict allKeys]);
     NSLog(@"%@", dict.allValues);
     NSError *jsonError;
     if (!jsonError) {
     NSDictionary *office = [dict objectForKey:@"office"];
     NSString *officeName = [office objectForKey:@"officeName"];
     NSString *officeId = [office objectForKey:@"officeId"];
     NSLog(@"%@", officeName);
     NSLog(@"%@", officeId);
     }
     else {
     NSLog(@"There was a JSONSerialization Error: %@",jsonError);
     }
     */
}

@end