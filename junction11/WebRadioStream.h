//
//  WebRadioStream.h
//  junction11
//
//  Created by Maximilian Zangs on 28.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebPlayerDelegate;

@interface WebRadioStream : NSObject

@property (nonatomic, assign) id<WebPlayerDelegate> delegate;

- (BOOL)isPlaying;
- (void)pause;
- (void)remoteControlReceivedOfType:(UIEventSubtype)type;
- (void)update;

- (void)playAndResume;

@end

@protocol WebPlayerDelegate <NSObject>

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivity;

- (BOOL)isInHeighStream;
- (void)presentMailForAdminNotificationOfError:(NSError *)error;

@end