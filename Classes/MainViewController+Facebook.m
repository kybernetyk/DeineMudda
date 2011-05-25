//
//  MainViewController+Facebook.m
//  DeineMudda
//
//  Created by jrk on 20/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "MainViewController+Facebook.h"
#import "FBConnect.h"
#import "NSString+Search.h"
#import "DeineMuddaAppDelegate.h"

@implementation MainViewController (Facebook)

#pragma mark -
#pragma mark farmville
- (void) shareOverFarmville
{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	if (!facebook)
	{
		facebook = [[Facebook alloc] init];
		NSArray *perms = [NSArray arrayWithObjects:@"publish_stream",@"offline_access", nil];
		[facebook authorize: @"0309d2674cd5b55e9fb0d7fbc52357ff" permissions: perms delegate: self];
		return;
	}
	[self share2];
}

- (void)fbDidLogin
{
	NSLog(@"fb login");
	[self share2];	
}

/**
 * Called when the user dismiss the dialog without login
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	NSLog(@"fb nologin");
	[facebook release];
	facebook = nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

/**
 * Called when the user is logged out
 */
- (void)fbDidLogout
{
	NSLog(@"fb logout");
	[facebook release];
	facebook = nil;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}


- (void) share2
{
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
								   @"0309d2674cd5b55e9fb0d7fbc52357ff", @"api_key",
								   [self facebookMessage] , @"message",
								   nil];
		
	NSString *action_links = @"[{\"text\":\"Deine Mudda iPhone App\",\"href\":\"http://itunes.apple.com/\"}]";
    [params setObject:action_links forKey:@"action_links"];

	[facebook requestWithMethodName: @"stream.publish" andParams: params andHttpMethod: @"POST" andDelegate: self];
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog(@"FB REQ DID FAIL: %@", [error localizedDescription]);
	[facebook release];
	facebook = nil;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
}

/**
 * Called when a request returns and its response has been parsed into an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result
{
	NSLog(@"FB REQ SUCCESS: %@", [[[NSString alloc] initWithData: result encoding: NSUTF8StringEncoding] autorelease]);
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSInteger num = [defs integerForKey: @"facebookSent"];
	num++;
	[defs setInteger: num forKey: @"facebookSent"];
	[defs synchronize];
	
	if ([[[self currentJoke] jokeText] containsString: @"A-Team" ignoringCase: YES])
	{
		[defs setBool: YES forKey: @"ateam_facebook"];
		[defs synchronize];
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Facebook",nil) 
													message:NSLocalizedString(@"Update erfolgreich gesendet!",nil)
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release]; 
	
	
	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del currentUnlockLevel]; //trigger any achievement changes!
	
	NSLog(@"ur penis! %@", [[self currentJoke] jokeText]);
}


/*- (void)dialogDidComplete:(FBDialog *)dialog
{
	NSLog(@"dialog completed!");	
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSInteger num = [defs integerForKey: @"facebookSent"];
	num++;
	[defs setInteger: num forKey: @"facebookSent"];
	[defs synchronize];

	if ([[[self currentJoke] jokeText] containsString: @"A-Team" ignoringCase: YES])
	{
		[defs setBool: YES forKey: @"ateam_facebook"];
		[defs synchronize];
	}
	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del currentUnlockLevel]; //trigger any achievement changes!

	
}*/

- (void) fbDialogLogin:(NSString *) token expirationDate:(NSDate *) expirationDate
{
	NSLog(@"token: %@",token);
}

- (void) fbDialogNotLogin:(BOOL) cancelled
{
	NSLog(@"cancel!");
}





@end
