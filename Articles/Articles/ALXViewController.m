//
//  ViewController.m
//  Articles
//
//  Created by Alex De Souza Campelo Lima on 4/22/15.
//  Copyright (c) 2015 Alex De Souza Campelo Lima. All rights reserved.
//

#import "ALXViewController.h"

@interface ALXViewController ()

@property ALXArticlesManager *artManager;

@end

@implementation ALXViewController

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

-(void) updateArticles
{
    NSLog(@"articles %@",_artManager.articles);
}

@end
