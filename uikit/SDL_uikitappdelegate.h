/*
    SDL - Simple DirectMedia Layer
    Copyright (C) 1997-2010 Sam Lantinga

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

#import <UIKit/UIKit.h>
#import "SDL_uikitopenglview.h"
#import <CoreData/CoreData.h>
@class RootViewController;
@class DetailViewController;

/* *INDENT-OFF* */
@interface SDLUIKitDelegate:NSObject<UIApplicationDelegate> {
	UIWindow *window;
	UIWindow *myWindow;
	UITabBarController *tabBarController;
	UINavigationController *navigationController;
	NSString *glInit;
	UISplitViewController *splitViewController;
	UISplitViewController *bookmarkSplitViewController;

	RootViewController *rootViewController;
	DetailViewController *detailViewController;
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	

}


@property (readwrite, retain) UIWindow *window;
@property (readwrite, retain) UIWindow  *myWindow;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *glInit;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet UISplitViewController *bookmarkSplitViewController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (NSString *)applicationDocumentsDirectory;
- (void)postFinishLaunch:(NSDictionary*)parms;
-(void)postProcessing:(NSDictionary*) parms;
-(void) quitSdl;
-(void) switchTopWindow;

+(SDLUIKitDelegate *)sharedAppDelegate;

@end
/* *INDENT-ON* */
