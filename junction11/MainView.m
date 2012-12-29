//
//  MainView.m
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"CONT %@", self.delegate);
    [self.delegate remoteControlReceivedWithEvent:event];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"MOT %@", self.delegate);
    [self.delegate motionBegan:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
//    return [self.delegate canBecomeFirstResponder];
}

//- (BOOL)canResignFirstResponder
//{
//    return YES;
////    return [self.delegate canBecomeFirstResponder];
//}

// When called makes this class first responder
// Means it can be controlled by iPod controlls
- (BOOL)enableFirstResponder {
    NSLog(@"ENABLE");
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
//    NSLog(@"WIN: %@", keyWindow);
//    NSLog(@"1st: %@", firstResponder);
//    
//    NSLog(@"MY WIN: %@", self.window);
    
    if (self.canBecomeFirstResponder) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        BOOL first = [self becomeFirstResponder];
        NSLog(@"FIRST : %i", first);
        return first;
    } else
        NSLog(@"NO CAN DO");
    NSLog(@"NO BEC 1st");
    return NO;
}

// When called, this class in NOT first responder anymore
// Means it can NOT be controlled by iPod controlls
- (BOOL)disableFirstResponder {
    
	if (self.canResignFirstResponder) {
		[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
		return [self resignFirstResponder];
	} else
        NSLog(@"NO CAN DO");
    NSLog(@"NO DIS 1st");
    return NO;
}

@end
