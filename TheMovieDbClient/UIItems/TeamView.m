//
//  TeamView.m
//  TheMovieDbClient
//
//  Created by mac-214 on 10.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

///3/movie/{id}/credits

//http://api.themoviedb.org/3/movie/68716/credits?api_key=48ed176d044976544817d2b4f21f3567

#import "TeamView.h"

@implementation TeamView

@synthesize director = _director;
@synthesize actors = _actors;

- (void) dealloc
{
    [_director release];
    [_actors release];
    [super dealloc];
}

- (void) fillBlock: (NSDictionary*) fillData;
{
    //actors
    NSDictionary *actors = [fillData objectForKey:@"cast"];
    NSLog(@"actors: \n%@", actors);
    NSString *str = @"";
    
    for(id actor in actors)
    {
        str = [str stringByAppendingString:[actor objectForKey:@"name"]];
        str = [str stringByAppendingString:@", "];
    }
    
    if ([str length] > 0) {
        
        str = [str substringToIndex:[str length] - 2]; // delete " ," in the end
    }
    else
    {
        NSLog(@"TeamView:fillBlock = Empty actors string");
        _actors.text = @"no info";
    }
    _actors.text = str;
    
    //directors
    NSDictionary *directors = [fillData objectForKey:@"crew"];
    NSLog(@"crew: \n%@", directors);
    
    NSString *stringDirector = @"";
    
    for (id director in directors){
        
        if (![[director objectForKey:@"job"]isEqual:[NSNull null]] && [[director objectForKey:@"job"] isEqualToString:@"Director"]) {
            stringDirector = [stringDirector stringByAppendingString:[director objectForKey:@"name"]];
            stringDirector = [stringDirector stringByAppendingString:@", "];
        }
    }
    
    if ([stringDirector length] > 0) {
        stringDirector = [stringDirector substringToIndex:[stringDirector length] - 2]; // delete " ," in the end
        _director.text = stringDirector;
    }
    else
    {
        NSLog(@"TeamView:fillBlock = Empty Director string");
        _director.text = @"no info";
    }
}

@end
