//
//  Shoutbox.h
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>

// This object sends messages to the studio for communication over the "shoutbox"
@interface Shoutbox : NSObject

- (BOOL)shoutMessage:(NSString *)message byUser:(NSString *)user WithCode:(NSInteger)code;
- (NSInteger)getCode;

@end