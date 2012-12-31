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

@property (strong, nonatomic) AVPlayer *audioPlayer;
@property BOOL heighStreamQuality;
@property BOOL firstLaunch;

@end

@implementation WebRadioStream
@synthesize delegate = _delegate;
@synthesize audioPlayer = _audioPlayer;
@synthesize heighStreamQuality = _heighStreamQuality;
@synthesize firstLaunch = _firstLaunch;

- (id)init
{
    self = [super init];
    if (self) {
        self.audioPlayer = [[AVPlayer alloc] init];
        self.firstLaunch = YES;
    }
    return self;
}

- (void)play
{
    [self.delegate.loadingActivity startAnimating];
    self.delegate.playButton.enabled = NO;
    self.delegate.loadingActivity.hidesWhenStopped = YES;
    [self.delegate.playButton setTitle:@"Loading..." forState:UIControlStateNormal];
    
    if (self.firstLaunch || [self.delegate isInHeighStream] != self.heighStreamQuality) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(playThread) object:nil];
        [thread start];
    } else {
        NSLog(@"PLAY... %@", self.audioPlayer);
        [self.audioPlayer play];
        [self update];
    }
}

- (void)playThread
{
    NSError *error = NULL;
    UIButton *button = self.delegate.playButton;
    
    if (self.audioPlayer && self.audioPlayer.rate == 0.0) {
        
        NSURL *streamURL;
        if ([self.delegate isInHeighStream]) {
            streamURL = [NSURL URLWithString:HIGH_STREAM_ADDRESS];
        } else {
            streamURL = [NSURL URLWithString:LOW_STREAM_ADDRESS];
        }
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: streamURL];
        [request setHTTPMethod: @"HEAD"];
        NSURLResponse *response;
        NSData *myData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
        
        
        if (myData && !error) {
            self.firstLaunch = NO;
            self.heighStreamQuality = [self.delegate isInHeighStream];
            
            // we are probably reachable, check the response;
            AVPlayerItem *newPlayer;
            newPlayer = [AVPlayerItem playerItemWithURL:streamURL];
            [self.audioPlayer replaceCurrentItemWithPlayerItem:newPlayer];
            
            [self.audioPlayer play];
            
            button.backgroundColor = [UIColor colorWithRed:.1 green:.6 blue:.1 alpha:1.0];
            [button setTitle:@"Pause" forState:UIControlStateNormal];
            
        } else {
            NSLog(@"ERROR connecting to stream...\n%@", error);
            [self performSelectorOnMainThread:@selector(errorConnecting) withObject:nil waitUntilDone:NO];
            button.backgroundColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:1.0];
            [button setTitle:@"Error" forState:UIControlStateNormal];
        }
        
        [self.delegate.loadingActivity stopAnimating];
        self.delegate.playButton.enabled = YES;
    }
}

- (void)errorConnecting
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SORRY"
                                                        message:@"But I can not connect to the Junction11 stream...\nWe're probably not broadcasting right now (due to holidays or so)."
                                                       delegate:self
                                              cancelButtonTitle:@"Fair enough"
                                              otherButtonTitles:@"Tell the admin", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
 
    if (buttonIndex == 1)
    {
        NSLog(@"Tell Admin...");
        //do something here...
    }
}

- (BOOL)isPlaying
{
    return (self.audioPlayer.rate > 0.0);
}

- (void)pause
{
    if ([[self.delegate playButton] isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)[self.delegate playButton];
        if (self.audioPlayer && [self isPlaying]) {
            [self.audioPlayer pause];
        }
        button.backgroundColor = [UIColor colorWithRed:.9 green:.6 blue:.0 alpha:1.0];
        [button setTitle:@"Resume" forState:UIControlStateNormal];
        
    }
}

- (void)playAndResume
{
    
    if ([[self.delegate playButton] isKindOfClass:[UIButton class]]) {
        if ([self isPlaying]) {
            [self pause];
        } else {
            [self play];
        }
    }
    
}

- (void)remoteControlReceivedOfType:(UIEventSubtype)type
{
    NSLog(@"Control Received %i", type);
    if ([self.delegate playButton])
        switch (type) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playAndResume];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [self pause];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [self play];
                break;
                
            default:
                break;
        }
}

- (void)update
{
    if ([self isPlaying]) {
        [self.delegate playButton].backgroundColor = [UIColor colorWithRed:.1 green:.6 blue:.1 alpha:1.0];
        [[self.delegate playButton] setTitle:@"Pause" forState:UIControlStateNormal];
    } else {
        [self.delegate playButton].backgroundColor = [UIColor colorWithRed:.9 green:.6 blue:.0 alpha:1.0];
        [[self.delegate playButton] setTitle:@"Resume" forState:UIControlStateNormal];
    }
    [self.delegate.loadingActivity stopAnimating];
    self.delegate.playButton.enabled = YES;
}

@end
