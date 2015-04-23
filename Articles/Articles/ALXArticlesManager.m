//
//  ArticlesManager.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXArticlesManager.h"
#import "ALXArticle.h"
#import <AFNetworking/AFNetworking.h>

NSString * const fetchURL = @"http://www.ckl.io/challenge/";

@interface ALXArticlesManager()

@property NSMutableArray *articles;

@end

@implementation ALXArticlesManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _articles = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) fetchURL
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:fetchURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //Do not freeze UI
         [self performSelectorInBackground:@selector(parseJSON:) withObject:responseObject];
         
     }
         failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [_delegate couldNotUpdate];
         NSLog(@"Error: %@", error);
     }];
    
    
}

-(void) parseJSON: (NSArray*) jsonArray
{
    
    for (NSDictionary* article in jsonArray)
    {
        ALXArticle *newArticle = [[ALXArticle alloc] init];
        newArticle.title = [article objectForKey:@"title"];
        newArticle.website = [article objectForKey:@"website"];
        newArticle.authors = [article objectForKey:@"authors"];
        newArticle.content = [article objectForKey:@"content"];
        newArticle.date = [article objectForKey:@"date"];
        
        NSString *imageURL = [article objectForKey:@"image"];
       
        if ([self urlExists:imageURL])
        {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            
            newArticle.image = [UIImage imageWithData:imageData];
                
            [_articles addObject:newArticle];
            
        }
        else
        {
            newArticle.image = nil;
        }
        
        
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [_delegate updateArticles];
}

-(BOOL) urlExists:(NSString*) url
{
    if(![url isKindOfClass:[NSNull class]])
    {

        return YES;
    }
    
    return NO;
}

-(void) setArticleIsSeen:(NSInteger) index
{
    ALXArticle *article = [_articles objectAtIndex:index];
    article.isSeen = YES;
}

-(ALXArticle*) getArticleAtIndex:(NSInteger) index
{
    return [_articles objectAtIndex:index];
}

-(NSUInteger) getNumberOfArticles
{
    return _articles.count;
}

-(void) sortArticleByTitle
{
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [_articles sortedArrayUsingDescriptors:descriptors];
    _articles = [NSMutableArray arrayWithArray:sortedArray];
    
    [_delegate updateArticles];
}

-(void) sortArticleByAuthor
{
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"authors" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [_articles sortedArrayUsingDescriptors:descriptors];
    _articles = [NSMutableArray arrayWithArray:sortedArray];
    
    [_delegate updateArticles];
}

-(void) sortArticleByDate
{
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [_articles sortedArrayUsingDescriptors:descriptors];
    _articles = [NSMutableArray arrayWithArray:sortedArray];
    
    [_delegate updateArticles];
}

@end
