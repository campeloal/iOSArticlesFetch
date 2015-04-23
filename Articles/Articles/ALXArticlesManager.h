//
//  ArticlesManager.h
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALXHTTPRequest.h"
@class ALXArticle;

@protocol ArticleProtocol <NSObject>

@required

-(void) updateArticles;

@end

@interface ALXArticlesManager : NSObject<HTTPRequestProtocol>


@property (nonatomic, assign) id delegate;

-(ALXArticle*) getArticleAtIndex:(NSInteger) index;
-(NSUInteger) getNumberOfArticles;

@end
