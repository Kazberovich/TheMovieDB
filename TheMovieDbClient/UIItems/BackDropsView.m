//
//  BackDropsView.m
//  TheMovieDbClient
//
//  Created by mac-214 on 05.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "BackDropsView.h"
#import "ImageHelper.h"
#import "NetworkStatusHelper.h"

#define imageBaseUrl @"http://image.tmdb.org/t/p/w500"


@implementation BackDropsView : UIView

@synthesize firstImage = _firstImage;
@synthesize secondImage = _secondImage;
@synthesize moreButton = _moreButton;

- (void) dealloc
{
    [_moreButton release];
    [_firstImage release];
    [_secondImage release];
    [super dealloc];
}

- (void) setFirstImageFromUrl:(UIImage *)firstImage
{
    _firstImage.image = firstImage;
}

- (void) setSecondImageFromUrl:(UIImage *)secondImage
{
    _secondImage.image = secondImage;
}

- (void) fillBlock:(NSDictionary*) images
{
    _moreButton.hidden = YES;
    
    if ([NetworkStatusHelper isInternetActive]) {
        
    }
    
    
    NSDictionary *imgs = [images objectForKey:@"backdrops"];
    NSLog(@"Backdrops count: %d", [imgs count]);

    if ([imgs count] < 1) {
        _firstImage.image = [UIImage imageNamed:@"poster.png"];
        [ImageHelper setRoundedBorder:_firstImage];
        _secondImage.image = [UIImage imageNamed:@"poster.png"];
        [ImageHelper setRoundedBorder:_secondImage];
    }
    else
    {
        int j = 0;
        for(id i in imgs)
        {
            NSLog(@"backdrops: %@", i);
            if (j < 2)
            {
                if(j == 1 && ![[i objectForKey:@"file_path"]isEqual:[NSNull null]])
                {
                    NSURL *url = [NSURL URLWithString:[imageBaseUrl stringByAppendingString:[i objectForKey:@"file_path"]]];
                    [ImageHelper laodFromURL:url callback:^(UIImage *image, NSURL *url) {
                        
                        if ([NetworkStatusHelper isInternetActive])
                        {
                            if ([image isEqual:[NSNull null] ] || !url) {
                                _secondImage.image = [UIImage imageNamed:@"poster.png"];
                                [ImageHelper setRoundedBorder:_secondImage];
                            }
                            else
                            {
                                _secondImage.image = image;
                                [ImageHelper setRoundedBorder:_secondImage];
                            }
                        }
                        else
                        {
                            _secondImage.image = [UIImage imageNamed:@"poster.png"];
                            [ImageHelper setRoundedBorder:_secondImage];
                        }
                    }];
                    NSLog(@"2 = %@", [i objectForKey:@"file_path"]);
                }
                
                if (j == 0 && ![[i objectForKey:@"file_path"]isEqual:[NSNull null]])
                {
                    NSURL *url = [NSURL URLWithString:[imageBaseUrl stringByAppendingString:[i objectForKey:@"file_path"]]];
                    [ImageHelper laodFromURL:url callback:^(UIImage *image, NSURL *url) {
                        
                        if ([NetworkStatusHelper isInternetActive])
                        {
                            if ([image isEqual:[NSNull null] ] || !url) {
                                _firstImage.image = [UIImage imageNamed:@"poster.png"];
                                [ImageHelper setRoundedBorder:_firstImage];
                            }
                            else
                            {
                                _firstImage.image = image;
                                [ImageHelper setRoundedBorder:_firstImage];
                            }
                        }
                        else
                        {
                            _firstImage.image = [UIImage imageNamed:@"poster.png"];
                            [ImageHelper setRoundedBorder:_firstImage];
                        }
                    }];
                    NSLog(@"1 = %@", [i objectForKey:@"file_path"]);
                }
                j++;
            }
            
            else break;
        }
    }
}

@end
