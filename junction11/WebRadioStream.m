//
//  WebRadioStream.m
//  junction11
//
//  Created by Maximilian Zangs on 28.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import "WebRadioStream.h"
#import <AVFoundation/AVFoundation.h>

#define LOW_STREAM_ADDRESS @"http://stream.junction11radio.co.uk:8080/j11_LQ"
#define HIGH_STREAM_ADDRESS @"http://stream.junction11radio.co.uk:8080/j11_stream"

#define TEST_ADDRESS_ONE @"http://87.230.101.12:80"
#define TEST_ADDRESS_TWO @"http://edge.live.mp3.mdn.newmedia.nacamar.net/ps-egofm_192/livestream.mp3"

@interface WebRadioStream ()

@property (strong, nonatomic) id controlButton;
@property (strong, nonatomic) AVPlayer *audioPlayer;
@property BOOL heighStreamQuality;

@end

@implementation WebRadioStream
@synthesize delegate = _delegate;
@synthesize controlButton = _controlButton;
@synthesize audioPlayer = _audioPlayer;
@synthesize heighStreamQuality = _heighStreamQuality;

- (id)init
{
    self = [super init];
    if (self) {
        self.audioPlayer = [[AVPlayer alloc] init];
    }
    return self;
}

- (void)setDelegate:(id<WebPlayerDelegate>)delegate
{
    _delegate = delegate;
}

- (NSError *)play:(id)sender
{
    if (!self.controlButton) self.controlButton = sender;
    
    NSError *error = NULL;
    
    if ([self.controlButton isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.controlButton;
    
        if (self.audioPlayer && self.audioPlayer.rate == 0.0) {
        
            NSURL *streamURL;
            if ([self.delegate isInHeighStream]) {
                streamURL = [NSURL URLWithString:TEST_ADDRESS_ONE];
                self.heighStreamQuality = YES;
            } else {
                streamURL = [NSURL URLWithString:TEST_ADDRESS_TWO];
                self.heighStreamQuality = NO;
            }
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: streamURL];
            [request setHTTPMethod: @"HEAD"];
            NSURLResponse *response;
            NSData *myData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
            
            if (myData) {
                // we are probably reachable, check the response;
                AVPlayerItem *newPlayer;
                NSLog(@"QUAL %i", [self.delegate isInHeighStream]);
                newPlayer = [AVPlayerItem playerItemWithURL:streamURL];
                [self.audioPlayer replaceCurrentItemWithPlayerItem:newPlayer];
                
                [self.audioPlayer play];
            }
        }
        
        if (!error) {
            button.backgroundColor = [UIColor colorWithRed:.1 green:.6 blue:.1 alpha:1.0];
            [button setTitle:@"Pause" forState:UIControlStateNormal];
        } else
            button.backgroundColor = [UIColor blackColor];
    }
    return error;
}

- (BOOL)isPlaying
{
    return (self.audioPlayer.rate > 0.0);
}

- (void)pause:(id)sender
{
    if (!self.controlButton) self.controlButton = sender;
    
    if ([self.controlButton isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.controlButton;
        if (self.audioPlayer && [self isPlaying]) {
            [self.audioPlayer pause];
        }
        button.backgroundColor = [UIColor colorWithRed:.9 green:.6 blue:.0 alpha:1.0];
        [button setTitle:@"Resume" forState:UIControlStateNormal];
        
    }
}

- (void)playAndResume:(id)sender
{
    if (!self.controlButton) self.controlButton = sender;
    
    if ([self.controlButton isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.controlButton;
        if ([self isPlaying]) {
            [self pause:button];
        } else {
            NSError *error = [self play:button];
            if (error) NSLog(@"ERROR %@", error);
        }
    }

}

- (void)remoteControlReceivedOfType:(UIEventSubtype)type
{
    NSLog(@"Control Received %i", type);
    if (self.controlButton)
    switch (type) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self playAndResume:self.controlButton];
            break;
            
        case UIEventSubtypeRemoteControlPause:
            [self pause:self.controlButton];
            break;
            
        case UIEventSubtypeRemoteControlPlay:
            [self play:self.controlButton];
            break;
            
        default:
            break;
    }
}

@end
