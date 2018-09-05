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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UIView *borderImage;

@end

@implementation ALXArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTextView];
    
    _titleLabel.text = _artTitle;
    _authorLabel.text = _artAuthor;
    _dateLabel.text = _artDate;
    _websiteLabel.text = _artWebsite;
    
    if(_artImage)
        _imageView.image = _artImage;

}

-(void)viewDidAppear:(BOOL)animated
{
    //Set text view offset to go to the top later
    [_contentTextView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  Setup the text view parameters as paragraph style
 */
-(void)setupTextView
{
    //Set textview spacing
    float spacing = 50.0f;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = spacing;
    paragraphStyle.maximumLineHeight = spacing;
    paragraphStyle.minimumLineHeight = spacing;
    
    NSDictionary *ats = @{/*NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),*/
                          NSParagraphStyleAttributeName : paragraphStyle,
                          };
    
    _contentTextView.attributedText = [[NSAttributedString alloc] initWithString:_artContent attributes:ats];
    int fontSize = 25;
    _contentTextView.font = [UIFont systemFontOfSize:fontSize];
    _contentTextView.textColor = [UIColor whiteColor];
    _contentTextView.textAlignment = NSTextAlignmentJustified;
}

@end
