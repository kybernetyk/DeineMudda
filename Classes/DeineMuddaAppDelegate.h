//
//  DeineMuddaAppDelegate.h
//  DeineMudda
//
//  Created by jrk on 16/9/10.
//  Copyright flux forge 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainViewController.h"

@interface DeineMuddaAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;


	MainViewController *mainViewController;
	
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

- (NSInteger) currentUnlockLevel;
- (NSInteger) unlockedJokes;

@end

