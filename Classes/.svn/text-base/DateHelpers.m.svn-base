#import "DateHelpers.h"
#import "TimeEntryFormatter.h"

@implementation DateHelpers

+ (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *result = [formatter stringFromDate:date];
    [formatter release];
    return result;
}

+ (NSDate *)parseDateTime:(NSString *)dateTimeString {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *result = [formatter dateFromString:dateTimeString];
    [formatter release];
    return result;
}


+ (NSDate *)parseDate:(NSString *)dateTimeString {
	NSDateFormatter *formatter = [DateHelpers shortRailsDateFormatter];
	return [formatter dateFromString:dateTimeString];
	
}

+ (NSDateFormatter *)shortRailsDateFormatter {
	
	NSDateFormatter *railsFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[railsFormatter setDateFormat:@"yyyy-MM-dd"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[railsFormatter setLocale:forcedLocale];
	[forcedLocale release];
	[railsFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	return railsFormatter;
}


+ (NSDateFormatter *)railsDateFormatterWithTimeZone:(NSTimeZone *)timeZone  {

	NSDateFormatter *railsFormatter = [[[NSDateFormatter alloc] init]autorelease];
	[railsFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[railsFormatter setLocale:forcedLocale];
	[forcedLocale release];
	[railsFormatter setTimeZone:timeZone];
	return railsFormatter;
	
}

+ (NSDateFormatter *)sectionTitleDateFormatter {
	
	//Create the date formatter to create the section titles
	NSDateFormatter *dateFormatterForKeys = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatterForKeys setDateFormat:@"EEEE, d MMM yyyy"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[dateFormatterForKeys setLocale:forcedLocale];
	[forcedLocale release];
	[dateFormatterForKeys setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	return dateFormatterForKeys;

}

+ (NSDateFormatter *)shortDateFormatterInLocalTime {

	NSDateFormatter *shortDateFormat = [[[NSDateFormatter alloc] init]autorelease];
	[shortDateFormat setDateFormat:@"dd/MM/yyyy"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[shortDateFormat setLocale:forcedLocale];
	[forcedLocale release];
	[shortDateFormat setTimeZone:[NSTimeZone localTimeZone]];
	return shortDateFormat;
}

+ (NSDateFormatter *)shortDateFormatterInUTC {
	
	NSDateFormatter *shortDateFormat = [[[NSDateFormatter alloc] init]autorelease];
	[shortDateFormat setDateFormat:@"dd/MM/yyyy"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[shortDateFormat setLocale:forcedLocale];
	[forcedLocale release];
	[shortDateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	return shortDateFormat;
}



+ (NSDateFormatter *)shortTimeFormatterInLocalTime {

	NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init]autorelease];
	[timeFormat setDateFormat:@"HH:mm:ss"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[timeFormat setLocale:forcedLocale];
	[forcedLocale release];
	
	[timeFormat setTimeZone:[NSTimeZone localTimeZone]];
	return timeFormat;
	
}

+ (NSDateFormatter *)shortMonthNameInLocalTime {

	NSDateFormatter *dateFormatterForMonth = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatterForMonth setDateFormat:@"MMM"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[dateFormatterForMonth setLocale:forcedLocale];
	[forcedLocale release];
	[dateFormatterForMonth setTimeZone:[NSTimeZone localTimeZone]];
	
	return dateFormatterForMonth;
	
}

+ (NSDateFormatter *)dayNumberInLocalTime {
	
	NSDateFormatter *dateFormatterForDay = [[[NSDateFormatter alloc] init]autorelease];
	[dateFormatterForDay setDateFormat:@"d"];
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[dateFormatterForDay setLocale:forcedLocale];
	[forcedLocale release];
	[dateFormatterForDay setTimeZone:[NSTimeZone localTimeZone]];
	return dateFormatterForDay;

}

+ (TimeEntryFormatter *)timetableTimeFormatter {
	
	TimeEntryFormatter *timeFormat = [[[TimeEntryFormatter alloc] init]autorelease];
	
	[timeFormat setTimeStyle:NSDateFormatterShortStyle];
	[timeFormat setDateFormat:@"k:mm"];
	
	NSLocale *forcedLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
	[timeFormat setLocale:forcedLocale];
	[forcedLocale release];
	
	[timeFormat setTimeZone:[NSTimeZone localTimeZone]];
	return timeFormat;
	
}

/*
 
 
 // Returns time string in 24-hour mode from the given NSDate
 +(NSString *)time24FromDate:(NSDate *)date withTimeZone:(NSTimeZone *)timeZone
 {
 NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"HH:mm"];
 [dateFormatter setTimeZone:timeZone];
 NSString* time = [dateFormatter stringFromDate:date];
 [dateFormatter release];
 
 if (time.length > 5) {
 NSRange range;
 range.location = 3;
 range.length = 2;
 int hour = [[time substringToIndex:2] intValue];
 NSString *minute = [time substringWithRange:range];
 range = [time rangeOfString:@"AM"];
 if (range.length==0)
 hour += 12;
 time = [NSString stringWithFormat:@"%02d:%@", hour, minute];
 }
 
 return time;
 }

 
// Returns a proper NSDate given a time string in 24-hour mode
+(NSDate *)dateFromRailsTime24:(NSString *)time24String withTimeZone:(NSTimeZone *)timeZone
{
	int hour = [[time24String substringToIndex:2] intValue];
	int minute = [[time24String substringFromIndex:3] intValue];
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:timeZone];	
	
	NSDate *result;
	if ([Util userSetTwelveHourMode]) {
		[dateFormatter setDateFormat:@"hh:mm aa"];
		if (hour > 12) {
			result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d PM", hour - 12, minute]];
		} else {
			result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d AM", hour, minute]];
		}
	} else {
		[dateFormatter setDateFormat:@"HH:mm"];
		result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d", hour, minute]];
	}
	[dateFormatter release];
	
	return result;
}

// Returns a proper NSDate given a time string in 24-hour mode
+(NSDate *)dateFromTime24:(NSString *)time24String withTimeZone:(NSTimeZone *)timeZone
{
	int hour = [[time24String substringToIndex:2] intValue];
	int minute = [[time24String substringFromIndex:3] intValue];
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:timeZone];	
	
	NSDate *result;
	if ([Util userSetTwelveHourMode]) {
		[dateFormatter setDateFormat:@"hh:mm aa"];
		if (hour > 12) {
			result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d PM", hour - 12, minute]];
		} else {
			result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d AM", hour, minute]];
		}
	} else {
		[dateFormatter setDateFormat:@"HH:mm"];
		result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d", hour, minute]];
	}
	[dateFormatter release];
	
	return result;
}

// Tests whether the user has set the 12-hour or 24-hour mode in their settings.
+(BOOL)userSetTwelveHourMode
{
	NSDateFormatter *testFormatter = [[NSDateFormatter alloc] init];
	[testFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *testTime = [testFormatter stringFromDate:[NSDate date]];
	[testFormatter release];
	return [testTime hasSuffix:@"M"] || [testTime hasSuffix:@"m"];
}

// Converts a 24-hour time string to 12-hour time string
+(NSString *)time12FromTime24:(NSString *)time24String
{
	NSDateFormatter *testFormatter = [[NSDateFormatter alloc] init];
	int hour = [[time24String substringToIndex:2] intValue];
	int minute = [[time24String substringFromIndex:3] intValue];
	
	NSString *result = [NSString stringWithFormat:@"%02d:%02d %@", hour % 12, minute, hour > 12 ? [testFormatter PMSymbol] : [testFormatter AMSymbol]];
	[testFormatter release];
	return result;
}
*/
@end
