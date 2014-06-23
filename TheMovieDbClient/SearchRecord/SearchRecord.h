//
//  SearchRecord.h
//  TheMovieDbClient
//
//  Created by mac-214 on 28.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchRecord : NSManagedObject
{
    NSString * typedRequest;
}

@property (nonatomic, retain) NSString * typedRequest;

@end
