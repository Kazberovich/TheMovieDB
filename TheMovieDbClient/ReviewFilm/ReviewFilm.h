//
//  ReviewFilm.h
//  TheMovieDbClient
//
//  Created by mac-214 on 31.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReviewFilm : NSObject
{
    NSString *filmId;
    NSString *title;
    NSString *rating;
    NSString *posterPath;
    NSString *year;
    UIImage *posterImage;
    NSString *duration;
    
    NSArray *actorsList;
    NSArray *genreList;
    NSArray *backdropsList;
    NSArray *similarMovies;
    
}

+ (NSMutableArray*) initWithDictionary: (NSDictionary*)dictionary;

@property (nonatomic, retain) NSString *filmId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSString *posterPath;
@property (nonatomic, retain) NSString *yearRelease;
@property (nonatomic, retain) UIImage *posterImage;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSArray *actorsList;
@property (nonatomic, retain) NSArray *genreList;
@property (nonatomic, retain) NSArray *backdropsList;
@property (nonatomic, retain) NSArray *similarMovies;


@end
