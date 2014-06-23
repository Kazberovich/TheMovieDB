//
//  ImageHelper.h
//  TheMovieDbClient
//
//  Created by mac-214 on 31.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface ImageHelper : NSObject

+ (void) laodFromURL: (NSURL*) url callback:(void (^)(UIImage *image, NSURL *url)) callback;
+ (void) setRoundedBorder: (UIImageView*)imageView;
@end
