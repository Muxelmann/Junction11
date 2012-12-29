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

//- (NSError *)play;
- (BOOL)isPlaying;
- (void)pause:(id)sender;
- (void)remoteControlReceivedOfType:(UIEventSubtype)type;
//- (void)resume;

- (void)playAndResume:(id)sender;

@end

@protocol WebPlayerDelegate <NSObject>

@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (BOOL)isInHeighStream;

@end