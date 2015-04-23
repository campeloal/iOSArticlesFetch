//
//  ALXArticleDetailViewController.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXArticleDetailViewController.h"

@interface ALXArticleDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation ALXArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTextView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [_contentTextView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTextView
{
    //Set textview spacing
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 50.0f;
    paragraphStyle.maximumLineHeight = 50.0f;
    paragraphStyle.minimumLineHeight = 50.0f;
    
    NSDictionary *ats = @{
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    
    _contentTextView.attributedText = [[NSAttributedString alloc] initWithString:_content attributes:ats];
    _contentTextView.textColor = [UIColor whiteColor];
    _contentTextView.font = [UIFont systemFontOfSize:25];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
