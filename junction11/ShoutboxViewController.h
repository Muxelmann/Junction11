//
//  ShoutboxViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 29.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shoutbox.h"

@protocol ShoutboxDelegate;

@interface ShoutboxViewController : UIViewController

@property (nonatomic, assign) id<ShoutboxDelegate> delegate;

- (IBAction)codeUpdate:(id)sender;
- (IBAction)pushShout:(id)sender;
- (IBAction)shout:(id)sender;

@end

@protocol ShoutboxDelegate <NSObject>

- (IBAction)showShoutbox:(UISwipeGestureRecognizer *)recognizer;

@end
