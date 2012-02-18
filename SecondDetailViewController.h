
 
 

#import <UIKit/UIKit.h>
#import "SongsViewController.h"
#import "Book.h"
#import "SDL_uikitappdelegate.h"
#import <MediaPlayer/MediaPlayer.h>




@interface SecondDetailViewController : UIViewController {
    
    UINavigationBar *navigationBar;
	NSString *url;
	NSString *dcTitle;
	UITableView *tableView;
	Book *book;
	UIImageView *imageView;
	MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) Book	*book;
@property (readwrite, retain) MPMoviePlayerController *moviePlayer;
//@property (nonatomic,retain)   IBOutlet UIImageView *imageView;


- (void)setUrl:(NSString*)urlString;
- (void)setDcTitle:(NSString*)titleString;
- (void)setDcArt:(NSString*)imageString;
- (void)playMovie:(NSString*)movieURL;
- (void)playCustom:(NSString*)movieURL;
- (void)playIntro:(NSString*)movieString;

@end
