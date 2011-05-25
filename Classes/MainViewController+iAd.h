//
//  MainViewController+iAd.h
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface MainViewController (iAd)
- (void) showBannerView;
- (void) hideBannerView;
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave;
- (void)bannerViewDidLoadAd:(ADBannerView *)banner;
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error;
@end
