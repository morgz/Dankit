//
//  TimeEntryFormatter.m
//  SwimAdd
//
//  Created by morgz on 01/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TimeEntryFormatter.h"


@implementation TimeEntryFormatter


-(id)init {
	
	self = [super init];
	if (self) {
	
		[self setTimeStyle:NSDateFormatterShortStyle];
		[self setDateFormat:@"k:mm"];
		
		
	}
	
	return self;
	
	
	
}

-(int)timeAsInt:(NSDate *)aDate {
	
	NSString *time = [self stringFromDate:aDate];
	NSString *timeWithoutColon = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
	int timeAsInt = [timeWithoutColon intValue];
	
	return timeAsInt;
	
	
}


- (void)dealloc {
    [super dealloc];
	
}


@end
