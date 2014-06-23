//
//  DescriprionView.h
//  TheMovieDbClient
//
//  Created by mac-214 on 05.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>

#define descriptionHeight 140.0f

@interface DescriprionView : UIView

@property (nonatomic, retain) IBOutlet UILabel *description;
@property (nonatomic, retain) IBOutlet UILabel *genre;

- (void) fillBlock: (NSDictionary* ) fillInfo;

@end
