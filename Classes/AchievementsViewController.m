//
//  AchievementsViewController.m
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "DeineMuddaAppDelegate.h"
#import "AchievementsViewController.h"
#import "AchievementDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AchievementsViewController

#pragma mark -
#pragma mark View lifecycle

- (void) setBorderAndCornersForView: (UIView *) aView
{
	[[aView layer] setCornerRadius: K_CORNER_RADIUS];
	[[aView layer] setMasksToBounds: YES];
	[[aView layer] setBorderColor: [[UIColor blackColor] CGColor]];
	[[aView layer] setBorderWidth: K_BORDER_WIDTH];
	
}


- (UIView *) achievementBoxWithAchievementTitle: (NSString *) title text: (NSString *) text reward: (NSString *) reward;
{
	UIView *container = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 280, 100)] autorelease];
	[container setBackgroundColor: [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3]];
	[container setOpaque: YES];
	[container setClipsToBounds: YES];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0.0, 5.0, 280.0, 20.0)] autorelease];
	[titleLabel setTextColor: [UIColor whiteColor]];
	[titleLabel setTextAlignment: UITextAlignmentCenter];
	[titleLabel setOpaque: NO];
	[titleLabel setBackgroundColor: [UIColor clearColor]];
	[titleLabel setText: title];
	[container addSubview: titleLabel];

/*	UILabel *textLabel = [[[UILabel alloc] initWithFrame: CGRectMake(5.0, 25.0, 270.0, 17.0*4.0)] autorelease];
	[textLabel setNumberOfLines: 4];
	[textLabel setLineBreakMode: UILineBreakModeWordWrap];
	[textLabel setTextColor: [UIColor whiteColor]];
	[textLabel setTextAlignment: UITextAlignmentLeft];
	[textLabel setBaselineAdjustment: UIBaselineAdjustmentAlignBaselines];
//	[textLabel setOpaque: NO];
//	[textLabel setBackgroundColor: [UIColor clearColor]];
		[textLabel setBackgroundColor: [UIColor blueColor]];
	[textLabel setText: text];
	[container addSubview: textLabel];	*/
	
	UITextView *textLabel = [[[UITextView alloc] initWithFrame: CGRectMake (0.0, 17.0, 280.0, 17.0*4.0)] autorelease];
	[textLabel setAutoresizingMask: UIViewAutoresizingNone];
	[textLabel setFont: [UIFont fontWithName: @"Helvetica" size: 14.0f]];
	[textLabel setTextColor: [UIColor whiteColor]];
	[textLabel setTextAlignment: UITextAlignmentLeft];
	[textLabel setEditable: NO];
	[textLabel setOpaque: NO];
	[textLabel setBackgroundColor: [UIColor clearColor]];
//	[textLabel setBackgroundColor: [UIColor blueColor]];
	[textLabel setUserInteractionEnabled: NO];
	[textLabel setText: text];
	[container addSubview: textLabel];

	if (reward)
	{
		UITextView *rewardLable = [[[UITextView alloc] initWithFrame: CGRectMake (0.0, 17.0+3*17.0, 280.0-22, 17.0*2)] autorelease];
		[rewardLable setAutoresizingMask: UIViewAutoresizingNone];
		[rewardLable setFont: [UIFont fontWithName: @"Helvetica" size: 14.0f]];
		[rewardLable setTextColor: [UIColor whiteColor]];
		[rewardLable setTextAlignment: UITextAlignmentLeft];
		[rewardLable setEditable: NO];
		[rewardLable setOpaque: NO];
		[rewardLable setBackgroundColor: [UIColor clearColor]];
	//	[rewardLable setBackgroundColor: [UIColor greenColor]];
		[rewardLable setText: [NSString stringWithFormat: NSLocalizedString(@"Belohnung: %@", nil), reward]];
		[rewardLable setUserInteractionEnabled: NO];
		[container addSubview: rewardLable];
	}

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	if ([defs boolForKey: title])
	{
		UIImageView *accomplished = [[[UIImageView alloc] initWithFrame: CGRectMake(280-22, 100-27, 21.0, 26.0)] autorelease];
		[accomplished setImage: [UIImage imageNamed: @"108-badge.png"]];
		[container addSubview: accomplished];
	}
	
	
	[self setBorderAndCornersForView: container];
	
	return container;
}

- (UIView *) infoBoxWithTitle: (NSString *) title text: (NSString *) text reward: (NSString *) reward
{
	UIView *container = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 280, 150)] autorelease];
	[container setBackgroundColor: [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.3]];
	[container setOpaque: YES];
	[container setClipsToBounds: YES];
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame: CGRectMake(0.0, 5.0, 280.0, 20.0)] autorelease];
	[titleLabel setTextColor: [UIColor whiteColor]];
	[titleLabel setTextAlignment: UITextAlignmentCenter];
	[titleLabel setOpaque: NO];
	[titleLabel setBackgroundColor: [UIColor clearColor]];
	[titleLabel setText: title];
	[container addSubview: titleLabel];
	
	UITextView *textLabel = [[[UITextView alloc] initWithFrame: CGRectMake (0.0, 17.0, 280.0, 17.0*6.0)] autorelease];
	[textLabel setAutoresizingMask: UIViewAutoresizingNone];
	[textLabel setFont: [UIFont fontWithName: @"Helvetica" size: 14.0f]];
	[textLabel setTextColor: [UIColor whiteColor]];
	[textLabel setTextAlignment: UITextAlignmentLeft];
	[textLabel setEditable: NO];
	[textLabel setOpaque: NO];
	[textLabel setBackgroundColor: [UIColor clearColor]];
	//	[textLabel setBackgroundColor: [UIColor blueColor]];
	[textLabel setUserInteractionEnabled: NO];
	[textLabel setText: text];
	[container addSubview: textLabel];
	
	if (reward)
	{
		UITextView *rewardLable = [[[UITextView alloc] initWithFrame: CGRectMake (0.0, 150-17*2, 280.0-22, 17.0*3)] autorelease];
		[rewardLable setAutoresizingMask: UIViewAutoresizingNone];
		[rewardLable setFont: [UIFont fontWithName: @"Helvetica" size: 14.0f]];
		[rewardLable setTextColor: [UIColor whiteColor]];
		[rewardLable setTextAlignment: UITextAlignmentLeft];
		[rewardLable setEditable: NO];
		[rewardLable setOpaque: NO];
		[rewardLable setBackgroundColor: [UIColor clearColor]];
		//	[rewardLable setBackgroundColor: [UIColor greenColor]];
		[rewardLable setText: [NSString stringWithFormat: NSLocalizedString(@"%@", nil), reward]];
		[rewardLable setUserInteractionEnabled: NO];
		[container addSubview: rewardLable];
	}
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	if ([defs boolForKey: title])
	{
		UIImageView *accomplished = [[[UIImageView alloc] initWithFrame: CGRectMake(280-22, 150-27, 21.0, 26.0)] autorelease];
		[accomplished setImage: [UIImage imageNamed: @"108-badge.png"]];
		[container addSubview: accomplished];
	}
	
	
	[self setBorderAndCornersForView: container];
	
	return container;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	[[self navigationItem] setTitle: NSLocalizedString(@"Erfolge",nil)];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target: self action: @selector(done:)];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del currentUnlockLevel]; //trigger any achievement changes!
	NSInteger unlockedJokes = [del unlockedJokes];
	

	UIView *achievementBox = [self infoBoxWithTitle: @"Erfolge" text: @"Hier siehst du die Aufgabe, die du erfuellen musst, um eine Belohnung freizuschalten. Ein Orden rechts unten bedeutet, dass du die Aufgabe erfuellt hast." reward: @"Hier erscheint die Belohnung."];
	[achievementBox setCenter: CGPointMake(160,80)];
	[contentView addSubview: achievementBox];

	float start_y = 125.0;
	int i = 1;
	
	achievementBox = [self achievementBoxWithAchievementTitle: @"Gesichtsbuch" text: @"Poste 20 Sprueche auf Facebook." reward: @"75 neue Sprueche"];
	[achievementBox setCenter: CGPointMake(160, start_y+110*i++)];
	[contentView addSubview: achievementBox];
	
	achievementBox = [self achievementBoxWithAchievementTitle: @"Alte Vogellady" text: @"Poste 20 Sprueche auf Twitter." reward: @"50 neue Sprueche"];
	[achievementBox setCenter: CGPointMake(160, start_y+110*i++)];
	[contentView addSubview: achievementBox];
	
	achievementBox = [self achievementBoxWithAchievementTitle: @"Email Spammer #1" text: @"Verschicke 10 Sprueche per E-Mail." reward: @"25 neue Sprueche"];
	[achievementBox setCenter: CGPointMake(160, start_y+110*i++)];
	[contentView addSubview: achievementBox];

	achievementBox = [self achievementBoxWithAchievementTitle: @"Richter und Henker" text: @"Bewerte 50 Sprueche." reward: @"50 neue Sprueche"];
	[achievementBox setCenter: CGPointMake(160, start_y+110*i++)];
	[contentView addSubview: achievementBox];
	
	achievementBox = [self achievementBoxWithAchievementTitle: @"Treat Your Mother Right" text: @"Bewerte den A-Team Spruch mit 5 und poste ihn auf Facebook und Twitter." reward: @"100 neue Sprueche"];
	[achievementBox setCenter: CGPointMake(160, start_y+110*i++)];
	[contentView addSubview: achievementBox];
	

	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	

	NSString *zutxt =  [NSString stringWithFormat: @"Du hast %i von 379 Spruechen freigeschaltet.\n\nDamit hast du %.2f%% aller Sprueche gefunden.",
						unlockedJokes,
						((float)(unlockedJokes))/379.0f * 100.0f
						];
	if ([defs boolForKey: @"Gesichtsbuch"] &&
		[defs boolForKey: @"Alte Vogellady"] &&
		[defs boolForKey: @"Email Spammer #1"] &&
		[defs boolForKey: @"Richter und Henker"] &&
		[defs boolForKey: @"Treat Your Mother Right"])
	{
		[defs setBool: YES forKey: @"Zusammenfassung"];
		zutxt = @"O M G! Du hast es geschafft! Alle Sprueche freigeschaltet.\n\nDu bist voll cool unso!";
	}
	
	
	achievementBox = [self infoBoxWithTitle: @"Zusammenfassung" text: zutxt reward: nil];
	[achievementBox setCenter: CGPointMake(160, 45+start_y+110*i++)];
	[contentView addSubview: achievementBox];
	
	
	CGRect frame = [contentView frame];
	frame.size.height = 25+start_y+110*i;
	[contentView setFrame: frame];
	
	[scrollView setIndicatorStyle: UIScrollViewIndicatorStyleBlack];
	[scrollView setContentSize: [contentView frame].size];

	//flashTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0f target: self selector:@selector(flashScrollbar:) userInfo: nil repeats: YES];
//	[flashTimer retain];
	
	[scrollView flashScrollIndicators];
}

- (void) flashScrollbar: (NSTimer *) timer
{
	[scrollView flashScrollIndicators];
}

- (void) done: (id) sender
{
	[self dismissModalViewControllerAnimated: YES];
	NSLog(@"penis!");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView 
{
	return contentView;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	[super viewDidUnload];
	
	[flashTimer invalidate];
	[flashTimer release];
	flashTimer = nil;
	
	NSLog(@"achievementS unload");
	
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
	[flashTimer invalidate];
	[flashTimer release];
	flashTimer = nil;
	
	NSLog(@"achievementS dealloc");
    [super dealloc];
}


@end

