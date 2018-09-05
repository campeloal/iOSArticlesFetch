//
//  Article.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXArticleModel.h"

@implementation ALXArticleModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isRead = @"";
    }
    return self;
}

@end
