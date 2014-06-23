//
//  DownloadHelper.m
//  TheMovieDbClient
//
//  Created by mac-214 on 06.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "DownloadHelper.h"


@implementation DownloadHelper

- (void) dealloc
{
    [super dealloc];
}

+ (NSURL *) getUserIdURL: (NSString*) sessionId
{
    return [NSURL URLWithString:[self append:baseApiUrl, accountPartofUrl, api_key, ampersant, sessionIdPart, sessionId, nil]];
}

+ (NSURL *) getWatchlistUrl: (NSString*) sessionId : (NSString*)userId
{
    return [NSURL URLWithString:[self append:baseApiUrl, accountPartofUrl, slash, userId, movieWatchlistPart, api_key, ampersant, sessionIdPart, sessionId, nil]];
}

+ (NSURL*) getImageURLWithShortcut:(NSString *)shortcut
{
    return [NSURL URLWithString:[self append:baseApiImageUrl, shortcut, nil]];    
}

+ (NSString*) getSimilarMoviesURLForId: (NSString*) movieId
{
    NSString *fullUrl = [self append:baseApiUrl, basicMovieInfoUrl, movieId, similarMoviesPartOfUrl, api_key, nil];
    NSLog(@"FUll: %@", fullUrl);
    return fullUrl;
}

+ (NSString*) getBasicMovieInformationUrl: (NSString*) movId
{
    NSLog(@"getBasicMovieInformationURL: id = %@", movId);
    NSString* fullUrl = [self append: baseApiUrl, basicMovieInfoUrl, movId, api_key, nil];
    NSLog(@"Full URL = %@", fullUrl);
    
    return fullUrl;
}

+ (NSString*) getTeamMovieUrlForId: (NSString*) movieId{
    
    NSString *fullUrl = [self append:baseApiUrl, basicMovieInfoUrl, movieId, teamPartOfUrl, api_key, nil];
    NSLog(@"Full URL = %@", fullUrl);
    return fullUrl;
}

+ (NSString*) getBackdropsUrlForId: (NSString*) movieId{
    
    NSString *fullUrl = [self append:baseApiUrl, basicMovieInfoUrl, movieId, backdropsUrl, api_key, nil];
    NSLog(@"Full URL = %@", fullUrl);
    return fullUrl;
}

+ (NSString *) append:(id) first, ...
{
    NSString * result = @"";
    id eachArg;
    va_list alist;
    if(first)
    {
    	result = [result stringByAppendingString:first];
    	va_start(alist, first);
    	while((eachArg = va_arg(alist, id)))
        {
    		result = [result stringByAppendingString:eachArg];
        }
    	va_end(alist);
    }
    NSLog(@"%@", result);
    return result;
}

@end
