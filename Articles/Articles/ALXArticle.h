//
//  Article.h
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALXArticle : NSObject

@property NSString *authors,*content,*date,*title,*website;
@property BOOL isSeen;
@property UIImage *image;


@end
