//
//  MainViewController+Twitter.h
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface MainViewController (Twitter)

- (void) shareOverTwitter;
- (void) sendTwitterUpdate;
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username;
- (void) removeSavedTwitterAuthData;
- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username;
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username;
- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller;
- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller;
- (void) requestSucceeded: (NSString *) requestIdentifier;
- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error;

@end
