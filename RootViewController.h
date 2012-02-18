//
//  RootViewController.h
//  SDLUIKitDelegate
//
//  Created by Michelle on 4/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	NSMutableData *responseData;
	NSString *urlString;

}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

- (void)jsonFromURLString:(NSString*)str forId:(NSString*)thisId; 
@end
