
#import <UIKit/UIKit.h>
@class DetailViewController;
@class RootViewController;


@interface ContentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *tableView;
	IBOutlet UITableView *entityTableView;
	NSMutableData *responseData;
	NSString *urlString;
    UISegmentedControl *fetchSectioningControl;
	NSMutableArray *items;
	NSMutableArray *keys;
	NSMutableArray *res;
	NSMutableArray *classes;
	NSMutableArray *albumArt;
	NSMutableArray *itemDescription;
	NSString *url;
	NSString *urlWithId;
	DetailViewController *detailViewController;
	RootViewController  *rootViewController;

}


@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet UITableView *entityTableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *fetchSectioningControl;
- (void)jsonFromURLString:(NSString*)str forId:(NSString*)thisId;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *urlWithId;
- (NSString*) initWithJson:(NSString*)dataString forDomain:(NSString*)domain;
- (void)jsonFromURLString:(NSString*)thisUrl forId:(NSString*)thisId;
- (IBAction)changeFetchSectioning:(id)sender;



@end
