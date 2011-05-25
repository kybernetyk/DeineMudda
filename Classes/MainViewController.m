//
//  MainViewController.m
//  DeineMudda
//
//  Created by jrk on 16/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "NSString+Search.h"
#import "MainViewController+Twitter.h"
#import "MainViewController+iAd.h"
#import "AchievementsViewController.h"
#import <MessageUI/MessageUI.h>
#import "MainViewController+Facebook.h"
#import "FXiDataCore.h"
#import "DeineMuddaAppDelegate.h"
#import "FBConnect.h"

@implementation MainViewController
@synthesize contentView;
@synthesize jokeViewController;
@synthesize bannerView;
@synthesize facebookMessage;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[[[self jokeViewController] view] removeFromSuperview];
	[self setFacebookMessage: nil];
	
	[self setBannerView: nil];
	[self setContentView: nil];
	[self setJokeViewController: nil];
	[twitterEngine release], twitterEngine = nil;
	[facebook release], facebook = nil;
	[jokeHistory release], jokeHistory = nil;
	[fetchedResultsController release], fetchedResultsController = nil;
	
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center addObserver: self selector:@selector(achievementUnlocked:) name: @"AchievementUnlocked" object: nil];
	
	
	[navi setTitle: NSLocalizedString(@"Deine Mudda", nil)];
	
	JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: [self createNewJoke]];
	[self setJokeViewController: jvc];
	[jvc release];
	[[self contentView] addSubview: [jokeViewController view]];
	
	[prevButton setEnabled: NO];
	
	bannerVisibleFrame = [bannerView frame];
	bannerHiddenFrame = bannerVisibleFrame;
	bannerHiddenFrame.origin.x -= 330;
	
	[bannerView setFrame: bannerHiddenFrame];
	
	isBannerLoaded = NO;
	isBannerVisible = NO;
	isChangingJokeView = NO;
	isDisplayingFavorites = NO;
	
	UISwipeGestureRecognizer *leftSwipe = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextJoke:)] autorelease];
    UISwipeGestureRecognizer *rightSwipe = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(prevJoke:)] autorelease];
    
	[leftSwipe setDirection: UISwipeGestureRecognizerDirectionLeft];
	[rightSwipe setDirection: UISwipeGestureRecognizerDirectionRight];
	
	
	[[self view] addGestureRecognizer: leftSwipe];
	[[self view] addGestureRecognizer: rightSwipe];
	
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[[[self jokeViewController] view] removeFromSuperview];
	[self setBannerView: nil];
	[self setContentView: nil];
	[self setJokeViewController: nil];
	[facebook release], facebook = nil;
		
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark -
#pragma mark notification handlers
- (void) achievementUnlocked: (NSNotification *) notification
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Erfolg!",nil) 
													message: [NSString stringWithFormat: @"Herzlichen Glueckwunsch! Du hast den Erfolg \"%@\" freigeschaltet!",
															  [notification object]]
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
	[alert release]; 
	[self reloadJokes];
	
	NSString *stat = [NSString stringWithFormat: @"hat den Erfolg \"%@\" freigeschaltet.", [notification object]];
	[self setFacebookMessage: stat];
	[self shareOverFarmville];
}


#pragma mark -
#pragma mark actions 
- (IBAction) toggleFavoriteDisplay: (id) sender
{
	if (isChangingJokeView)
		return;
	
	isDisplayingFavorites = !isDisplayingFavorites;
	
	if (isDisplayingFavorites)
	{	
		[sender setStyle: UIBarButtonItemStyleDone];
		[navi setTitle: NSLocalizedString(@"Favoriten", nil)];
	}
	else
	{	
		[sender setStyle: UIBarButtonItemStyleBordered];
		[navi setTitle: NSLocalizedString(@"Deine Mudda", nil)];
	}
	
	
	jokeIndex = 0;
	[prevButton setEnabled: NO];
	
	[jokeHistory release], jokeHistory = nil;
	[fetchedResultsController release], fetchedResultsController = nil;
	
	[prevButton setEnabled: NO];
	isChangingJokeView = YES;
	
	[UIView beginAnimations: @"flipanimation" context: NULL];
	[UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView: [self contentView] cache: YES];
	[UIView setAnimationDuration: 0.5f];
	[UIView setAnimationDelegate:self];   
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];  
	
	
	[[jokeViewController view] removeFromSuperview];
	[jokeViewController release];
	jokeViewController = nil;
	
	
	JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: [self createNewJoke]];
	[self setJokeViewController: jvc];
	[jvc release];
	[[self contentView] addSubview: [jokeViewController view]];
	
	[UIView commitAnimations];
	jokeIndex = 0;
	
}

- (IBAction) showAchievements: (id) sender
{
	AchievementsViewController *avc = [[AchievementsViewController alloc] initWithNibName: @"AchievementsViewController" bundle: nil];
//	[[self contentView] addSubview: [avc view]];
	
	UINavigationController *cont = [[UINavigationController alloc] initWithRootViewController: avc];
	[[cont navigationBar] setTintColor: [UIColor colorWithRed: (195.0f/255.0f) green: (8.0f/255.0f) blue: (8.0f/255.0f) alpha: 1.0]];
	
	[self presentModalViewController: cont animated: YES];
	[avc release];
	[cont release];
}

- (IBAction) nextJoke: (id) sender
{
	if (isChangingJokeView)
		return;

	isChangingJokeView = YES;
	
	tmpViewController = [jokeViewController retain];

	CGRect frame = [[jokeViewController view] frame];
	frame.origin.x -= 330;
	
	CGRect frame2 = [[jokeViewController view] frame];
	frame2.origin.x += 330;	
	
	//if we're at the end of the history create a new joke
	//else let's get the next joke saved in history
	if (jokeIndex == [jokeHistory indexOfObject: [jokeHistory lastObject]])
	{
		if (isDisplayingFavorites)
			jokeIndex ++;

		JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: [self createNewJoke]];
		[self setJokeViewController: jvc];
		[jvc release];
	}
	else
	{
		jokeIndex ++;
		
		NSNumber *idx = [jokeHistory objectAtIndex: jokeIndex];
		FXManagedJoke *nextJoke  = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: [idx integerValue]];

		JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: nextJoke];
		[self setJokeViewController: jvc];
		[jvc release];
		
	}
	
	[[jokeViewController view] setFrame: frame2];
	[[self contentView] addSubview: [jokeViewController view]];
	frame2.origin.x -= 330;
	
	[UIView beginAnimations:nil context: @"step1"];  
//	[UIView setAnimationDuration:.5];  

	[[tmpViewController view] setFrame: frame];
	[[jokeViewController view] setFrame: frame2];
	
	[UIView setAnimationDelegate:self];   
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];  
	
	[UIView commitAnimations];
}

- (IBAction) prevJoke: (id) sender
{
	//we're at the 0st position!
	if (jokeIndex == 0)
		return;
	
	if (isChangingJokeView)
		return;
	
	isChangingJokeView = YES;
	
	tmpViewController = [jokeViewController retain];
	
	CGRect frame = [[jokeViewController view] frame];
	frame.origin.x += 330;
	
	CGRect frame2 = [[jokeViewController view] frame];
	frame2.origin.x -= 330;	
	
	//if we're at first element do nothing
	if (jokeIndex == 0)
	{
		NSNumber *idx = [jokeHistory objectAtIndex: 0];
		FXManagedJoke *joke  = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: [idx integerValue]];

		JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: joke];
		[self setJokeViewController: jvc];
		[jvc release];
	}
	else
	{
		NSNumber *idx = [jokeHistory objectAtIndex: jokeIndex-1];
		FXManagedJoke *prevJoke  = [[[self fetchedResultsController] fetchedObjects] objectAtIndex: [idx integerValue]];

		
		jokeIndex --;
		
		JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: prevJoke];
		[self setJokeViewController: jvc];
		[jvc release];
		
	}
	
	
	[[jokeViewController view] setFrame: frame2];
	[[self contentView] addSubview: [jokeViewController view]];
	frame2.origin.x += 330;
	
	
	[UIView beginAnimations:nil context: @"step1"];  
	//[UIView setAnimationDuration:.5];  
	
	[[tmpViewController view] setFrame: frame];
	[[jokeViewController view] setFrame: frame2];
	
	[UIView setAnimationDelegate:self];   
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];  
	
	[UIView commitAnimations];
	
}


#pragma mark -
#pragma mark swipe in animation
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	NSLog(@"anim did stop");
	if ([(NSString *)context isEqualToString: @"step1"])
	{
		[[tmpViewController view] removeFromSuperview];
		[tmpViewController release];
		tmpViewController = nil;
		isChangingJokeView = NO;
		
		if (jokeIndex == 0)
		{
			[prevButton setEnabled: NO];
		}
		else
		{
			[prevButton setEnabled: YES];
		}
	}
	
	if ([animationID isEqualToString: @"flipanimation"])
	{
		isChangingJokeView = NO;
	}
}

#pragma mark -
#pragma mark share sheet
- (void) showShareSheet: (id) sender
{
	
//	NSArray *buttonTitles = [NSArray arrayWithObjects: 
//							 nil];
	
/*	if (1)//[MFMessageComposeViewController canSendText])
	{	
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share", nil)
																 delegate: self
														cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
												   destructiveButtonTitle: nil
														otherButtonTitles: 	
									  NSLocalizedString(@"E-Mail", nil),
									  NSLocalizedString(@"Facebook", nil),
									  NSLocalizedString(@"Twitter", nil),
  									  NSLocalizedString(@"SMS", nil),
																	  nil];
		[actionSheet showInView: [self view]];
	}
	else*/
	{
		UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Share", nil)
																 delegate: self
														cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
												   destructiveButtonTitle: nil
														otherButtonTitles: 	
									  NSLocalizedString(@"E-Mail", nil),
									  NSLocalizedString(@"Facebook", nil),
									  NSLocalizedString(@"Twitter", nil),
									  nil] autorelease];
		[actionSheet showInView: [self view]];
		
	}
}

- (void)actionSheet: (UIActionSheet *)actionSheet didDismissWithButtonIndex: (NSInteger) buttonIndex
{
	//mail
	if (buttonIndex == 0)
	{
		NSLog(@"mail");
		[self shareOverMail];
	}
	
	//farmbook
	if (buttonIndex == 1)
	{
		[self setFacebookMessage: [[self currentJoke] jokeText]];
		[self shareOverFarmville];
		NSLog(@"facebook");
	}
	
	//twitter
	if (buttonIndex == 2)
	{
		NSLog(@"twitter");
		[self shareOverTwitter];
	}

/*	if (1)//[MFMessageComposeViewController canSendText])
	{
		//sms
		if (buttonIndex == 3)
		{
			NSLog(@"SMS");
			[self startSMS];
		}

		//cancel
		if (buttonIndex == 4)
		{
			NSLog(@"cancel");
		}
	}
	else*/
	{
		//cancel
		if (buttonIndex == 3)
		{
			NSLog(@"cancel");
		}
	}
	
	
	
	//[actionSheet autorelease];
}


#pragma mark -
#pragma mark mail
- (void) shareOverMail
{
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
	[mc setMailComposeDelegate: self];
	
	[mc setSubject: @"Deine Mudda"];
	[mc setMessageBody: [NSString stringWithFormat:@"<p>%@</p><p>Quelle: <a href='http://itunes.com'>Deine Mudda App</a></p>", [[self currentJoke] jokeText]] isHTML: YES];
	
	[self presentModalViewController: mc animated: YES];
	
	[mc release];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the 
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSInteger num = [defs integerForKey: @"mailsSent"];
	num++;
	[defs setInteger: num forKey: @"mailsSent"];
	[defs synchronize];
	
	
	if ([[[self currentJoke] jokeText] containsString: @"A-Team" ignoringCase: YES])
	{
		[defs setBool: YES forKey: @"ateam_mail"];
		[defs synchronize];
	}
	
	
	
//    feedbackMsg.hidden = NO;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
  //          feedbackMsg.text = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
    //        feedbackMsg.text = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:

			
            break;
        case MFMailComposeResultFailed:
        //    feedbackMsg.text = @"Result: Mail sending failed";
            break;
        default:
          //  feedbackMsg.text = @"Result: Mail not sent";
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del currentUnlockLevel]; //trigger any achievement changes!

}



- (void) startSMS
{
	MFMessageComposeViewController *mf = [[MFMessageComposeViewController alloc] init];
	
	[self presentModalViewController: mf animated: YES];
	
	[mf release];
}


#pragma mark -
#pragma mark database
- (NSFetchedResultsController *) fetchedResultsController
{
	if (fetchedResultsController)
		return fetchedResultsController;

	[NSFetchedResultsController deleteCacheWithName:@"Root"];
	
	//JSDataCore *dataCore = [JSDataCore sharedInstance];
	FXiDataCore *dataCore = [FXiDataCore sharedInstance];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Joke" inManagedObjectContext: [dataCore managedObjectContext]];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:50];

	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	NSInteger unlockLevel = [del currentUnlockLevel];

	NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"(%K <= %@ )", @"unlockLevel", [NSNumber numberWithInt: unlockLevel]];
	[fetchRequest setPredicate: newPredicate];

	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rating" ascending: NO];
	//NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	NSArray *sortDescriptors = nil;
	
	if (isDisplayingFavorites)
	{
		sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	}
	else
	{
		sortDescriptors = [[NSArray alloc] init];	
	}

	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	

	
	fetchedResultsController = [[NSFetchedResultsController alloc] 
													 initWithFetchRequest: fetchRequest 
													 managedObjectContext: [dataCore managedObjectContext] 
													 sectionNameKeyPath:nil 
													 cacheName:@"Root"];

	[fetchedResultsController setDelegate: self];
	[fetchRequest release];
	[sortDescriptor release];
	[sortDescriptors release];

	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error]) 
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	NSLog(@"unlock level: %i", unlockLevel);
	NSLog(@"we got %i objects", [[fetchedResultsController fetchedObjects] count]);
	
	if (isDisplayingFavorites)
	{
		[jokeHistory release], jokeHistory = nil;
		jokeHistory = [[NSMutableArray alloc] init];

		for (NSInteger i = 0; i < [[fetchedResultsController fetchedObjects] count]; i++)
		{
			[jokeHistory addObject: [NSNumber numberWithInteger: i]];
		}
		
	}
	
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@"i changed <3");
	if (isDisplayingFavorites)
	{
		[fetchedResultsController release], fetchedResultsController = nil;
//		[self fetchedResultsController];
	}
		
}

//reload the joke list
- (void) reloadJokes
{
	[jokeHistory release], jokeHistory = nil;
	[fetchedResultsController release], fetchedResultsController = nil;
	
	[[jokeViewController view] removeFromSuperview];
	[jokeViewController release];
	jokeViewController = nil;
	
	jokeIndex = 0;
	[prevButton setEnabled: NO];
	
	JokeViewController *jvc = [[JokeViewController alloc] initWithJoke: [self createNewJoke]];
	[self setJokeViewController: jvc];
	[jvc release];
	[[self contentView] addSubview: [jokeViewController view]];
	
	[UIView commitAnimations];
	jokeIndex = 0;
	
}

- (FXManagedJoke *) createNewJoke
{
	if (!jokeHistory)
		jokeHistory = [[NSMutableArray alloc] initWithCapacity: 32];
	
	NSArray *jokes = [[self fetchedResultsController] fetchedObjects];
	FXManagedJoke *joke = nil;
	
	if (!isDisplayingFavorites)
	{
		int rnd = rand()%[jokes count];
		joke = [jokes objectAtIndex: rnd];
		[jokeHistory addObject: [NSNumber numberWithInt: rnd]];
		jokeIndex = [jokeHistory indexOfObject: [jokeHistory lastObject]];
	}
	else 
	{
		joke = [jokes objectAtIndex: jokeIndex];
		jokeIndex ++;
		//		[jokeHistory addObject: [NSNumber numberWithInt: jokeIndex]];
		//		jokeIndex = [jokeHistory indexOfObject: [jokeHistory lastObject]];
	}
	
	
	NSLog(@"%i", jokeIndex);
	
	return joke;
	
}

- (FXManagedJoke *) currentJoke
{
	NSNumber *idx = [jokeHistory objectAtIndex: jokeIndex];
	return [[[self fetchedResultsController] fetchedObjects] objectAtIndex: [idx integerValue]];
}


@end
