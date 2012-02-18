//
//  RootViewController.m
//  SDLUIKitDelegate
//
//  Created by Michelle on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "ContentsViewController.h"


@implementation RootViewController

@synthesize detailViewController;

NSMutableArray *discoveredWebServices;
NSNetServiceBrowser *bonjourBrowser;


//START:code.BonjourWebBrowser.startSearchingForWebServers
-(void) startSearchingForWebServers {
	bonjourBrowser = [[NSNetServiceBrowser alloc] init];
	[bonjourBrowser setDelegate: self];
	//if ([fetchSectioningControl selectedSegmentIndex] == 0) {
	[bonjourBrowser searchForServicesOfType:@"_html._tcp" inDomain:@""]; //<label id="code.BonjourWebBrowser.startSearchingForWebServers.searchforservicesoftype"/>
	//}else {
	
	// [bonjourBrowser searchForServicesOfType:@"_services._dns-sd._udp." inDomain:@""];	
	//}
	//[tableView reloadData];
	
}
//END:code.BonjourWebBrowser.startSearchingForWebServers

// bonjour delegate methods
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser {
	//[activityIndicator startAnimating];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
	//[activityIndicator stopAnimating];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
	//[activityIndicator stopAnimating];
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	[discoveredWebServices addObject: netService];
	[self.tableView  reloadData];
	//if (! moreServicesComing)
	//	[activityIndicator stopAnimating];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {
	[discoveredWebServices removeObject: netService];
	[self.tableView reloadData];
}


// resolution delegate methods
- (void)netServiceDidResolveAddress:(NSNetService *)aService {
	
	if (aService != NULL) {
		
		
		NSDictionary *txtRecordDictionary = //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.start"/>
		[NSNetService dictionaryFromTXTRecordData:
		 [aService TXTRecordData]];
		NSData *pathData =
		(NSData*) [txtRecordDictionary objectForKey: @"path"];
		NSString *path = [[NSString alloc] initWithData: pathData
											   encoding:NSUTF8StringEncoding];  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.end"/>
		
		NSData *portData =
		(NSData*) [txtRecordDictionary objectForKey: @"port"];
		NSString *port = [[NSString alloc] initWithData: portData
											   encoding:NSUTF8StringEncoding];  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.getpathfromtxtrecord.end"/>
		
		
		// build URL from host, port, and path
		
		
		NSRange range = [path rangeOfString : @"uuid:"];
		NSLog(path);
		
		if (range.location != NSNotFound) {
			urlString = [[NSString alloc]  //<label id="code.BonjourWebBrowser.startSearchingForWebServers.buildurl.start"/>
						 initWithFormat: @"http://%@:%@/?UDN=%@&id=",
						 [aService hostName],
						 port,
						 path];
			NSLog(@"this is a media server %@", urlString);
			NSLog([aService hostName]);
			NSLog(path);
			
			[self jsonFromURLString:urlString forId:@"0" ];	
		}
		
	}
}


- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Discovered Web Services";
	discoveredWebServices = [[NSMutableArray alloc] initWithCapacity: 10]; // arbitrary initial capacity
	[self startSearchingForWebServers];	
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section { 
	return [NSString stringWithFormat:@"found - %d services", [discoveredWebServices count]];
}



- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [discoveredWebServices count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	NSNetService *aService = (NSNetService*) [discoveredWebServices objectAtIndex: [indexPath row]];
	if (aService != NULL) {

    //  cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
		cell.textLabel.text = [aService name];
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
		cell.imageView.image = [UIImage imageNamed:@"streaming.png"]; 
		cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
      return cell;
	}
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSNetService *aService = (NSNetService	*) [discoveredWebServices objectAtIndex: [indexPath row]];
	if (aService != NULL) {
		
		[aService setDelegate: self];
		[aService resolveWithTimeout:10];
	}
	
	
	/*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
  //  detailViewController.detailItem = [NSString stringWithFormat:@"Row %d", indexPath.row];
}


#pragma mark WebServiceCommunication

// This will issue a request to a web service API via HTTP GET to the URL specified by urlString.
// It will return the JSON string returned from the HTTP GET.
- (void)jsonFromURLString:(NSString*)thisUrl forId:(NSString*)thisId  {
	
	NSString *urlWithId = [[NSString alloc] 
						   initWithFormat: @"%@%@",
						   thisUrl,
						   thisId];
	
	
	
	NSURL *url = [NSURL URLWithString:urlWithId];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"GET"];
	
	responseData = [[NSMutableData data] retain];
	
	NSURLConnection  *connection   = [[NSURLConnection alloc]
									  initWithRequest:request delegate:self];
	
}	

// This shows the error to the user in an alert.
- (void)handleError:(NSError *)error {
	if (error != nil) {
		UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[errorAlertView show];
		[errorAlertView release];
	}  
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[self handleError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	NSString *theString = [[NSString alloc] initWithData:responseData
												encoding:NSASCIIStringEncoding];
	
	
   //detailViewController.detailItem = [NSString stringWithString:urlString];	
	ContentsViewController *cdDirectory = [[ContentsViewController alloc] initWithNibName:@"ContentsView" bundle:nil] ;
	
	
	
	[cdDirectory initWithJson:theString	forDomain:urlString];
	
	cdDirectory.hidesBottomBarWhenPushed = YES;
	
	[self.navigationController pushViewController:cdDirectory animated:YES];
	
	
	[cdDirectory release];
	
	
 }



	


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [detailViewController release];
	[bonjourBrowser release];
	[discoveredWebServices release];

    [super dealloc];
}


@end

