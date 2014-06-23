//
//  ViewLoader.m
//  TheMovieDbClient
//
//  Created by mac-214 on 30.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "ViewLoader.h"

@implementation ViewLoader


+ (id) loadView: (Class)cls
{
   return  [self loadView:cls fromNibNamed:NSStringFromClass(cls)];
}

+ (id) loadView: (Class)cls fromNibNamed:(NSString*)nibName
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];    
    id view = nil;
    
    for(id currentObj in topLevelObjects)
    {
        if([currentObj isKindOfClass:cls])
        {
            view = currentObj;
            break;
        }
    }
    assert(view != nil);
    return view;
}


@end
