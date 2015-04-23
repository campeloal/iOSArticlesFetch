//
//  ViewController.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXArticleTableViewController.h"
#import "ALXArticle.h"
#import "ALXArticleTableViewCell.h"
#import "ALXArticleDetailViewController.h"
#import "ALXSortViewController.h"
#import <POP/POP.h>

@interface ALXArticleTableViewController ()

@property ALXArticlesManager *artManager;
@property (strong, nonatomic) IBOutlet UITableView *artTableView;
@property UIView *sortView;

@end

@implementation ALXArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _artManager = [[ALXArticlesManager alloc] init];
    _artManager.delegate = self;
    
    [_artManager fetchURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [_artTableView reloadData];
}

-(void) couldNotUpdate
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"It wasn't possible to connect" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

-(void) updateArticles
{
    [_artTableView reloadData];
    [self animateTableViewCells];
}

#pragma mark - Animations

-(void) animateSortView
{
    POPSpringAnimation *bounceAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    bounceAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.05, 1.05)];
    bounceAnimation.springBounciness = 35.f;
    [_sortView.layer pop_addAnimation:bounceAnimation forKey:@"bounceAnimArticle"];
}

-(void)animateTableViewCells
{
    NSArray *rows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in rows) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        POPSpringAnimation *posXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        posXAnimation.fromValue = @(600);
        posXAnimation.springBounciness = 16;
        posXAnimation.springSpeed =10;
        [cell.layer pop_addAnimation:posXAnimation forKey:@"bounceAnimArticle"];
    }
}

-(void) animateViewControllerTransition:(ALXArticleDetailViewController*) detail
{
    POPSpringAnimation *posXAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    POPSpringAnimation *sizeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    
    posXAnimation.fromValue = @(600);
    posXAnimation.springBounciness = 16;
    posXAnimation.springSpeed =10;
    
    sizeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(64, 114)];
    
    [detail.view.layer pop_addAnimation:posXAnimation forKey:@"posXAnimArticle"];
    [detail.view.layer pop_addAnimation:sizeAnimation forKey:@"sizeAnimArticle"];
}

#pragma mark - Table view

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_artManager getNumberOfArticles];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    ALXArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[ALXArticleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ALXArticle *article = [_artManager getArticleAtIndex:indexPath.row];
    UIImage *artImage = article.image;
    
    if (artImage)
    {
        cell.image.image = article.image;
    }
    
    cell.title.text = article.title;
    cell.date.text = article.date;
    cell.author.text = article.authors;
    
    if (!article.isSeen)
    {
        cell.artSeenLabel.hidden = YES;
    }
    else
    {
        cell.artSeenLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_artManager setArticleIsSeen:indexPath.row];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showContent"])
    {
        
        ALXArticleDetailViewController*detail = (ALXArticleDetailViewController*)[segue destinationViewController];
        
        NSIndexPath *index = [self.artTableView indexPathForSelectedRow];
        
        ALXArticle *article = [_artManager getArticleAtIndex:index.row];
        
        detail.artContent = article.content;
        detail.artTitle = article.title;
        detail.artDate = article.date;
        detail.artContent = article.content;
        detail.artAuthor = article.authors;
        detail.artWebsite = article.website;
        
        if (article.image)
        {
            detail.artImage = article.image;
        }
        
        [self animateViewControllerTransition:detail];
        
    }
}

- (IBAction)showSortView:(id)sender
{
    [self freezeTableView];
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    float sortViewWidth = screenWidth*0.8;
    float sortViewHeight = screenHeight*0.6;
    
    float centerX = screenWidth/2 - sortViewWidth/2;
    float centerY = screenHeight/2 - sortViewHeight/2;
    
    _sortView = [[UIView alloc] initWithFrame:CGRectMake(centerX,centerY, sortViewWidth, sortViewHeight)];
    
    _sortView.backgroundColor = [UIColor brownColor];
    
    [self.view addSubview:_sortView];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.8, 0.8)];
    scaleAnimation.springBounciness = 20.f;
    [_sortView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
}

-(void) freezeTableView
{
    _artTableView.scrollEnabled = NO;
    
    NSArray *rows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in rows) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        cell.userInteractionEnabled = NO;
    }
}

-(void) unfreezeTableView
{
    _artTableView.scrollEnabled = YES;
    
    NSArray *rows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in rows) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        cell.userInteractionEnabled = YES;
    }
}

@end
