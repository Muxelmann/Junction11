//
//  ShowViewController.h
//  junction11
//
//  Created by Maximilian Zangs on 26.12.12.
//  Copyright (c) 2012 Maximilian J. Zangs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowViewDelegate;
@protocol ShowDataSource;

@interface ShowViewController : UITableViewController

@property (nonatomic, assign) id<ShowViewDelegate> delegate;
@property (nonatomic, assign) id<ShowDataSource> dataSource;

@end

@protocol ShowViewDelegate <NSObject>

- (BOOL)areNotificationsEnabled;

@end

@protocol ShowDataSource <NSObject>

- (NSString *)showTitle;
- (NSString *)showInfo;
- (NSString *)showDescription;
- (BOOL)showHasURL;
- (NSString *)showURL;

@end