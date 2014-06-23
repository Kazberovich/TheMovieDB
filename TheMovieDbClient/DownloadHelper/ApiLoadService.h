//
//  ApiLoadService.h
//  TheMovieDbClient
//
//  Created by mac-214 on 10.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiLoadService : NSObject

+ (void) getResponseForURL: (NSURL*) url callback:(void (^)(NSDictionary *dictionary, NSURL *url)) callback;
+ (void) actionWithWatchlist: (BOOL) addOrRemove :(NSString*) filmId  callback:(void (^)(NSDictionary *dictionary)) callback;

@end
