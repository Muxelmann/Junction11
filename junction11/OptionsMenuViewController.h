//
//  OptionsMenuViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsViewController.h"

@interface OptionsMenuViewController : UIViewController <OptionViewDelegate>

@property (nonatomic, assign) id<OptionViewDelegate> delegate;

@end