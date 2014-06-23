//
//  SearchViewCell.m
//  TheMovieDbClient
//
//  Created by mac-214 on 24.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "SearchViewCell.h"

@implementation SearchViewCell

@synthesize filmPoster = _filmPoster;
@synthesize filmRating = _filmRating;
@synthesize filmYear = _filmYear;
@synthesize filmTitle = _filmTitle;

- (void) dealloc
{
    [_filmTitle release];
    [_filmYear release];
    [_filmRating release];
    [_filmPoster release];
    [super dealloc];
}

@end
