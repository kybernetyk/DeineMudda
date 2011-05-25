//
//  FXManagedJoke.h
//  DeineMudda
//
//  Created by jrk on 22/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FXManagedJoke : NSManagedObject 
{

}
@property (nonatomic, retain) NSString * jokeText;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSNumber * unlockLevel;

@end
