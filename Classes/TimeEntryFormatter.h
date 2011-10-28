//
//  TimeEntryFormatter.h
//  SwimAdd
//
//  Created by morgz on 01/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeEntryFormatter : NSDateFormatter {

}

-(int)timeAsInt:(NSDate *)aDate;

@end
