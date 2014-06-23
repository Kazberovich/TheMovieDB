//
//  SimilarMoviesView.m
//  TheMovieDbClient
//
//  Created by mac-214 on 12.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "SimilarMoviesView.h"
#import "ApiLoadService.h"
#import "DownloadHelper.h"
#import "ImageHelper.h"

@implementation SimilarMoviesView

@synthesize firstSMName = _firstSMName;
@synthesize firstSMPoster = _firstSMPoster;
@synthesize firstSMRating = _firstSMRating;
@synthesize secondSMName = _secondSMName;
@synthesize secondSMPoster = _secondSMPoster;
@synthesize secondSMRating = _secondSMRating;
@synthesize moreButton = _moreButton;
@synthesize stars1 =_stars1;
@synthesize stars2 =_stars2;

- (void) dealloc
{
    [_stars1 release];
    [_stars2 release];
    [_firstSMName release];
    [_firstSMPoster release];
    [_firstSMRating release];
    [_secondSMName release];
    [_secondSMPoster release];
    [_secondSMRating release];
    [_moreButton release];
    [super dealloc];
}

- (void) fillBlock:(NSDictionary*) fillInfo
{
    NSDictionary *similarMovies = [fillInfo objectForKey:@"results"];
    //NSLog(@"SimilarMovies: %@", similarMovies);
    _moreButton.hidden = YES;
    
    if([similarMovies count] < 1)
    {
        _stars1.hidden = YES;
        _stars2.hidden = YES;
        _firstSMName.text = @"";
        _firstSMRating.text = @"";
        _firstSMPoster.image = [UIImage imageNamed:@"poster.png"];
        _secondSMName.text = @"";
        _secondSMRating.text = @"";
        _secondSMPoster.image = [UIImage imageNamed:@"poster.png"];
        [ImageHelper setRoundedBorder:_firstSMPoster];
        [ImageHelper setRoundedBorder:_secondSMPoster];
    }
    else
    {
        int i = 0;
        for (id smObject in similarMovies) {
            NSLog(@"similar: %@", smObject);
            if (i >= 2) break;
            
            else if (i == 0 && ![[smObject objectForKey:@"poster_path"] isEqual:[NSNull null]] && ![[smObject objectForKey:@"vote_average"] isEqual:[NSNull null]])
            {
                _firstSMName.text = [smObject objectForKey:@"title"];
                _firstSMRating.text = ![[smObject objectForKey: @"vote_average"] isEqual:[NSNull null]] ? [[smObject objectForKey: @"vote_average"] stringValue] : @"no info";
                
                if(![[smObject objectForKey:@"poster_path"]isEqual:[NSNull null]])
                {
                    [ImageHelper laodFromURL:[DownloadHelper getImageURLWithShortcut:
                                              [smObject objectForKey:@"poster_path"]] callback:^(UIImage *image, NSURL *url) {
                        if (!image)
                        {
                            _firstSMPoster.image = [UIImage imageNamed:@"poster.png"];
                            [ImageHelper setRoundedBorder:_firstSMPoster];
                        }
                        else
                        {
                            _firstSMPoster.image = image;
                            [ImageHelper setRoundedBorder:_firstSMPoster];
                        }
                    }];
                }
            }
            else if (i == 1 && ![[smObject objectForKey:@"poster_path"] isEqual:[NSNull null]] && ![[smObject objectForKey:@"vote_average"] isEqual:[NSNull null]])
            {
                _secondSMName.text = [smObject objectForKey:@"title"];
                _secondSMRating.text = ![[smObject objectForKey: @"vote_average"] isEqual:[NSNull null]] ? [[smObject objectForKey: @"vote_average"] stringValue] : @"no info";
                
                if (![[smObject objectForKey:@"poster_path"]isEqual:[NSNull null]])
                {
                    [ImageHelper laodFromURL:[DownloadHelper getImageURLWithShortcut:
                                              [smObject objectForKey:@"poster_path"]] callback:^(UIImage *image, NSURL *url) {
                        if (!image)
                        {
                            _secondSMPoster.image = [UIImage imageNamed:@"poster.png"];
                            [ImageHelper setRoundedBorder:_secondSMPoster];
                        }
                        else
                        {
                            _secondSMPoster.image = image;
                            [ImageHelper setRoundedBorder:_secondSMPoster];
                        }
                    }];
                }
                else
                {
                    _secondSMPoster.image = [UIImage imageNamed:@"poster.png"];
                    [ImageHelper setRoundedBorder:_secondSMPoster];
                }
            }
            i++;
        }
    }
}

@end
