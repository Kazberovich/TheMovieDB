//
//  SimilarMoviesView.h
//  TheMovieDbClient
//
//  Created by mac-214 on 12.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>

#define similarMoviesHeight 200.0f

@interface SimilarMoviesView : UIView

@property (nonatomic, retain) IBOutlet UILabel *firstSMName;
@property (nonatomic, retain) IBOutlet UILabel *secondSMName;
@property (nonatomic, retain) IBOutlet UIImageView *firstSMPoster;
@property (nonatomic, retain) IBOutlet UIImageView *secondSMPoster;
@property (nonatomic, retain) IBOutlet UILabel *firstSMRating;
@property (nonatomic, retain) IBOutlet UILabel *secondSMRating;
@property (nonatomic, retain) IBOutlet UIButton *moreButton;
@property (nonatomic, retain) IBOutlet UIView *stars1;
@property (nonatomic, retain) IBOutlet UIView *stars2;

- (void) fillBlock:(NSDictionary*) fillInfo;

@end
