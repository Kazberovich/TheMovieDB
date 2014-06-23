//
//  DescriprionView.m
//  TheMovieDbClient
//
//  Created by mac-214 on 05.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "DescriprionView.h"

@implementation DescriprionView : UIView

@synthesize description = _description;
@synthesize genre = _genre;

- (void) dealloc
{
    [_description release];
    [_genre release];
    [super dealloc];
}

- (void) fillBlock: (NSDictionary* ) fillInfo
{
    NSDictionary *genres = [fillInfo objectForKey:@"genres"];
    NSString *str = @"";
    
    if(![[fillInfo objectForKey:@"genres"]isEqual:[NSNull null]])
    {
        for (id genItem in genres)
        {
            str = [str stringByAppendingString:[genItem objectForKey:@"name"]] ;
            str = [str stringByAppendingString:@", "];
        }
        if ([str length] > 0) {
            str = [str substringToIndex:[str length] - 2]; // delete " ," in the end
        }
        _genre.text = str;
    }
    else
    {
        _genre.text = @"No info";
    }
    
    NSString *description = [fillInfo objectForKey:@"overview"];
    if(![[fillInfo objectForKey:@"overview"]isEqual:[NSNull null]])
    {
        _description.text = description;
    }
    else
    {
        _description.text = @"no info";
    }
}

@end
                                                                                                                                                                                                                                                                                                                   