//
//  MainViewController.h
//  TheMovieDbClient
//
//  Created by mac-214 on 22.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkStatusHelper.h"

@class Reachability;


@interface MainViewController : UIViewController <NetworkStatusDelegate>

@property (nonatomic, retain) IBOutlet UITableView* sampleTableView;
@property (nonatomic, retain) IBOutlet UIView *unAuthorizedView;
@property (nonatomic, retain) IBOutlet UIView *emptyWatchlistView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UILabel *networkStatus;
@property (nonatomic, retain) NSMutableArray *filmList;

//@property (nonatomic, retain) Reachability *reachability;

@end
