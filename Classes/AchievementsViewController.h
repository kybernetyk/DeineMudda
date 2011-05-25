//
//  AchievementsViewController.h
//  DeineMudda
//
//  Created by jrk on 17/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AchievementsViewController : UIViewController
{
	IBOutlet UIView *contentView;
	IBOutlet UIScrollView *scrollView;
	
	NSTimer *flashTimer;
}



@end
