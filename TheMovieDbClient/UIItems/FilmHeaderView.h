//
//  FilmHeaderView.h
//  TheMovieDbClient
//
//  Created by mac-214 on 04.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReviewFilm.h"
#define headerHeight 135.0

@interface FilmHeaderView : UIView

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *rating;
@property (nonatomic, retain) IBOutlet UIImageView *poster;
@property (nonatomic, retain) IBOutlet UILabel *duration;

- (void) fillHeader:(ReviewFilm*) film;
- (void) setFilmDuration :(NSString*) duration;

@end
