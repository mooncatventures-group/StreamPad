
#import <UIKit/UIKit.h>


//@class SongDetailsController;
@class SecondDetailViewController;

@interface SongsViewController : UIViewController {
@private
  //  SongDetailsController *detailController;
//	NSManagedObjectContext *managedObjectContext;
    UITableView *tableView;
	NSMutableData *responseData;
	NSString *urlString;
    UISegmentedControl *fetchSectioningControl;
	SecondDetailViewController *detailViewController;

}

//@property (nonatomic, retain, readonly) SongDetailsController *detailController;
//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *fetchSectioningControl;- (void)jsonFromURLString:(NSString*)str forId:(NSString*)thisId; 
@property (nonatomic, retain) IBOutlet SecondDetailViewController *detailViewController;

-(id)initWithTabBar;
- (IBAction)changeFetchSectioning:(id)sender;
- (void)jsonFromURLString:(NSString*)str forId:(NSString*)thisId; 

@end
