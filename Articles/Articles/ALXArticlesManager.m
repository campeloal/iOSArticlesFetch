//
//  ArticlesManager.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXArticlesManager.h"
#import "Article.h"
#import "ALXArticleModel.h"
#import "ALXAppDelegate.h"
#import <AFNetworking/AFNetworking.h>

NSString * const fetchURL = @"http://www.ckl.io/challenge/";

@interface ALXArticlesManager()

@property NSMutableArray *articles;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property ALXAppDelegate *appDelegate;

@end

@implementation ALXArticlesManager


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ALXArtitclesManager sharedModel]"
                                 userInfo:nil];
    return nil;
}

+ (instancetype)sharedModel
{
    static ALXArticlesManager *sharedModel = nil;
    
    if (!sharedModel) {
        sharedModel = [[self alloc] initPrivate];
    }
    
    return sharedModel;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _articles = [[NSMutableArray alloc] init];
        
        _appDelegate = (ALXAppDelegate *)[[UIApplication sharedApplication] delegate];
        _context = _appDelegate.managedObjectContext;
        
    }
    return self;
}

-(void) loadArticles
{
    if(![self loadArticlesFromDatabase])
    {
        [self fetchURL];
    }
    
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
        ALXArticleModel *newArticle = [[ALXArticleModel alloc] init];
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
    
    [self saveArticles];
    
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

-(void) setArticleIsRead:(NSInteger) index
{
    ALXArticleModel *article = [_articles objectAtIndex:index];
    article.isRead = @"Read";
    
    [self updateArticle:index];
}

-(ALXArticleModel*) getArticleAtIndex:(NSInteger) index
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

- (BOOL)loadArticlesFromDatabase
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    request.entity = entity;
    
    NSError *error;
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    _articles = [[NSMutableArray alloc] initWithArray:result];
    
    if (_articles.count > 0)
    {
        [_delegate updateArticles];
        return YES;
    }
    
    return NO;
}

-(void) updateArticle:(NSInteger) index
{
    ALXArticleModel *article = [_articles objectAtIndex:index];
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"Article"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"title==%@",article.title];
    fetchRequest.predicate=predicate;
    Article *articleCD=[[self.context executeFetchRequest:fetchRequest error:nil] lastObject];
    
    articleCD.title = article.title;
    articleCD.authors = article.authors;
    articleCD.content = article.content;
    articleCD.website = article.website;
    articleCD.date = article.date;
    articleCD.image = article.image;
    articleCD.isRead = article.isRead;
    
    [_appDelegate saveContext];
}

-(void) saveArticles
{
    for (ALXArticleModel *article in _articles)
    {
        Article *articleCD = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.context];
        articleCD.title = article.title;
        articleCD.authors = article.authors;
        articleCD.content = article.content;
        articleCD.website = article.website;
        articleCD.date = article.date;
        articleCD.image = article.image;
        articleCD.isRead = article.isRead;
        
    }
    
    [_appDelegate saveContext];
}

@end
