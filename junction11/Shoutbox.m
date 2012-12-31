//
//  Shoutbox.m
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "Shoutbox.h"

#define URL @"http://gerfficient.com/app/mail.php"

@interface Shoutbox ()
@property NSInteger code;
@end

@implementation Shoutbox
@synthesize code = _code;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)newCode
{
    self.code = rand()%10;
}

- (NSInteger)getCode
{
    [self newCode];
    return self.code;
}

- (BOOL)shoutMessage:(NSString *)message byUser:(NSString *)user WithCode:(NSInteger)code
{
    if (code == self.code) {
        user = [user stringByAppendingFormat:@"via iOS version [%@] device [%@]", UIDevice.currentDevice.systemVersion, UIDevice.currentDevice.name];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL]];
        request.HTTPMethod = @"POST";
        
        NSString *values = [NSString stringWithFormat:@"person_name=%@&message=%@", user, message];
        NSData *body = [values dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = body;
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:[request copy] returningResponse:&response error:&err];
        
        NSLog(@"SENT");
        NSLog(@"RECEIVED: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        
        [self newCode];
        return YES;
    }
    
    [self newCode];
    return NO;
}

@end
