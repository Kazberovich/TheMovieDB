//
//  BackDropsView.h
//  TheMovieDbClient
//
//  Created by mac-214 on 05.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>

#define backdropsHeigh 115.0f

@interface BackDropsView : UIView

@property (nonatomic, retain) IBOutlet UIImageView *firstImage;
@property (nonatomic, retain) IBOutlet UIImageView *secondImage;
@property (nonatomic, retain) IBOutlet UIButton *moreButton;

- (void) fillBlock:(NSDictionary*) images;
- (void) setSecondImageFromUrl:(UIImage *)secondImage;
- (void) setFirstImageFromUrl:(UIImage *)firstImage;

@end
