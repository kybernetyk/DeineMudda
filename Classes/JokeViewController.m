//
//  JokeViewController.m
//  DeineMudda
//
//  Created by jrk on 16/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "JokeViewController.h"
#import "FXiDataCore.h"
#import <QuartzCore/QuartzCore.h>
#import "DeineMuddaAppDelegate.h"

@implementation JokeViewController
@synthesize textView;
@synthesize ratingView;

- (id) initWithJoke: (FXManagedJoke *) aJoke
{
	self = [super initWithNibName: @"JokeViewController" bundle: nil];

	if (self)
	{
		joke = [aJoke retain];	
	}
	
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (void) setBorderAndCornersForView: (UIView *) aView
{
	[[aView layer] setCornerRadius: K_CORNER_RADIUS];
	[[aView layer] setMasksToBounds: YES];
	[[aView layer] setBorderColor: [[UIColor blackColor] CGColor]];
	[[aView layer] setBorderWidth: K_BORDER_WIDTH];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self setBorderAndCornersForView: [self textView]];
	[self setBorderAndCornersForView: [self ratingView]];
	
	[textView setText: [joke jokeText]];
	
	//looooooooool
/*	[star0 setHidden: YES];
	[star1 setHidden: YES];
	[star2 setHidden: YES];
	[star3 setHidden: YES];
	[star4 setHidden: YES];*/
	
	[ratingLabel setText: [NSString stringWithFormat: @"%@: %i/5", NSLocalizedString(@"Bewertung",nil), [[joke rating] intValue]]];
	
	[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateHighlighted];
	[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateHighlighted];
	[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateHighlighted];
	[star3 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateHighlighted];
	[star4 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateHighlighted];
	
	if ([[joke rating] intValue] == 1)
	{	
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		
	}

	if ([[joke rating] intValue] == 2)
	{	
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];

	}

	if ([[joke rating] intValue] == 3)
	{	
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
	}
	
	if ([[joke rating] intValue] == 4)
	{	
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
	}
	
	if ([[joke rating] intValue] == 5)
	{	
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star4 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
	}
}

- (IBAction) starTouched: (id) sender
{
	NSLog(@"OLOL!");
//	[sender setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
	[statusQuo release], statusQuo = nil;
	statusQuo = [NSArray arrayWithObjects: 
				 [star0 backgroundImageForState: UIControlStateNormal],
				 [star1 backgroundImageForState: UIControlStateNormal],
				 [star2 backgroundImageForState: UIControlStateNormal],
				 [star3 backgroundImageForState: UIControlStateNormal],
				 [star4 backgroundImageForState: UIControlStateNormal],
				 nil];
	[statusQuo retain];
	
	if (sender == star4)
	{
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star4 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
	}
	if (sender == star3)
	{
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star4 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
	}
	if (sender == star2)
	{
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
		[star4 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
	}
	if (sender == star1)
	{
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
		[star4 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
	}
	if (sender == star0)
	{
		[star0 setBackgroundImage: [UIImage imageNamed: @"star.png"] forState: UIControlStateNormal];
		[star1 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
		[star2 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
		[star3 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
		[star4 setBackgroundImage: [UIImage imageNamed: @"star_dash.png"] forState: UIControlStateNormal];
	}
}

- (IBAction) starUnTouched: (id) sender
{
	NSLog(@"star unlold!");
	
	[star0 setBackgroundImage: [statusQuo objectAtIndex: 0] forState: UIControlStateNormal];
	[star1 setBackgroundImage: [statusQuo objectAtIndex: 1] forState: UIControlStateNormal];
	[star2 setBackgroundImage: [statusQuo objectAtIndex: 2] forState: UIControlStateNormal];
	[star3 setBackgroundImage: [statusQuo objectAtIndex: 3] forState: UIControlStateNormal];
	[star4 setBackgroundImage: [statusQuo objectAtIndex: 4] forState: UIControlStateNormal];
	
	[statusQuo release], statusQuo = nil;
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) starTapped: (id) sender
{
	if (sender == star0)
		[joke setRating: [NSNumber numberWithInt: 1]];
	if (sender == star1)
		[joke setRating: [NSNumber numberWithInt: 2]];
	if (sender == star2)
		[joke setRating: [NSNumber numberWithInt: 3]];
	if (sender == star3)
		[joke setRating: [NSNumber numberWithInt: 4]];
	if (sender == star4)
		[joke setRating: [NSNumber numberWithInt: 5]];

	[ratingLabel setText: [NSString stringWithFormat: @"%@: %i/5", NSLocalizedString(@"Bewertung",nil), [[joke rating] intValue]]];
	
	[[FXiDataCore sharedInstance] saveContext];
	
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	NSInteger num = [defs integerForKey: @"jokesRated"];
	num++;
	[defs setInteger: num forKey: @"jokesRated"];
	[defs synchronize];
	
	if ([[joke jokeText] containsString: @"A-Team" ignoringCase: YES] && [[joke rating] intValue] == 5)
	{
		[defs setBool: YES forKey: @"ateam_rated"];
		[defs synchronize];
	}
	
	DeineMuddaAppDelegate *del = [[UIApplication sharedApplication] delegate];
	[del currentUnlockLevel]; //trigger any achievement changes!

}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	[self setTextView: nil];
	[self setRatingView: nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[joke release], joke = nil;
	NSLog(@"joke view controller dealloc");
    [super dealloc];
}


@end
