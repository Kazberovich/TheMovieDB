//
//  MainViewCell.m
//  TheMovieDbClient
//
//  Created by mac-214 on 22.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "MainViewCell.h"

@implementation MainViewCell


@synthesize filmPoster = _filmPoster;
@synthesize filmGenre = _filmGenre;
@synthesize filmRating = _filmRating;
@synthesize filmYear = _filmYear;
@synthesize filmTitle = _filmTitle;
@synthesize posterUrl =_posterUrl;

- (void) dealloc
{
    [_posterUrl release];
    [_filmTitle release];
    [_filmYear release];
    [_filmPoster release];
    [_filmGenre release];
    [_filmRating release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.selectedBackgroundView.frame];
    [backgroundView setBackgroundColor:[UIColor grayColor]];
    [self setSelectedBackgroundView:backgroundView];
    
    [backgroundView release];
}

@end
