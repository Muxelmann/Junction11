//
//  MainView.h
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainCommunicationDelegate;

@interface MainView : UIView

@property (nonatomic, assign) id<MainCommunicationDelegate> delegate;

- (BOOL)enableFirstResponder;
- (BOOL)disableFirstResponder;

@end

@protocol MainCommunicationDelegate <NSObject>

- (void)remoteControlReceivedWithEvent:(UIEvent *)event;
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (BOOL)canBecomeFirstResponder;
- (BOOL)canResignFirstResponder;

@end