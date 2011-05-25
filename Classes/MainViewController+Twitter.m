//
//  MainViewController+Twitter.m
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "MainViewController+Twitter.h"
#import "NSString+Search.h"
#import "DeineMuddaAppDelegate.h"

@implementation MainViewController (Twitter)

- (void) shareOverTwitter
{
	if (twitterEngine)
	{	
		[self sendTwitterUpdate];
		return;
	}
	
	twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	[twitterEngine setConsumerKey: @"NZymIl7mzjMMH3uHpTlY2Q"];
	[twitterEngine setConsumerSecret: @"9mUyRVYGdq7welai5dEFVXdlH8uDMeTyiGE4ZeWmvo"];
	
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: twitterEngine delegate: self];
	if (controller) 
	{
		[self presentModalViewController: controller animated: YES];
	}
	else 
	{
		[self sendTwitterUpdate];
	}
}

- (void) sendTwitterUpdate
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
	
	NSLog(@"sending twitter update!");
	[twitterEngine sendUpdate: [[self currentJoke] jokeText]];
	
	if ([[[self currentJoke] jokeText] containsString: @"A-Team" ignoringCase: YES])
	{
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
		[defs setBool: YES forKey: @"ateam_twitter"];
		[defs synchronize];
	}
}

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username 
{
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"twitterAuthData"];
	[defaults synchronize];
}

- (void) removeSavedTwitterAuthData
{
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey: @"twitterAuthData"];
	[defaults synchronize];
	[twitterEngine release];
	twitterEngine = nil;
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username 
{
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"twitterAuthData"];
}


#pragma mark SA_OAuthTwitterControllerDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
	NSLog(@"Authenicated for %@", username);
	
	[self sendTwitterUpdate];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller 
{
	NSLog(@"Authentication Failed!");
	[twitterEngine release], twitterEngine = nil;
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller 
{
	NSLog(@"Authentication Canceled.");
	[twitterEngine release], twitterEngine = nil;
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier 
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSInteger num = [defs integerForKey: @"tweetsSent"];
	num++;
	[defs setInteger: num forKey: @"tweetsSent"];
	[defs synchronize];
	
	
	NSLog(@"Request %@ succeeded", requestIdentifier);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Twitter",nil) 
													message:NSLocalizedString(@"Update erfolgreich gesendet!",nil)
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release]; 
	
	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del currentUnlockLevel]; //trigger any achievement changes!

}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error 
{
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
	if ([[error localizedDescription] containsString: @"401" ignoringCase: YES])
	{
		[self removeSavedTwitterAuthData];
		[self shareOverTwitter];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Twitter",nil) 
														message:[NSString stringWithFormat: NSLocalizedString(@"Update fehlgeschlagen: %@",nil), [error localizedDescription]]
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles: nil];
		[alert show];
		[alert release]; 
		
	}
}


@end
