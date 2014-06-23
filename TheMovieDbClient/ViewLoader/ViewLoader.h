//
//  ViewLoader.h
//  TheMovieDbClient
//
//  Created by mac-214 on 30.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewLoader : NSObject

+ (id) loadView: (Class)cls;
+ (id) loadView: (Class)cls fromNibNamed:(NSString*)nibName;

@end
