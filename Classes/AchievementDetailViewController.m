//
//  AchievementDetailViewController.m
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "AchievementDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AchievementDetailViewController
@synthesize descriptionTextView;
@synthesize rewardTextView;

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

	[self setBorderAndCornersForView: descriptionTextView];
	[self setBorderAndCornersForView: rewardTextView];	
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

- (void)viewDidUnload 
{
    [super viewDidUnload];
	NSLog(@"achievement detail unlaoad");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"achievement detail dealloc");
    [super dealloc];
}


@end
