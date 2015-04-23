//
//  ViewController.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXArticleTableViewController.h"
#import "ALXArticleModel.h"
#import "ALXArticleTableViewCell.h"
#import "ALXArticleDetailViewController.h"
#import "ALXAnimationsAndEffects.h"

@interface ALXArticleTableViewController ()

@property ALXArticlesManager *artManager;
@property (strong, nonatomic) IBOutlet UITableView *artTableView;
@property ALXAnimationsAndEffects *animationsAndEffects;
@property UIView *sortView;
@property UIImageView *blurView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;
@property BOOL isSortHidden;

@end

@implementation ALXArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _artManager = [ALXArticlesManager sharedModel];
    _artManager.delegate = self;
    [self hideSortBarButtonItem];
    
    [_artManager loadArticles];
    
    _animationsAndEffects = [[ALXAnimationsAndEffects alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [_artTableView reloadData];
}

-(void) hideSortBarButtonItem
{
    _sortButton.title = @"";
    _isSortHidden = YES;
    
}

-(void) unhideSortBarButtonItem
{
    _sortButton.title = @"Sort";
    _isSortHidden = NO;
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
    
    [self unhideSortBarButtonItem];
}

#pragma mark - Animations

-(void)animateTableViewCells
{
    NSArray *rows = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *path in rows) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        
        [_animationsAndEffects slideFromTheRight:cell.layer FromValue:600 Bounciness:16 WithSpeed:10];
    }
}

-(void) animateViewControllerTransition:(ALXArticleDetailViewController*) detail
{
    [_animationsAndEffects slide:detail.view.layer FromValue:600 WithBounciness:16 Speed:10 AndResizeWidth:64 Height:114];
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
    
    
    ALXArticleModel *article = [_artManager getArticleAtIndex:indexPath.row];
    UIImage *artImage = article.image;
    
    if (artImage)
    {
        cell.image.image = article.image;
    }
    else
    {
        cell.image.image = [UIImage imageNamed:@"no_icon.png"];
    }
    
    cell.title.text = article.title;
    cell.date.text = article.date;
    cell.author.text = article.authors;
    cell.isReadLabel.text = article.isRead;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_artManager setArticleIsRead:indexPath.row];
    
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

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self showSortView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showContent"])
    {
        
        ALXArticleDetailViewController*detail = (ALXArticleDetailViewController*)[segue destinationViewController];
        
        NSIndexPath *index = [self.artTableView indexPathForSelectedRow];
        
        ALXArticleModel *article = [_artManager getArticleAtIndex:index.row];
        
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

-(void) showSortView
{
    UIImage *blur = [_animationsAndEffects captureBlurInView:self.view];
    _blurView = [[UIImageView alloc] initWithImage:blur];
    
    [self hideSortBarButtonItem];
    
    [self freezeTableView];
    
    [self.view addSubview:_blurView];
    
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    float sortViewWidth = screenWidth*0.8;
    float sortViewHeight = screenHeight*0.6;
    
    float centerX = screenWidth/2 - sortViewWidth/2;
    float centerY = screenHeight/2 - sortViewHeight/2;
    
    float red = 0.0;
    float green = 0.53;
    float blue = 1.0;
    
    _sortView = [[UIView alloc] initWithFrame:CGRectMake(centerX,centerY, sortViewWidth, sortViewHeight)];
    
    _sortView.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    
    [self createSortButtonsInView:_sortView];
    
    [self.view addSubview:_sortView];
    
    [_animationsAndEffects scaleAnimation:_sortView.layer WithBounciness:20.f ToValueWidth:0.8 Height:0.8];
}

- (IBAction)sortRequest:(id)sender
{
    const float initialYContentOffset = -64.0f;
    
    if(!_isSortHidden)
    {
        //If didn't scroll the table view, show sort view
        if (_artTableView.contentOffset.y == initialYContentOffset)
        {
            [self showSortView];
        }
        //Otherwise, scroll to the top and then show sort view
        else
        {
            [_artTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        }
    }
}

-(void) createSortButtonsInView:(UIView*) view
{
    //Name Button
    UIButton *sortByTitle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sortByTitle addTarget:self
               action:@selector(sortByTitle)
     forControlEvents:UIControlEventTouchUpInside];
    [sortByTitle setTitle:@"Sort By Name" forState:UIControlStateNormal];
    
    float buttonWidth = view.frame.size.width*0.8;
    float buttonHeight = view.frame.size.height*0.2;
    float posX = view.frame.size.width/2 - buttonWidth/2;
    float posY = view.frame.size.height/2 - buttonHeight/2;
    float red = 0.0;
    float green = 0.89;
    float blue = 0.73;
    float offset = 1.1;
    
    sortByTitle.frame = CGRectMake(posX, posY - buttonHeight*offset, buttonWidth, buttonHeight);
    sortByTitle.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    int fontSize = 25;
    sortByTitle.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:sortByTitle];
    
    //Author Button
    UIButton *sortByAuthor = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sortByAuthor addTarget:self
                   action:@selector(sortByAuthor)
         forControlEvents:UIControlEventTouchUpInside];
    [sortByAuthor setTitle:@"Sort By Author" forState:UIControlStateNormal];
    
    sortByAuthor.frame = CGRectMake(posX, posY, buttonWidth, buttonHeight);
    sortByAuthor.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    sortByAuthor.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:sortByAuthor];
    
    //Date Button
    UIButton *sortByDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sortByDate addTarget:self
                   action:@selector(sortByDate)
         forControlEvents:UIControlEventTouchUpInside];
    [sortByDate setTitle:@"Sort By Date" forState:UIControlStateNormal];
    
    sortByDate.frame = CGRectMake(posX, posY + buttonHeight*offset, buttonWidth, buttonHeight);
    sortByDate.backgroundColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    sortByDate.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [view addSubview:sortByDate];
    
}

-(void) sortByTitle
{
    [_artManager sortArticleByTitle];
    
    [self unfreezeTableView];
    
    [self unhideSortBarButtonItem];
    
    [_sortView removeFromSuperview];
    [_blurView removeFromSuperview];
    
}

-(void) sortByAuthor
{
    [_artManager sortArticleByAuthor];
    
    [self unfreezeTableView];
    
    [self unhideSortBarButtonItem];
    
    [_sortView removeFromSuperview];
    [_blurView removeFromSuperview];
    
}

-(void) sortByDate
{
    [_artManager sortArticleByDate];
    
    [self unfreezeTableView];
    
    [self unhideSortBarButtonItem];
    
    [_sortView removeFromSuperview];
    [_blurView removeFromSuperview];
    
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
