			//
//  ImageHelper.m
//  TheMovieDbClient
//
//  Created by mac-214 on 31.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//


#import "ImageHelper.h"
#define imageBaseUrl @"http://image.tmdb.org/t/p/w500"
#define kCacheDirName @"images"

static NSOperationQueue *queue;

@interface NSString (md5)

- (NSString*) md5;

@end

@implementation NSString (md5)

-(NSString*) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation ImageHelper

+ (void)initialize
{
    queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 10;
}

+ (void) setRoundedBorder: (UIImageView*)imageView
{
    CALayer * l = [imageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
}

+ (void) laodFromURL: (NSURL*) url callback:(void (^)(UIImage *image, NSURL *url)) callback
{
    if (!url)
    {
        NSLog(@"Incorrect url");
    }
    else
    {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cacheDir = [documentsPath stringByAppendingPathComponent:kCacheDirName];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSString *imagePath = [cacheDir stringByAppendingPathComponent:url.absoluteString.md5];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
        {
            callback([UIImage imageWithContentsOfFile:imagePath], url);
        }
        else
        {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                if(data)
                {
                    [data writeToFile:imagePath atomically:YES];
                }
                UIImage *loadedImage = [UIImage imageWithData:data];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(loadedImage, url);
                });
            }];
            [queue addOperation:operation];
        }
    }
}

@end
