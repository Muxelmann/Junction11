//
//  Shoutbox.h
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shoutbox : NSObject

- (BOOL)shoutMessage:(NSString *)message byUser:(NSString *)user WithCode:(NSInteger)code;
- (NSInteger)getCode;

@end