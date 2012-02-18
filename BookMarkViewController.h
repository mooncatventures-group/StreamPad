

#import "AddViewController.h"
#import <CoreData/CoreData.h>

@interface BookmarkViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddViewControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;	    
    NSManagedObjectContext *addingManagedObjectContext;	    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
 -(id)initWithTabBar;
- (IBAction)addBook;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;



@end
