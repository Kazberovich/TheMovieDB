//
//  FilmHeaderView.m
//  TheMovieDbClient
//
//  Created by mac-214 on 04.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "FilmHeaderView.h"
#import "ImageHelper.h"

@implementation FilmHeaderView : UIView

@synthesize title = _title;
@synthesize date = _date;
@synthesize rating = _rating;
@synthesize poster = _poster;
@synthesize duration = _duration;

- (void) dealloc
{
    [_poster release];
    [_date release];
    [_rating release];
    [_title release];
    [super dealloc];
}

- (void) setFilmDuration :(NSString*) duration
{
    if(duration)
    {
        _duration.text = duration;
    }
    else
    {
        _duration.hidden = YES;
    }
}

- (void) fillHeader:(ReviewFilm*) film
{
    _title.text = [film title];
    [_title sizeToFit];
    _date.text = [film yearRelease];
    _rating.text = [film rating];
    
    if (! [film posterImage]) {
        [_poster setImage:[UIImage imageNamed:@"poster.png"]];
        [ImageHelper setRoundedBorder:_poster];
    }
    else
    {
        [ImageHelper setRoundedBorder:_poster];
        [_poster setImage:[film posterImage]];
    }
}

@end
