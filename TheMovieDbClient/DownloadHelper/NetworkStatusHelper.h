//
//  NetworkStatusHelper.h
//  TheMovieDbClient
//
//  Created by mac-214 on 21.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;
@protocol NetworkStatusDelegate;

@interface NetworkStatusHelper : NSObject

@property (retain, nonatomic) Reachability *reachability;
@property (nonatomic, retain) id <NetworkStatusDelegate> delegate;
@property (nonatomic, assign) BOOL isNetworkConnection;

+ (NetworkStatusHelper *) sharedInstance;
+ (BOOL) isInternetActive;

@end


@protocol NetworkStatusDelegate

@required
- (void) statusWasChanged: (NetworkStatusHelper*)helper;

@end
