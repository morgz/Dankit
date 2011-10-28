#import <Foundation/Foundation.h>
@class TimeEntryFormatter;

@interface DateHelpers : NSObject {
}

+ (NSString *)formatDate:(NSDate *)date;
+ (NSDate *)parseDateTime:(NSString *)dateTimeString;
+ (NSDate *)parseDate:(NSString *)dateTimeString;
//Date formatters
+ (NSDateFormatter *)shortRailsDateFormatter;
+ (NSDateFormatter *)railsDateFormatterWithTimeZone:(NSTimeZone *)timeZone;
+ (NSDateFormatter *)sectionTitleDateFormatter;
+ (NSDateFormatter *)shortDateFormatterInUTC;
+ (NSDateFormatter *)shortDateFormatterInLocalTime;
+ (NSDateFormatter *)shortTimeFormatterInLocalTime;
+ (NSDateFormatter *)shortMonthNameInLocalTime;
+ (NSDateFormatter *)dayNumberInLocalTime;

+ (TimeEntryFormatter *)timetableTimeFormatter;


@end
