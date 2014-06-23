//
//  WatchlistHolder.h
//  TheMovieDbClient
//
//  Created by mac-214 on 21.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface WatchlistHolder : NSObject

+ (WatchlistHolder *) sharedInstance;
- (void) addFilm :(NSString *)film;
- (NSMutableArray *)getWatchListIDs;
- (void) deleteFilm:(NSString *)film;

@end
