 
 
#import "EditingViewController.h"
@class Book;
@class NTToolbarController;


@interface DetailAddViewController : UITableViewController <UIActionSheetDelegate,UIPopoverControllerDelegate> {
    Book *book;
	NSDateFormatter *dateFormatter;
	NSUndoManager *undoManager;
	IBOutlet UIButton *button;
	UIPopoverController *popoverController;
	EditingViewController *editingViewController;
	UIToolbar *theToolbar;
    UIWebView *webView;

}

@property (nonatomic, retain) Book *book;

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSUndoManager *undoManager;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *theToolbar; 
@property(nonatomic,retain)UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet EditingViewController *editingViewController;
-(IBAction)someAction:(id)sender;
-(IBAction)pop:(id)sender;
- (void)setUpUndoManager;
- (void)cleanUpUndoManager;
- (void)updateRightBarButtonItemState;
- (void)playMovie:(NSString*)movieURL;
- (IBAction)showPopoverEdit:(UIViewController*)content;
- (void)editItemSelected:(int)index;



@end

