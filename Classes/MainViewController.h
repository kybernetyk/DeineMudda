//
//  MainViewController.h
//  DeineMudda
//
//  Created by jrk on 16/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "JokeViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"

@interface MainViewController : UIViewController <SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterEngineDelegate, UIActionSheetDelegate, FBDialogDelegate, FBSessionDelegate>
{
	IBOutlet UIView *contentView;
	IBOutlet ADBannerView *bannerView;
	IBOutlet UIBarButtonItem *prevButton;
	IBOutlet UINavigationItem *navi;
	SA_OAuthTwitterEngine *twitterEngine;
	
	JokeViewController *jokeViewController;
	JokeViewController *tmpViewController;

	CGRect bannerVisibleFrame;
	CGRect bannerHiddenFrame;
	BOOL isBannerLoaded;
	BOOL isBannerVisible;
	
	BOOL isChangingJokeView;
	
	Facebook *facebook;
	
	NSFetchedResultsController *fetchedResultsController;
	
	NSInteger jokeIndex; //points to jokeHistory lastElementIndex
	NSMutableArray *jokeHistory; //saves our joke history 
	
	BOOL isDisplayingFavorites;
	
	NSString *facebookMessage;
}

@property (readwrite, retain) UIView *contentView;
@property (readwrite, retain) ADBannerView *bannerView;
@property (readwrite, retain) JokeViewController *jokeViewController;

@property (readwrite, retain) NSString *facebookMessage;

- (NSFetchedResultsController *) fetchedResultsController;
- (FXManagedJoke *) currentJoke; //returns the current showed joke
- (FXManagedJoke *) createNewJoke; //creates new joke entity and advances pointer

@end


@interface MainViewController (Actions)
- (IBAction) dieBanner: (id) sender;
- (IBAction) lolBanner: (id) sender;
- (IBAction) showShareSheet: (id) sender;
- (IBAction) showAchievements: (id) sender;

- (IBAction) nextJoke: (id) sender;
- (IBAction) prevJoke: (id) sender;

- (IBAction) toggleFavoriteDisplay: (id) sender;

@end
