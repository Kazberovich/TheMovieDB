//
//  ReviewFilm.m
//  TheMovieDbClient
//
//  Created by mac-214 on 31.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "ReviewFilm.h"

@implementation ReviewFilm

@synthesize title = _title;
@synthesize rating = _rating;
@synthesize posterPath = _posterPath;
@synthesize yearRelease = _year;
@synthesize posterImage = _image;
@synthesize filmId = _filmId;
@synthesize duration = _duration;
@synthesize actorsList = _actorsList;
@synthesize backdropsList = _backdropsList;
@synthesize similarMovies = _similarMovies;
@synthesize genreList = _genreList;

- (void) dealloc
{
    [_duration release];
    [_actorsList release];
    [_backdropsList release];
    [_similarMovies release];
    [_genreList release];
    [_filmId release];
    [_image release];
    [_title release];
    [_rating release];
    [_posterPath release];
    [_year release];
    
    [super dealloc];
}

+ (NSMutableArray*) initWithDictionary: (NSDictionary*)dictionary
{
    NSMutableArray* filmArray = [[[NSMutableArray alloc]init] autorelease];
    
    for(id object in [dictionary objectForKey:@"results"])
    {
        ReviewFilm* newFilm = [[ReviewFilm alloc]init];
        
        [newFilm setFilmId:[[object objectForKey:@"id"] stringValue]];
        [newFilm setTitle: [object objectForKey:@"title"]];
        [newFilm setRating: [[object objectForKey:@"vote_average"] stringValue]];
        [newFilm setPosterPath: [object objectForKey:@"poster_path"]];
        [newFilm setYearRelease:[object objectForKey:@"release_date"]];
        
        [filmArray addObject:newFilm];
        [newFilm release];
    }
    return filmArray;
}

@end
