//
//  main.m
//  TheMovieDbClient
//
//  Created by mac-214 on 22.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

void handler (NSException *exception)
{
    NSLog(@"%@", exception);
}

int main(int argc, char * argv[])
{
    @autoreleasepool
    {
        @try
        {
            NSSetUncaughtExceptionHandler(handler);
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *e) {
            NSLog(@"%@", e);
        }
    }
}

