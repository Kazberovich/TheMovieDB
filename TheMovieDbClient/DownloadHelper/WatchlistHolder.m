//
//  WatchlistHolder.m
//  TheMovieDbClient
//
//  Created by mac-214 on 21.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "WatchlistHolder.h"

@implementation WatchlistHolder

static WatchlistHolder *sWatchlistHolder = nil;
static NSMutableArray *array;

+ (WatchlistHolder *) sharedInstance
{
    @synchronized(self)
    {
        if (sWatchlistHolder == nil)
        {
            array = [[NSMutableArray alloc] init];
            sWatchlistHolder = [NSAllocateObject([self class], 0, NULL) init];
        }
    }
    return sWatchlistHolder;
}

- (NSMutableArray *)getWatchListIDs
{
    return array;
}

- (void) addFilm :(NSString *)film
{
    [array addObject:film];
    NSLog(@"mutable array: %@", array);
}

- (void) deleteFilm:(NSString *)film
{
    [array removeObject:film];
}


- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (id) autorelease
{
    return self;
}

@end
