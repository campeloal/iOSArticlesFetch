//
//  ArticlesManager.h
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALXHTTPRequest.h"
@class ALXArticleModel;

@protocol ArticleProtocol <NSObject>

@required

-(void) updateArticles;
-(void) couldNotUpdate;

@end

@interface ALXArticlesManager : NSObject<HTTPRequestProtocol>


@property (nonatomic, assign) id delegate;

+ (instancetype)sharedModel;

-(ALXArticleModel*) getArticleAtIndex:(NSInteger) index;
-(NSUInteger) getNumberOfArticles;
-(void) setArticleIsRead:(NSInteger) index;
-(void) sortArticleByTitle;
-(void) sortArticleByAuthor;
-(void) sortArticleByDate;
-(void) loadArticles;

@end
