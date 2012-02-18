//
//  DetailViewController.h
//  SDLUIKitDelegate
//
//  Created by Michelle on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRecord.h"
#import "SDL_uikitappdelegate.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DetailViewController :UIViewController <UITableViewDataSource, UITableViewDelegate, UISplitViewControllerDelegate,UIWebViewDelegate> {
	UIPopoverController *popoverController;
    UIToolbar *toolbar;
    NSDictionary *detailItem;
    UILabel *detailDescriptionLabel;
	UITableView *tableView;
	UIView *parentView;
	UIImageView *imageView;
	UIScrollView *mpScrollView;
	IBOutlet UIWebView *webView;
	NSString *url;
	UIButton *appURLButton;
	MPMoviePlayerController *moviePlayer;

	
	
}
@property (nonatomic, retain) IBOutlet UIView *parentView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIScrollView *mpScrollView;
@property (nonatomic, retain) NSDictionary *detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIButton *appURLButton;
@property (readwrite, retain) MPMoviePlayerController *moviePlayer;
-(id) initWithTabBar;
- (void)initWeb:(NSDictionary*)art;
- (IBAction)playCustom:(id)sender;
- (void)setUrl:(NSString*)urlString;
-(void) reInitWeb;
- (void)playIntro:(NSString*)movieString;
-(void) insertMovieForScroll:(UIView*)view;







@end
