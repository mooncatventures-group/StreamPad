#import "SongsViewController.h"
//#import "SongDetailsController.h"
#import "ContentsViewController.h"
#import "CJSONDeserializer.h"
#import "CdDetailViewController.h"
#import "SecondDetailViewController.h"
#import "DetailViewController.h"


@implementation ContentsViewController

@synthesize tableView , fetchSectioningControl;
@synthesize url,urlWithId;
@synthesize detailViewController;
@synthesize rootViewController;


- (void)viewDidLoad {
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	tableView.rowHeight = 100;
	fetchSectioningControl.hidden = YES;
	}




- (void)viewDidUnload {
    [super viewDidUnload];
   
}




// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
	
	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		self.tableView.rowHeight = 100;
		return 1 ;
	}
	
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	tableView.rowHeight = 50.0;
	return [items count];
}


- (IBAction)changeFetchSectioning:(id)sender {
}	

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section { 
		return [NSString stringWithFormat:@"found - %d items", [items count]];
    }
	
	
	
	
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
			
			static NSString *CellIdentifier = @"Cell";

			UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

			}
			
			// Set up the cell
			cell.textLabel.text = [items objectAtIndex:indexPath.row];
	        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];

			
	       
	       if ([albumArt objectAtIndex:indexPath.row]!=@"none") {
			   NSURL *sURL = [NSURL URLWithString:[albumArt objectAtIndex:indexPath.row]];
			   NSData *sData = [NSData dataWithContentsOfURL:sURL];
			   UIImage *image = [[UIImage alloc] initWithData:sData];
			   CGRect rect = CGRectMake(0.0, 0.0, 100, 100);
			   UIGraphicsBeginImageContext(rect.size);
			   [image drawInRect:rect];
			   cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
			   //cell.detailTextLabel.text = src;
			   UIGraphicsEndImageContext();
	       }else {
		    cell.imageView.image = [UIImage imageNamed:@"Upcoming.png"];
			   
		   }
			cell.detailTextLabel.text  = [NSString stringWithFormat:@"media"];
			[cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0]];
			[cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
			[cell.detailTextLabel setHighlightedTextColor:[UIColor whiteColor]];
			//[cell.textLabel setFont:[UIFont systemFontOfSize:10.0]];	
			//[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
			[cell.textLabel setTextColor:[UIColor blackColor]];
			[cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];

			cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
			
			
			return cell;
			
	}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *thisKey = [keys objectAtIndex:indexPath.row];
	NSString *thisRes = [res objectAtIndex:indexPath.row];
	NSString *thisItem = [items objectAtIndex:indexPath.row];
	NSString *thisArt = [albumArt objectAtIndex:indexPath.row];
	NSString *thisDesc =[itemDescription objectAtIndex:indexPath.row];
	
	
	NSLog(@"this key");
	NSLog(url);
	
	NSLog(@"title");
	NSLog(thisItem);
	
	NSLog(@"res");
	NSLog(thisRes);
	
	
	
		
	if (thisRes!=@"none") {
		NSLog(@"foundone");
		if([thisRes hasSuffix:@".mpeg"]==YES || [thisRes hasSuffix:@".avi"]==YES || [thisRes hasSuffix:@"AVI"]==YES || 
		   [thisRes hasSuffix:@"MPG"]==YES || [thisRes hasSuffix:@"mpg"] == YES){
			SecondDetailViewController *currentController = [[SecondDetailViewController alloc] init];
			
			
			
			NSMutableDictionary *appRecord = [[NSMutableDictionary alloc] init];
			[appRecord setObject: thisRes forKey: @"url"];
			[appRecord setObject: thisArt forKey: @"art" ];
			[appRecord setObject: thisItem forKey: @"title"];
			[appRecord setObject: thisDesc forKey: @"description"];
			SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
		//	appDelegate.detailViewController.detailItem =
		//	appRecord;
			
			[currentController setUrl:thisRes];
		    [currentController setDcTitle:thisItem];
			currentController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:currentController animated:YES];
				[currentController release];
			
			
		}else {
	
		NSMutableDictionary *appRecord = [[NSMutableDictionary alloc] init];
		[appRecord setObject: thisRes forKey: @"url"];
		[appRecord setObject: thisArt forKey: @"art" ];
		[appRecord setObject: thisItem forKey: @"title"];
		[appRecord setObject: thisDesc forKey: @"description"];
		SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
		appDelegate.detailViewController.detailItem =
		appRecord;
		}
	}
	    
		
		if(thisRes==@"none") {
		[self jsonFromURLString:url forId:thisKey];
		}
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	 SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	 [appDelegate.detailViewController reInitWeb];
	 

}



// This shows the error to the user in an alert.
- (void)handleError:(NSError *)error {
	if (error != nil) {
		UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[errorAlertView show];
		[errorAlertView release];
	}  
	
}

- (NSString*) initWithJson:(NSString*)dataString forDomain:(NSString*)domain  {
	
	
	items = [[NSMutableArray alloc] init];
	keys = [[NSMutableArray alloc] init];
	classes = [[NSMutableArray alloc] init];
	res = [[NSMutableArray alloc] init];
	albumArt = [[NSMutableArray alloc] init];
	itemDescription = [[NSMutableArray alloc] init];
	url = domain;
	
	NSData *jsonData = [dataString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	
	// Parse JSON results with TouchJSON.  It converts it into a dictionary.
	CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	NSError *error = nil;
	NSDictionary *resultsDictionary = [jsonDeserializer deserializeAsDictionary:jsonData error:nil];
	[self handleError:error];
	
	// Clear out the old tweets from the previous search
	[items removeAllObjects];
	[keys removeAllObjects];
	[classes removeAllObjects];
	[res removeAllObjects];
	[albumArt removeAllObjects];
	[itemDescription removeAllObjects];

	
	
    NSInteger *count=0;
	NSArray *cdObjectsArray = [resultsDictionary objectForKey:@"results"];
	for (NSDictionary *cdObjectsDictionary in cdObjectsArray) {
		NSString *itemTitle = [cdObjectsDictionary objectForKey:@"dctitle"];
		NSString *itemKey = [cdObjectsDictionary objectForKey:@"id"];
		NSString *itemClass = [cdObjectsDictionary objectForKey:@"upnpclass"];
		NSString *itemRes = [cdObjectsDictionary objectForKey:@"res"];
		NSString *artUri = [cdObjectsDictionary objectForKey:@"upnpalbumArtURI"];
		NSString *tvsUri = [cdObjectsDictionary objectForKey:@"upnpicon"];
		NSString *itemDesc = [cdObjectsDictionary objectForKey:@"upnplongDescription"];
				NSLog(itemRes);
		NSLog(@"albumart %@ ", artUri);
		NSLog(@"albumicon %@ ", tvsUri);
		
		
		[items addObject:itemTitle];
		[keys  addObject:itemKey];
		[classes  addObject:itemClass];
		if (itemRes !=nil) {
			[res  addObject:itemRes];
		}else {
			[res  addObject:@"none"];
		}
		
		if (artUri !=nil || artUri !=NULL) {
			[albumArt addObject:artUri];
		}else {
			if (tvsUri !=nil || tvsUri !=NULL) {
		    [albumArt addObject:tvsUri];
			} else {
		
			[albumArt addObject:@"none"];
			}
		}
		
		if (itemDesc !=nil && itemDesc !=NULL ) {
			[itemDescription addObject:itemDesc];
		}else{
			[itemDescription addObject:@"Description not available"];
		}
		
		
	}
	
	if ([items count]==0) {
		[items addObject:@"No Content"];
		[keys addObject:@""];
		[classes addObject:@"object.item.Empty"];
		[albumArt addObject:@"none"];
		[itemDescription addObject:@"Description not available"];
	}
	
	
	// refresh table view
	[tableView reloadData];
	return [classes objectAtIndex:0];
	
}

#pragma mark WebServiceCommunication

// This will issue a request to a web service API via HTTP GET to the URL specified by urlString.
// It will return the JSON string returned from the HTTP GET.
- (void)jsonFromURLString:(NSString*)thisUrl forId:(NSString*)thisId  {
	
	urlWithId = [[NSString alloc] 
				 initWithFormat: @"%@%@",
				 thisUrl,
				 thisId];
	
	
	
	
	NSURL *aurl = [NSURL URLWithString:urlWithId];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:aurl];
	[request setHTTPMethod:@"GET"];
	
	responseData = [[NSMutableData data] retain];
	
	NSURLConnection  *connection   = [[NSURLConnection alloc]
									  initWithRequest:request delegate:self];
	
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
	
	
	
   	
	ContentsViewController *dsController = [[ContentsViewController alloc] initWithNibName:@"ContentsView" bundle:nil];
	
	
	NSString *aString = [dsController initWithJson:theString	forDomain:url];
	NSLog(@"url is");
	//NSLog(urlWithId);
	//	NSLog(theString);
	//NSLog(aString);
	
	dsController.hidesBottomBarWhenPushed = YES;

	
	
	[self.navigationController pushViewController:dsController animated:YES];
		[dsController release];
	
	
	
	
	
	
}

	
	- (void)dealloc {
		
		[super dealloc];
	}
	
	
@end
