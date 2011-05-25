//
//  DeineMuddaAppDelegate.m
//  DeineMudda
//
//  Created by jrk on 16/9/10.
//  Copyright flux forge 2010. All rights reserved.
//

#import "DeineMuddaAppDelegate.h"
#import "FXiDataCore.h"
#import "FXDatabaseFactory.h"

@implementation DeineMuddaAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (void) registerUserDefaults
{
	NSDictionary *defs = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithBool: YES], @"Erfolge",
						  nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults: defs];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{   
	srand(time(NULL));
	[self registerUserDefaults];
	
	[FXDatabaseFactory createDatabase];
	
	
	mainViewController = [[MainViewController alloc] initWithNibName: @"MainViewController" bundle: nil];
	[window setRootViewController: mainViewController];
	
    // Override point for customization after application launch.
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application 
{
    NSError *error = nil;
    if (managedObjectContext_ != nil) {
        if ([managedObjectContext_ hasChanges] && ![managedObjectContext_ save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"DeineMudda" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"DeineMudda.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc 
{
	[window setRootViewController: nil];
    [mainViewController release], mainViewController = nil;
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [window release];
    [super dealloc];
}

- (NSInteger) unlockedJokes
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

	NSInteger ret = 379 - 300;
	
	if ([defs boolForKey: @"Gesichtsbuch"])
	{
		ret += 75;
	}
	if ([defs boolForKey: @"Alte Vogellady"])
	{
		ret += 50;
	}
	if ([defs boolForKey: @"Email Spammer #1"])
	{
		ret += 25;
	}
	if ([defs boolForKey: @"Richter und Henker"])
	{
		ret += 50;
	}
	if ([defs boolForKey: @"Treat Your Mother Right"])
	{
		ret += 100;
	}
	
	return ret;
}

- (NSInteger) currentUnlockLevel
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

	
	NSInteger tweets = [defs integerForKey: @"tweetsSent"];
	NSInteger mails = [defs integerForKey: @"mailsSent"];
	NSInteger facebooks = [defs integerForKey: @"facebookSent"];
	NSInteger rated = [defs integerForKey: @"jokesRated"];
	
	NSInteger unlockLevel = 0;

	NSString *unlockText = nil;
	BOOL notify = NO;
	
	if (tweets >= 20)
	{	
		unlockLevel ++;
		if (![defs boolForKey: @"Alte Vogellady"])
		{	
			notify = YES;
			unlockText = @"Alte Vogellady";
		}
		
		[defs setBool: YES forKey: @"Alte Vogellady"];
	}
	
	if (facebooks >= 20)
	{
		unlockLevel ++;
		if (![defs boolForKey: @"Gesichtsbuch"])
		{			
			notify = YES;
			unlockText = @"Gesichtsbuch";
		}

		[defs setBool: YES forKey: @"Gesichtsbuch"];
	}

	if (mails >= 10)
	{	
		unlockLevel ++;
		if (![defs boolForKey: @"Email Spammer #1"])
		{	
			notify = YES;
			unlockText = @"Email Spammer #1";
		}
		[defs setBool: YES forKey: @"Email Spammer #1"];
		
	}
	if (rated >= 50)
	{	
		unlockLevel ++;
		if (![defs boolForKey: @"Richter und Henker"])
		{	
			notify = YES;
			unlockText = @"Richter und Henker";
		}
		[defs setBool: YES forKey: @"Richter und Henker"];
	}

	if ([defs boolForKey: @"ateam_twitter"] &&
		[defs boolForKey: @"ateam_facebook"] &&
//		[defs boolForKey: @"ateam_mail"] &&
		[defs boolForKey: @"ateam_rated"])
	{	
		unlockLevel ++;
		if (![defs boolForKey: @"Treat Your Mother Right"])
		{	
			notify = YES;
			unlockText = @"Treat Your Mother Right";
		}
		[defs setBool: YES forKey: @"Treat Your Mother Right"];
	}
	[defs synchronize];
	
	
	if (notify)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName: @"AchievementUnlocked" object: unlockText];
	}
	
	if ([defs boolForKey: @"Gesichtsbuch"] &&
		[defs boolForKey: @"Alte Vogellady"] &&
		[defs boolForKey: @"Email Spammer #1"] &&
		[defs boolForKey: @"Richter und Henker"] &&
		[defs boolForKey: @"Treat Your Mother Right"])
	{
		[[NSNotificationCenter defaultCenter] postNotificationName: @"AchievementUnlocked" object: @"Alle Achievements O M G!"];
	}
	
	
	return unlockLevel;
}
@end

