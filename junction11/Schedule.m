//
//  Schedule.m
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "Schedule.h"

#define DATA_URL @"http://junction11.rusu.co.uk/customscripts/ios_v2.php"

@interface Schedule ()
@property (strong, nonatomic) NSMutableArray *schedule;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (nonatomic) BOOL scheduleHasLoaded;
@end

@implementation Schedule
@synthesize schedule = _schedule;
@synthesize gregorian = _gregorian;
@synthesize scheduleHasLoaded = _scheduleHasLoaded;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialisation code where the schedule is filled wish shows
        self.schedule = [[NSMutableArray alloc] init];
        self.gregorian = [NSCalendar currentCalendar];
        self.scheduleHasLoaded = NO;
    }
    return self;
}

- (void)update
{
    // Prevent reloading if unecessary
    if (self.scheduleHasLoaded) return;
    
    [self.schedule removeAllObjects];
    
    // Sets URL from where to load the XML data
    NSString *url = DATA_URL;
    
    // Loads data and strores it in string
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *scheduleString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //    NSArray *removeString = [[NSArray alloc] initWithObjects:@"\t", @"\n", @"\r", @"&lt;h1&gt;", @"&lt;/h1&gt;", nil];
    
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"<h1>" withString:@""];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"<h2>" withString:@""];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"</h1>" withString:@"\n\n"];
    scheduleString = [scheduleString stringByReplacingOccurrencesOfString:@"</h2>" withString:@"\n"];
    
    //    NSLog(@"DATA: %@", schedule);
    
    // Removes any comments from string (HTML comments are within "<?" and "?>")
    NSRange commentBeginsRange = [scheduleString rangeOfString:@"<?"];
    while (commentBeginsRange.location != NSNotFound) {
        
        NSRange commentEndRange = [scheduleString rangeOfString:@"?>"];
        NSString *beforeComment = [scheduleString substringToIndex:commentBeginsRange.location];
        NSString *afterComment = [scheduleString substringFromIndex:(commentEndRange.location + commentEndRange.length)];
        
        scheduleString = [beforeComment stringByAppendingString:afterComment];
        
        commentBeginsRange = [scheduleString rangeOfString:@"<?"];
    }
    
//    NSLog(@"DATA: %@", scheduleString);
    
    
    // Find the entries and extract them into a temporary Array
    NSRange entryBeginsRange = [scheduleString rangeOfString:@"<entry>"];
    while (entryBeginsRange.location != NSNotFound) {
        
        NSRange entryEndsRange = [scheduleString rangeOfString:@"</entry>"];
        
        NSRange entryRange;
        entryRange.location = entryBeginsRange.location + entryBeginsRange.length;
        entryRange.length = entryEndsRange.location - entryRange.location;
        
        NSString *entry = [scheduleString substringWithRange:entryRange];
        
//        NSLog(@"ENTRY: %@", entry);
        
        [self.schedule addObject:entry];
        
        scheduleString = [scheduleString substringFromIndex:(entryEndsRange.location + entryEndsRange.length)];
        entryBeginsRange = [scheduleString rangeOfString:@"<entry>"];
    }
    
    // Replaces "data" entries with entries split up into NSDictionary
    NSArray *beginKey = [[NSArray alloc] initWithObjects:@"<name>", @"<day>", @"<time>", @"<duration>", @"<description>", @"<url>", nil];
    NSArray *endKey = [[NSArray alloc] initWithObjects:@"</name>", @"</day>", @"</time>", @"</duration>", @"</description>", @"</url>", nil];
    
    for (NSInteger i = 0; i < [self.schedule count]; i++) {
        NSString *entryString = [self.schedule objectAtIndex:i];
        
        NSMutableArray *entryObjects = [[NSMutableArray alloc] init];
        NSRange range, beginsRange, endsRange;
        NSString *entry;
        
        for (NSInteger e = 0; e < [beginKey count]; e++) {
            
            beginsRange = [entryString rangeOfString:[beginKey objectAtIndex:e]];
            endsRange = [entryString rangeOfString:[endKey objectAtIndex:e]];
            
            range.location = beginsRange.location + beginsRange.length;
            range.length = endsRange.location - range.location;
            
            entry = [entryString substringWithRange:range];
            
            [entryObjects insertObject:entry atIndex:[entryObjects count]];
        }
        
        NSDictionary *entryDictionary = [[NSDictionary alloc] initWithObjects:entryObjects forKeys:beginKey];
        [self.schedule replaceObjectAtIndex:i withObject:entryDictionary];
        
    }
    
    self.scheduleHasLoaded = YES;
    
//    NSLog(@"Schedule:\n%@", self.schedule);
}

- (NSInteger)numberOfDaysInSchedule
{
//    if (!self.scheduleHasLoaded)
//        return 1;
    
    // The week always has 7 days
    return 7;
}

- (NSString *)nameForDay:(NSInteger)day
{
    if (!self.scheduleHasLoaded)
        return @"Loading...";
    
    day += self.gregorian.firstWeekday;
    day = (day > 7) ? day - 7 : day;
    switch (day) {
        case 1:
            return @"Sunday";
        case 2:
            return @"Monday";
        case 3:
            return @"Tuesday";
        case 4:
            return @"Wednesday";
        case 5:
            return @"Thursday";
        case 6:
            return @"Friday";
        case 7:
            return @"Saturday";
    }
    return @"Next day";
}

- (NSInteger)numberOfShowsPerDay:(NSInteger)day
{
    if (!self.scheduleHasLoaded)
        return 1;
    
    NSInteger showCounter = 0;
    day += self.gregorian.firstWeekday;
    day = (day > 7) ? day - 7 : day;
    
    for (int i = 0; i < [self.schedule count]; i++) {
        // The safe way
//        if ([[self.schedule objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *entry = (NSDictionary *)[self.schedule objectAtIndex:i];
//            if ([[entry objectForKey:@"<day>"] intValue] == day)
//                showCounter++;
//        }
        
        // The less safe way
        if ([[(NSDictionary *)[self.schedule objectAtIndex:i] objectForKey:@"<day>"] intValue] == day)
            showCounter++;
    }
    
    return showCounter;
}

- (NSString *)titleForShow:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
    
//    NSLog(@"numberOfPastShows+show = %i", numberOfPastShows+show);

    NSString *title = [[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<name>"];
    if ([title isKindOfClass:[NSString class]])
        return title;

        
    return @"Title not found";
}

- (NSDate *)startingTimeOfShow:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
    
    float time = [[[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<time>"] floatValue];
    
    // Compute now and the calendar used
    NSDate *nowDate = [NSDate date];
    //    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *now = [self.gregorian components:NSWeekdayCalendarUnit fromDate:nowDate];
    
    // Find out how many components differ between the beginning and now
    NSDateComponents *differenceToBeginningOfWeek = [[NSDateComponents alloc] init];
    //    [differenceToBeginningOfWeek setDay: - ([now weekday] - [gregorian firstWeekday])];
    differenceToBeginningOfWeek.day = - (now.weekday - self.gregorian.firstWeekday);
    
    // Compute the beginning of the week and normalise time to zero.
    NSDate *beginningOfWeek = [self.gregorian dateByAddingComponents:differenceToBeginningOfWeek toDate:nowDate options:0];
    NSDateComponents *components = [self.gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate: beginningOfWeek];
    beginningOfWeek = [self.gregorian dateFromComponents: components];
    
    NSDateComponents *startDifference = [[NSDateComponents alloc] init];
    //    startDifference.hour = (NSInteger)time;
    
    startDifference.minute = time * 60;
    startDifference.day = day;
    
    return [self.gregorian dateByAddingComponents:startDifference toDate:beginningOfWeek options:0];
}

- (NSDate *)endingTimeOfShow:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
    
    NSDate *start = [self startingTimeOfShow:show onDay:day];
    
    float duration = [[[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<duration>"] floatValue];
    
    NSDateComponents *endDifference = [[NSDateComponents alloc] init];
    
    //    endDifference.hour = (NSInteger)duration;
    endDifference.minute = duration * 60;
    
    return [self.gregorian dateByAddingComponents:endDifference toDate:start options:0];
}

- (NSString *)infoForShow:(NSInteger)show onDay:(NSInteger)day
{
    
    NSDate *start = [self startingTimeOfShow:show onDay:day];
    NSDate *end = [self endingTimeOfShow:show onDay:day];
    
    NSString *returnString = [[NSString alloc] init];
    returnString = [returnString stringByAppendingString:[NSDateFormatter localizedStringFromDate:start dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    returnString = [returnString stringByAppendingString:@" to "];
    returnString = [returnString stringByAppendingString:[NSDateFormatter localizedStringFromDate:end dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    
    return returnString;
    
}

- (NSString *)descriptionForShow:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
    NSString *description = [[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<description>"];
    
    if ([description isEqualToString:@""])
        return @"No description available";
    else
        return description;
}

- (BOOL)isLinkWithShow:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
    
    NSString *url = [[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<url>"];
//    NSLog(@"URL = %i", [url isEqualToString:@""]);
    return ![url isEqualToString:@""];
}

- (BOOL)isFacebookLinkWithShow:(NSInteger)show onDay:(NSInteger)day
{
    if ([self isLinkWithShow:show onDay:day]) {
        NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
        
        NSString *url = [[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<url>"];
        //    NSLog(@"URL = %i", [url isEqualToString:@""]);
        return ([url rangeOfString:@"facebook"].location != NSNotFound);
    }
    return NO;
}


- (NSString *)urlForShow:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = [self numberOfShowsBefore:show onDay:day];
    
    NSString *url = [[self.schedule objectAtIndex:numberOfPastShows+show] objectForKey:@"<url>"];
    
    if ([url isEqualToString:@""])
        return @"No link given";
    else
        return url;
    
}

- (NSInteger)numberOfShowsBefore:(NSInteger)show onDay:(NSInteger)day
{
    NSInteger numberOfPastShows = 0;
    for (int i = (day + self.gregorian.firstWeekday - 1); i > 0; i--) {
        numberOfPastShows += [self numberOfShowsPerDay:(i - self.gregorian.firstWeekday)];
//        NSLog(@"[%i -> %i], %i", i, i - self.gregorian.firstWeekday, [self numberOfShowsPerDay:(i - self.gregorian.firstWeekday)]);
    }
//    NSLog(@"numberOfPastShows+show = %i", numberOfPastShows+show);
    numberOfPastShows = (numberOfPastShows < [self.schedule count]) ? numberOfPastShows : numberOfPastShows - [self.schedule count];
    
    return numberOfPastShows;
}

- (NSDate *)notifyTimeOfMinutes:(NSInteger)minutes beforeShow:(NSInteger)show onDay:(NSInteger)day
{
    NSDate *start = [self startingTimeOfShow:show onDay:day];
    
    NSDateComponents *differenceToNotification = [[NSDateComponents alloc] init];
    differenceToNotification.minute = -minutes;
    
    return [self.gregorian dateByAddingComponents:differenceToNotification toDate:start options:0];
    
}

- (NSString *)currentShow
{
    if ([self.schedule count] == 0) [self update];
    
    NSDate *now = [NSDate date];

    for (int d = 0; d < 7; d ++) {
        for (int s = 0; s < [self numberOfShowsPerDay:d]; s++) {
            NSDate *start = [self startingTimeOfShow:s onDay:d];
            NSDate *finish = [self endingTimeOfShow:s onDay:d];
            
            if ([start compare:now] == NSOrderedAscending && [now compare:finish] == NSOrderedAscending) {
                return [self titleForShow:s onDay:d];
            }
        }
    }

    return @"Don't know what's playing...";
}

- (NSString *)nextShow
{
    if ([self.schedule count] == 0) [self update];
    
    NSDate *now = [NSDate date];
    
    for (int d = 0; d < 7; d ++) {
        for (int s = 0; s < [self numberOfShowsPerDay:d]; s++) {
            NSDate *start = [self startingTimeOfShow:s onDay:d];
            NSDate *finish = [self endingTimeOfShow:s onDay:d];
            
            if ([start compare:now] == NSOrderedAscending && [now compare:finish] == NSOrderedAscending) {
                s++;
                if (s == [self numberOfShowsPerDay:d]-1) {
                    // Last show of the day, add 1 to day and reset show ot 0
                    d++;
                    s = 0;
                    if (d >= 7) {
                        // Last show of week, reset day to 0
                        d = 0;
                    }
                }
                return [self titleForShow:s onDay:d];
            }
        }
    }
    
    return @"Don't know what's playing next...";
}


@end
