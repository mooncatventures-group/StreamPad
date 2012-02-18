/*
 SDL - Simple DirectMedia Layer
 Copyright (C) 1997-2009 Sam Lantinga
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 Sam Lantinga
 slouken@libsdl.org
*/

#import "SDL_uikitappdelegate.h"
#import "SDL_uikitopenglview.h"
#import "SDL_events_c.h"
#import "SDLviewController.h"
#import "NeutralViewController.h"
#import "SDLArtViewController.h"
#import "SongsViewController.h"
#import "jumphack.h"
#import "BookmarkViewController.h"
#import "RootViewController.h"
#import "DetailViewController.h"



#ifdef main
#undef main
#endif
UIWindow *nativeWindow;
extern int SDL_main(int argc, char *argv[]);
static int forward_argc;
static char **forward_argv;




int main(int argc, char **argv) {

	int i;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	/* store arguments */
	forward_argc = argc;
	forward_argv = (char **)malloc(argc * sizeof(char *));
	for (i=0; i<argc; i++) {
		forward_argv[i] = malloc( (strlen(argv[i])+1) * sizeof(char));
		strcpy(forward_argv[i], argv[i]);
	}

	/* Give over control to run loop, SDLUIKitDelegate will handle most things from here */
	UIApplicationMain(argc, argv, NULL, @"SDLUIKitDelegate");
	
	[pool release];
	
}

@implementation SDLUIKitDelegate

@synthesize splitViewController, rootViewController, detailViewController;
@synthesize window;
@synthesize myWindow;
@synthesize navigationController;
@synthesize tabBarController;
@synthesize glInit;
@synthesize bookmarkSplitViewController;


/* convenience method */
+(SDLUIKitDelegate *)sharedAppDelegate {
	/* the delegate is set in UIApplicationMain(), which is garaunteed to be called before this method */
	return (SDLUIKitDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)init {
	self = [super init];
	
	window = nil;
	return self;
}


- (void)postFinishLaunch:(NSDictionary*)parms {

    NSLog(@"ready to launch");
	
	
	
	NSString *videoPath = [parms objectForKey:@"url"];
	NSLog(@"video path %@\n",  videoPath);
	const char *cString = [videoPath UTF8String];
	//const char *myString = cString;
	printf("the printf value is %s\n ", cString);

	
	//NSString *glflag = [parms objectForKey:@"glflag"];
	//NSLog(@"post finish url  %@",filename);
	//NSLog(@"post finish url  %@",glflag);
	/* run the user's application, passing argc and argv */
	forward_argc=1;
	
	
	forward_argv[1] = "-fs";
	forward_argv[2] = "-skipframe";
	forward_argv[3] = "30";
	forward_argv[4] = "-fast";
	forward_argv[5] = "-sync";
	forward_argv[6] = "video";
	forward_argv[7] = "-drp";
	forward_argv[8] = "-skipidct";
	forward_argv[9] = "10";
	forward_argv[10] = "-skiploop";
	forward_argv[11] = "50";
	forward_argv[12] = "-threads";
	forward_argv[13] = "5";
	//argv[14] = "-an";
	forward_argv[14] = cString;
	
	NSLog(@"glflag %@\n ",[parms objectForKey:@"glflag"] );
	if ([parms objectForKey:@"glflag"]!=@"1") {
	   forward_argv[15]="0";
	}else {
	forward_argv[15]="1";
	}
	

	forward_argc += 15;
	
	
	int exit_status = SDL_main(forward_argc, forward_argv);
	
	/* free the memory we used to hold copies of argc and argv */
	int i;
	for (i=0; i<forward_argc; i++) {
		free(forward_argv[i]);
	}
	free(forward_argv);	
		
	/* exit, passing the return status from the user's application */
	exit(exit_status);
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch  
	
	myWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; 
	glInit=@"0";
	
 
    
    UINavigationController *localNavigationController;
	
	NSManagedObjectContext *context = [self managedObjectContext];
	if (!context) {
		// Handle the error.
	}
			
	// create tab bar controller and array to hold the view controllers
	tabBarController = [[UITabBarController alloc] init];

	splitViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Network" image:[UIImage imageNamed:@"streaming.png"] tag:0] autorelease];
	
//	bookmarkViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Bookmark" image:[UIImage imageNamed:@"bookmark.png"] tag:1] autorelease];
	
	BookmarkViewController  *bookmarkViewController = [[BookmarkViewController alloc] initWithTabBar];
	bookmarkViewController.managedObjectContext = context;

	
    localNavigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkViewController];
		
	NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:6];

   	[localControllersArray addObject:splitViewController];
	[splitViewController release];
	
	localNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Bookmark" image:[UIImage imageNamed:@"bookmark.png"] tag:1] autorelease];
		
	[localControllersArray addObject:localNavigationController];
    [localNavigationController release];
		[bookmarkViewController release];

	
	// load up our tab bar controller with the view controllers
	tabBarController.viewControllers = localControllersArray;
	
	// release the array because the tab bar controller now has it
	[localControllersArray release];
	
	
	// add the tabBarController as a subview in the window
	[window addSubview:tabBarController.view];
	
		
	// Add the split view controller's view to the window and display.
	
   // [window addSubview:splitViewController.view];
	myWindow = window;
    //[window makeKeyAndVisible];
	  [myWindow makeKeyAndVisible];
	/* Set working directory to resource path */
	[[NSFileManager defaultManager] changeCurrentDirectoryPath: [[NSBundle mainBundle] resourcePath]];

    
    return YES;
}




/*
- (void)applicationDidFinishLaunching:(UIApplication *)application {
			
	
	myWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; 
	glInit=@"0";
	
	UINavigationController *localNavigationController;
	
	// set up the window
		
	// create tab bar controller and array to hold the view controllers
	tabBarController = [[UITabBarController alloc] init];
	NSMutableArray *localControllersArray = [[NSMutableArray alloc] initWithCapacity:6];
	
	
		
	
	SongsViewController *songViewController;
    songViewController = [[SongsViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:songViewController];
	[localControllersArray addObject:localNavigationController];
	[localNavigationController release];
	[songViewController release];
	
	
	NeutralViewController *neutralViewController;
    neutralViewController = [[NeutralViewController alloc] initWithTabBar];
	localNavigationController = [[UINavigationController alloc] initWithRootViewController:neutralViewController];
	[localControllersArray addObject:localNavigationController];
	[localNavigationController release];
	[neutralViewController release];
	
		
	
	
	
	// load up our tab bar controller with the view controllers
	tabBarController.viewControllers = localControllersArray;
	
	// release the array because the tab bar controller now has it
	[localControllersArray release];
	
	
	// add the tabBarController as a subview in the window
		[myWindow addSubview:tabBarController.view];
		
	//	[window addSubview:[navigationController view]];
	[myWindow makeKeyAndVisible];
	//uikitWindowToFront(myWindow);
	
		[[NSFileManager defaultManager] changeCurrentDirectoryPath: [[NSBundle mainBundle] resourcePath]];
//	NSLog(@"selector runs here");
//	[self performSelector:@selector(postFinishLaunch) withObject:nil
//afterDelay:0.0];
}
*/

- (void) postProcessing:(NSDictionary*)parms {
	
	[self performSelector:@selector(postFinishLaunch:) withObject:parms
			   afterDelay:0.0];
	
	
}

-(void) switchTopWindow {
	NSLog(@"making uiwindw key window");
	[myWindow makeKeyAndVisible];
	SDLUIKitDelegate *appDelegate = [SDLUIKitDelegate sharedAppDelegate];
	[appDelegate.detailViewController reInitWeb];

}


-(void)quitSdl {
	SDL_SendQuit();
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	SDL_SendQuit();
	 /* hack to prevent automatic termination.  See SDL_uikitevents.m for details */
	longjmp(*(jump_env()), 1);
	
}

- (void) applicationWillResignActive:(UIApplication*)application
{
//	NSLog(@"%@", NSStringFromSelector(_cmd));
	//SDL_SendWindowEvent(self.window, SDL_WINDOWEVENT_MINIMIZED, 0, 0);
}

- (void) applicationDidBecomeActive:(UIApplication*)application
{
//	NSLog(@"%@", NSStringFromSelector(_cmd));
	//SDL_SendWindowEvent(self.window, SDL_WINDOWEVENT_RESTORED, 0, 0);
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Stream.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
		// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Stream" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }    
	
    return persistentStoreCoordinator;
}



#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}






-(void)dealloc {
	[splitViewController release];
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[window release];
	[super dealloc];
}

@end
