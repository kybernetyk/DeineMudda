//
//  JokeViewController.h
//  DeineMudda
//
//  Created by jrk on 16/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXManagedJoke.h"

@interface JokeViewController : UIViewController 
{
	IBOutlet UITextView *textView;
	IBOutlet UIView *ratingView;
	
	IBOutlet UILabel *ratingLabel;
	
	IBOutlet UIButton *star0;
	IBOutlet UIButton *star1;
	IBOutlet UIButton *star2;
	IBOutlet UIButton *star3;
	IBOutlet UIButton *star4;
	
	FXManagedJoke *joke;
	
	NSArray *statusQuo;
}

- (id) initWithJoke: (FXManagedJoke *) aJoke;

- (IBAction) starTouched: (id) sender;
- (IBAction) starUnTouched: (id) sender;

- (IBAction) starTapped: (id) sender;

@property (readwrite, retain) UITextView *textView;
@property (readwrite, retain) UIView *ratingView;

@end
