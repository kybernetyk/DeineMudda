//
//  AchievementDetailViewController.h
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AchievementDetailViewController : UIViewController 
{
	IBOutlet UITextView *descriptionTextView;
	IBOutlet UITextView *rewardTextView;
}

@property (readwrite, retain) UITextView *descriptionTextView;
@property (readwrite, retain) UITextView *rewardTextView;

@end
