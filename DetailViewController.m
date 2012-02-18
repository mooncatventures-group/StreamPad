//
//  DetailViewController.m
//  SDLUIKitDelegate
//
//  Created by Michelle on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>




@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel,tableView,parentView,imageView,appURLButton;
@synthesize mpScrollView,moviePlayer;


#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSDictionary *)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}
- (void)setUrl:(NSString*)urlString 
{
	url = urlString;
}


- (void)configureView {
	
	url = [self.detailItem objectForKey:@"url"];
    if (url !=nil) {
	[  self initWeb:self.detailItem];  
	}else {
	   url = 
      [NSString stringWithFormat:@"http://www.apple.com"];
     //self.detailItem];
    [webView loadRequest:
     [NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	}
	
  }

-(id) initWithTabBar {
	if ([self init]) {
		//this is the label on the tab button itself
		self.title = @"Rectangles";
		
		//use whatever image you want and add it to your project
		self.tabBarItem.image = [UIImage imageNamed:@"Cloud.png"];
		
		// set the long name shown in the navigation bar
		self.navigationItem.title=@"Rectangles";
	}
	return self;
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}

- (IBAction)playCustom:(id)sender
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

-(void) reInitWeb {
	
	//[webView loadHTMLString:nil baseURL:nil];
//	url = 
//	[NSString stringWithFormat:@"http://www.apple.com"];
	//self.detailItem];
 //   [webView loadRequest:
 //    [NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	
	
}

							  
- (void)initWeb:(NSDictionary*) art {
	/*
	
	if ([art objectForKey:@"art"]!=@"none") {
		NSURL *sURL = [NSURL URLWithString:[art objectForKey:@"art"]];
		NSData *sData = [NSData dataWithContentsOfURL:sURL];
		UIImage *image = [[UIImage alloc] initWithData:sData];
		CGRect rect = CGRectMake(0.0, 0.0, 80, 80);
		UIGraphicsBeginImageContext(rect.size);
		[image drawInRect:rect];
		self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
		//cell.detailTextLabel.text = src;
		UIGraphicsEndImageContext();
	}else {
		self.imageView.image = [UIImage imageNamed:@"Upcoming.png"];
		
	}
	
	*/
		
	
	
	NSMutableString *html = [[NSMutableString alloc]initWithString: @"<p style=\"font-weight:bold\">title</p>" 
								  "<p>description</p>"
								  "<p>media</p>"];
	
	url = [art objectForKey:@"url"];
	NSLog(@"this is the url object %@ ",url);
	
	if([url hasSuffix:@".mpeg"]==YES || [url hasSuffix:@".avi"]==YES || [url hasSuffix:@"AVI"]==YES || 
	   [url hasSuffix:@"MPG"]==YES || [url hasSuffix:@"mpg"] == YES){
		//self.appURLButton.hidden=NO;
		[html replaceOccurrencesOfString: @"media" withString:@" "
								 options: NSLiteralSearch range: NSMakeRange(0, [html length])];
		//[self playCustom:url];

	} else {
		
	//	self.appURLButton.hidden=YES;
	
	 if ([art objectForKey:@"url"]!=nil) {
		[html replaceOccurrencesOfString: @"media" withString:@"<video class='video' src='mp4'   width='640' height='480'  controls='true'  autobuffer='true'></video>"
								 options: NSLiteralSearch range: NSMakeRange(0, [html length])];
	
		}		
	}
		
		
	
	if ([art objectForKey:@"url"]!=nil) {
	[html replaceOccurrencesOfString: @"mp4" withString:[art objectForKey:@"url"]
							 options: NSLiteralSearch range: NSMakeRange(0, [html length])];
	}
	
	
    if ([art objectForKey:@"title"]!=nil) {

	[html replaceOccurrencesOfString: @"title" withString:[art objectForKey:@"title"]
							 options: NSLiteralSearch range: NSMakeRange(0, [html length])];
	}
	
	if ([art objectForKey:@"description"]!=nil) {

    
	 [html replaceOccurrencesOfString: @"description" withString:[art objectForKey:@"description"]
							 options: NSLiteralSearch range: NSMakeRange(0, [html length])];
	}
	
	
	
	NSLog(@"init web %@ ",html);
		[webView loadHTMLString:html baseURL:nil];
	
	
	
}


int p = 0;
int ll=0;
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
		mp.controlStyle = MPMovieControlStyleNone;
		//mp.useApplicationAudioSession = NO;
		
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(movieDidFinishPlayback:)
		 name:MPMoviePlayerPlaybackDidFinishNotification
		 object:self.moviePlayer
		 ];
		
		
		//int width = 128;
		//int height = 128;
		//float newwidth = 75 * ((float)width / (float)height);
		
		
		self.mpScrollView.contentSize = CGSizeMake(100, 100);
		
		UIView *imgv = [[UIView alloc] init];
		[imgv setUserInteractionEnabled:YES];
		
		[imgv setFrame:CGRectMake(ll, 0, 100.0f, 100.0f)];
		ll+=100.0f + 2;
		
		
		
		[imgv addSubview:mp.view];
			mp.view.frame = imgv.bounds;
		// make sure the movie resizes when the parentView adjusts (due to rotation)
		mp.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self.mpScrollView addSubview:imgv];
		
		
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
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    if ([items count]>0) {	
  	[items removeObjectAtIndex:0];
	}
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self configureView];
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





- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [detailDescriptionLabel release];
    [super dealloc];
}

@end
