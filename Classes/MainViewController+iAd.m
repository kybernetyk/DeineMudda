//
//  MainViewController+iAd.m
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "MainViewController+iAd.h"


@implementation MainViewController (iAd)
#pragma mark -
#pragma mark iad hiding/showing

- (void) showBannerView
{
	if (!isBannerLoaded)
		return;
	if (isBannerVisible)
		return;
	[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
	[bannerView setFrame: bannerVisibleFrame];
	[UIView commitAnimations];
	isBannerVisible = YES;
}

- (void) hideBannerView
{
	if (!isBannerLoaded)
		return;
	if (!isBannerVisible)
		return;
	[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
	[bannerView setFrame: bannerHiddenFrame];
	[UIView commitAnimations];
	isBannerVisible = NO;
}


#pragma mark -
#pragma mark iAd delegate

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	NSLog(@"bannerViewActionShouldBegin:");
	return YES;	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	NSLog(@"banner did load ...");
	isBannerLoaded = YES;
	[self showBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	NSLog(@"failed to get $$$: %@",[error localizedDescription]);
	[self hideBannerView];
	isBannerLoaded = NO;
}

- (IBAction) dieBanner: (id) sender
{
	[self bannerView: self didFailToReceiveAdWithError: nil];
}

- (IBAction) lolBanner: (id) sender
{
	[self bannerViewDidLoadAd: nil];
}


@end
