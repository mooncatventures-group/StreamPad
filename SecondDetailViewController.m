

#import "SecondDetailViewController.h"
#import "SongsViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DetaiImageView.h"


@implementation SecondDetailViewController

@synthesize navigationBar;
@synthesize tableView;
@synthesize book;
@synthesize moviePlayer;


#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Add the popover button to the left navigation item.
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    // Remove the popover button.
    [navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tableView reloadData];
	[self becomeFirstResponder];
	NSLog(@"in view did load");
	}




- (void)viewWillAppear:(BOOL)animated {
    // Redisplay the data.
    [self.tableView reloadData];
	//[self updateRightBarButtonItemState];
	
}



- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
	
	/*
	 When editing starts, create and set an undo manager to track edits. Then register as an observer of undo manager change notifications, so that if an undo or redo operation is performed, the table view can be reloaded.
	 When editing ends, de-register from the notification center and remove the undo manager, and save the changes.
	 */
}


- (void)viewDidUnload {
	// Release any properties that are loaded in viewDidLoad or can be recreated lazily.
	}



#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 1 section
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 3 rows
	
	
	if (section==0) return 0;
	if (section==1) return 0;
	if (section==2) return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	if (indexPath.section==2) {
		switch (indexPath.row) {
				
				
			case 0: 
				cell.textLabel.text = @"Title";
				cell.detailTextLabel.text = dcTitle;
				break;
			case 1: 
				cell.textLabel.text = @"bookmark";
				cell.detailTextLabel.text = book.bookmark;
				break;
			case 2:
				cell.textLabel.text = @"url for Web";
				cell.detailTextLabel.text = url;
				//cell.textLabel.text = @"date";
				//cell.detailTextLabel.text = [self.dateFormatter stringFromDate:book.date];
				break;
			case 3:
				cell.textLabel.text = @"url";
				
				cell.detailTextLabel.text = url;
				break;
				
				
		}
	}
	
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return indexPath;
	
}

/**
 Manage row selection: If a row is selected, create a new editing view controller to edit the property associated with the selected row.
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"and now this one");
	NSLog(@"index path %d",indexPath.row);
	//if (!self.editing) {
	if (indexPath.row==2) {
		//button.hidden=NO;
						}else {
			if([url hasSuffix:@".mpeg"]==YES || [url hasSuffix:@".avi"]==YES || [url hasSuffix:@"AVI"]==YES ||  [url hasSuffix:@"MPG"]==YES || [url hasSuffix:@"mpg"] == YES){
			   // SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
				[self playIntro:url];

			}else{
				
				[self playMovie:url];
			}
			
		}
	
	
	
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}



#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)setUrl:(NSString*)urlString 
{
	url = urlString;
}

- (void)setDcTitle:(NSString*)titleString 
{
	dcTitle = titleString;
}

- (void)setDcArt:(NSString*)imageString 
{
}


-(void)playCustom:(NSString*)movieURL
{
	
	SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	NSString *glString = appDelegate.glInit;
	appDelegate.glInit =@"1";
	NSLog(@"pass stage 1");
	NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];
	[parms setObject: url forKey: @"url"];
	NSLog(@"set url");
    [parms setObject: glString forKey: @"glflag" ];
	NSLog(@"all objects set");
	[appDelegate postProcessing:parms];
	
}





- (void)playMovie:(NSString*)movieString

{
	
	// has the user entered a movie URL?
	NSURL *movieURL = [NSURL URLWithString:movieString];
	// Not using initWithContentURL because that starts fullscreen
	MPMoviePlayerController *mp =[[MPMoviePlayerController alloc] init];
	if (mp) {
		// save our movie controller object
		self.moviePlayer = mp;
		[mp release];
		// decide on our content
		mp.contentURL = movieURL;
		// autorepeat
		mp.repeatMode = MPMovieRepeatModeNone;
		//mp.useApplicationAudioSession = NO;
		
		
		// parentView is a view in the nib used simply to give a frame for the movie
		DetailImageView *parentView = [[DetailImageView alloc] initWithFrame:CGRectMake(40,50,260,180) andText:nil];
		[self.view addSubview:parentView];
		[parentView addSubview:mp.view];
		parentView.backgroundColor = [UIColor colorWithRed:197.0/255.0
													 green:204.0/255.0
													  blue:211.0/255.0
													 alpha:1.0];
		


		
		mp.view.frame = parentView.bounds;
		
		// make sure the movie resizes when the parentView adjusts (due to rotation)
		mp.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		
		// let's go...
		[mp play];
	}
	
	
}

- (void)playIntro:(NSString*)movieString

{
	
		NSBundle *bundle = [NSBundle mainBundle];
	NSString *moviePath = 
	[bundle 
	 pathForResource:@"fillermovie" 
	 ofType:@"m4v"];
	NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
	
		// Not using initWithContentURL because that starts fullscreen
	MPMoviePlayerController *mp =[[MPMoviePlayerController alloc] init];
	if (mp) {
		// save our movie controller object
		self.moviePlayer = mp;
		[mp release];
		// decide on our content
		mp.contentURL = movieURL;
		// autorepeat
		mp.repeatMode = MPMovieRepeatModeNone;
		//mp.useApplicationAudioSession = NO;
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(movieDidFinishPlayback:)
		 name:MPMoviePlayerPlaybackDidFinishNotification
		 object:self.moviePlayer
		 ];
		
		
		// parentView is a view in the nib used simply to give a frame for the movie
		DetailImageView *parentView = [[DetailImageView alloc] initWithFrame:CGRectMake(40,50,260,180) andText:nil];
		[self.view addSubview:parentView];
		[parentView addSubview:mp.view];
		parentView.backgroundColor = [UIColor colorWithRed:197.0/255.0
													 green:204.0/255.0
													  blue:211.0/255.0
													 alpha:1.0];
		
		
		
		mp.view.frame = parentView.bounds;
		// make sure the movie resizes when the parentView adjusts (due to rotation)
		mp.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		parentView.hidden = YES;
		
		// let's go...
		[mp play];
	}
	
	
}


- (void) movieDidFinishPlayback:(NSNotification*)notification
{
	NSLog(@"movie did finish");
	self.moviePlayer = [notification object];
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:moviePlayer
	 ];
	[moviePlayer stop];
	[self.moviePlayer stop];
	[self playCustom:url];
}








#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [navigationBar release];
    [super dealloc];
}	


@end
