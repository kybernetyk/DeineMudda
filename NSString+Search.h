//
//  NSString+Search.h
//  DummyDownload
//
//  Created by jrk on 24/9/09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (SearchingAdditions)

- (BOOL) containsString:(NSString *)aString;
- (BOOL) containsString:(NSString *)aString ignoringCase:(BOOL)flag;

@end
