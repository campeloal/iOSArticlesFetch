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


/**
 *  Since it's a this class implements a Singleton
 *it's not allowed to call the init mehtod
 *
 *  @return nil
 */
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ALXArtitclesManager sharedModel]"
                                 userInfo:nil];
    return nil;
}

/**
 *  Class method to implement the Singleton
 *
 *  @return the instance of the class
 */
+ (instancetype)sharedModel
{
    static ALXArticlesManager *sharedModel = nil;
    
    if (!sharedModel) {
        sharedModel = [[self alloc] initPrivate];
    }
    
    return sharedModel;
}

/**
 *  Private init method
 *
 *  @return the instance of the class
 */
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

/**
 *  Load articles from database. If there's no data, load from
 *the url
 */
-(void) loadArticles
{
    if(![self loadArticlesFromDatabase])
    {
        [self getRequest];
    }
    
}

/**
 *  Load the articles using the Core Data
 *
 *  @return is there's no data, return no
 */
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


/**
 *  Implementation of the HTTPRequestProtocol to get the articles
 */
-(void) getRequest
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

/**
 *  Filter JSON information and store into the Article model
 *
 *  @param jsonArray json file to be filtered
 */
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

/**
 *  Check if the url is not null
 *
 *  @param url url to be analyzed
 *
 *  @return if it exists
 */
-(BOOL) urlExists:(NSString*) url
{
    if(![url isKindOfClass:[NSNull class]])
    {

        return YES;
    }
    
    return NO;
}


/**
 *  Set the article attribute isRead
 *
 *  @param index article position in array
 */
-(void) setArticleIsRead:(NSInteger) index
{
    ALXArticleModel *article = [_articles objectAtIndex:index];
    article.isRead = @"Read";
    
    [self updateArticle:index];
}

/**
 *  Update article's attributes
 *
 *  @param index article position in the array
 */
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

/**
 *  Save the articles into the database
 */
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

/**
 *  Access a specific article
 *
 *  @param index article position in array
 *
 *  @return the article
 */
-(ALXArticleModel*) getArticleAtIndex:(NSInteger) index
{
    return [_articles objectAtIndex:index];
}

/**
 *  Number of articles in array
 *
 *  @return number of articles
 */
-(NSUInteger) getNumberOfArticles
{
    return _articles.count;
}

/**
 *  Sort the articles by titles
 */
-(void) sortArticleByTitle
{
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [_articles sortedArrayUsingDescriptors:descriptors];
    _articles = [NSMutableArray arrayWithArray:sortedArray];
    
    [_delegate updateArticles];
}

/**
 *  Sort the articles by author
 */
-(void) sortArticleByAuthor
{
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"authors" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [_articles sortedArrayUsingDescriptors:descriptors];
    _articles = [NSMutableArray arrayWithArray:sortedArray];
    
    [_delegate updateArticles];
}

/**
 *  Sort the articles by date
 */
-(void) sortArticleByDate
{
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
    NSArray *sortedArray = [_articles sortedArrayUsingDescriptors:descriptors];
    _articles = [NSMutableArray arrayWithArray:sortedArray];
    
    [_delegate updateArticles];
}

@end
