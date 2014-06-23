//
//  ApiLoadService.m
//  TheMovieDbClient
//
//  Created by mac-214 on 10.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "ApiLoadService.h"
#import "DownloadHelper.h"
#import "NetworkStatusHelper.h"

@implementation ApiLoadService

+ (void) getResponseForURL: (NSURL*) url callback:(void (^)(NSDictionary *dictionary, NSURL *url)) callback
{
    if(!url)
    {
        NSLog(@"ApiLoadService:getresponseForURL = Incorrect url");
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
           if ([NetworkStatusHelper isInternetActive])
           {
               NSData *responseData = [NSData dataWithContentsOfURL:url];
               if(!responseData)
               {
                   NSLog(@"ApiLoadService:getresponseForURL = incorrect responseData");
                   callback(nil, url);
               }
               else
               {
                   NSError * error;
                   NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       callback(responseJson, url);
                   });
               }
           }

        });
    }
}


+ (void) actionWithWatchlist: (BOOL) addOrRemove :(NSString*) filmId  callback:(void (^)(NSDictionary *dictionary)) callback
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if ([NetworkStatusHelper isInternetActive])
        {
            NSDictionary *newDatasetInfo = [[NSDictionary alloc ] initWithObjectsAndKeys: filmId, @"movie_id", addOrRemove ? @(YES) : @(NO), @"movie_watchlist", nil];
            NSLog(@"%@", newDatasetInfo);
            NSError*error;
            
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:newDatasetInfo options:kNilOptions error:&error];
            
            [newDatasetInfo release];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[DownloadHelper getWatchlistUrl:[[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"] :[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:jsonData];
            
            NSURLResponse *response;
            NSData *jsonDataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            [request release];
            
            NSDictionary *results = jsonDataResponse ? [NSJSONSerialization JSONObjectWithData:jsonDataResponse options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(results)
                {
                    callback(results);
                }
                else
                {
                    callback(nil);
                }
            });
        }
        else
        {

        }
    });
}

@end
